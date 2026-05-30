//
//  InsulinChecklistViewModel.swift
//  sugarcat
//
//  Created by 서세린 on 4/15/26.
//

import Foundation
import Combine

// 인슐린 투여 기록 섹션의 화면 상태와 비즈니스 로직을 담당하는 ViewModel
@MainActor
final class InsulinChecklistViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    // 화면에 그릴 최종 체크리스트 아이템 배열
    // View는 이 배열만 보고 리스트를 그림
    @Published var items: [InsulinChecklistItem] = []
    
    // alert 표시 여부를 결정하기 위한 선택된 sequence
    // nil이면 alert 비표시, 값이 있으면 해당 sequence를 대상으로 alert 표시
    @Published var selectedSequenceForAlert: Int?
    
    
    // MARK: - Dependencies
    
    // 인슐린 관련 네트워크/Mock 기능을 담당하는 서비스
    private let insulinService: InsulinServiceProtocol
    
    
    // MARK: - Init
    
    // 외부에서 서비스 주입
    // 지금은 MockInsulinService를 넣고, 나중에 RealInsulinService로 교체 가능
    init(insulinService: InsulinServiceProtocol) {
        self.insulinService = insulinService
    }
    
    
    // MARK: - Public Methods
    
    // 화면 진입 시 호출
    // 1) 인슐린 설정 조회
    // 2) 오늘 인슐린 기록 조회
    // 3) 두 데이터를 합쳐 화면용 items 생성
    func loadChecklist() async {
        do {
            // 온보딩에서 저장된 인슐린 설정 조회
            // 여기서 count를 사용해 체크리스트 개수를 결정
            let setting = try await insulinService.fetchInsulinSetting()
            
            // 오늘 인슐린 기록 조회
            // sequence별 체크 여부, 체크한 사람의 닉네임이 내려옴
            let today = DateStringFormatter.todayString()
            let response = try await insulinService.fetchTodayInsulinRecords(
                date: today
            )
            
            // 설정(count) + 기록(records)을 합쳐서 화면용 모델 생성
            items = makeChecklistItems(
                settingCount: setting.count,
                records: response.records
            )
            
        } catch {
            // 지금은 간단히 콘솔 출력만 처리
            // 나중에 에러 메시지 상태를 @Published로 빼서 화면에 표시할 수 있음
            print("인슐린 체크리스트 로딩 실패: \(error)")
        }
    }
    
    
    // 체크 버튼을 눌렀을 때 호출
    // 바로 체크하지 않고, alert를 띄우기 위한 대상 sequence만 저장
    func didTapCheckButton(sequence: Int) {
        // 현재 아이템 중 해당 sequence를 찾음
        guard let item = items.first(where: { $0.sequence == sequence }) else { return }
        
        // 이미 체크된 항목은 수정 불가이므로 아무 동작도 하지 않음
        guard item.isInjected == false else { return }
        
        // alert에서 어떤 회차를 저장할지 기억해둠
        selectedSequenceForAlert = sequence
    }
    
    
    // alert에서 "네"를 눌렀을 때 호출
    // 실제 저장 요청을 보내고, 성공하면 다시 fetch해서 최신 상태 반영
    func confirmInjection() async {
        // 현재 alert 대상으로 저장된 sequence가 없으면 종료
        guard let sequence = selectedSequenceForAlert else { return }
        
        // 오늘 날짜를 서버 요청 형식인 "yyyy-MM-dd" 문자열로 변환
        let today = DateStringFormatter.todayString()
        
        // 저장 요청 DTO 생성
        let request = InsulinCreateRequestDTO(
            isInjected: true,
            sequence: sequence,
            recordDate: today
        )
        
        do {
            // 인슐린 투여 기록 저장
            _ = try await insulinService.createInsulinRecord(request)
            
            // 저장 성공 후 alert 닫기
            selectedSequenceForAlert = nil
            
            // 다시 조회해서 최신 상태 반영
            // 여러 보호자가 함께 쓰는 앱이므로,
            // 서버 기준의 nickName을 다시 fetch해서 화면에 반영하는 방식이 안전함
            await loadChecklist()
            
        } catch {
            print("인슐린 투여 기록 저장 실패: \(error)")
        }
    }
    
    
    // alert에서 "아니요"를 눌렀을 때 호출
    // 아무 변화 없이 alert만 닫음
    func cancelAlert() {
        selectedSequenceForAlert = nil
    }
    
    
    // MARK: - Private Methods
    
    // 체크리스트 화면용 UI 모델을 만드는 함수
    // settingCount: 오늘 화면에 몇 개의 체크리스트를 그릴지 결정
    // records: 오늘 실제 저장된 인슐린 기록
    private func makeChecklistItems(
        settingCount: Int,
        records: [InsulinRecordDTO]
    ) -> [InsulinChecklistItem] {
        
        // count가 2면 1, 2 sequence를 만들어서 화면에 2개를 그림
        (1...settingCount).map { sequence in
            
            // 해당 sequence에 대한 오늘 기록이 있는지 찾음
            let matchedRecord = records.first { $0.sequence == sequence }
            
            // 기록이 있으면 체크 상태/닉네임 사용
            // 기록이 없으면 미체크 상태로 기본값 처리
            return InsulinChecklistItem(
                sequence: sequence,
                title: "\(sequence)번째 인슐린",
                isInjected: matchedRecord?.isInjected ?? false,
                injectedByNickname: matchedRecord?.nickName
            )
        }
    }
}
