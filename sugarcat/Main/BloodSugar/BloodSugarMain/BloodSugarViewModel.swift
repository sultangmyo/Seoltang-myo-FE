//
//  BloodSugarViewModel.swift
//  sugarcat
//
//  Created by 서세린 on 4/25/26.
//

import Foundation
import Combine

@MainActor
final class BloodSugarViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    // 현재 선택된 날짜
    // 화면 최초 진입 시 오늘 날짜로 시작
    @Published var selectedDate: Date = Date()
    
    // 화면에 그릴 혈당 기록 버튼 목록
    @Published var items: [BloodSugarRecordItem] = []
    
    // 로딩 상태
    @Published var isLoading: Bool = false
    
    // 에러 메시지
    @Published var errorMessage: String?
    
    
    // MARK: - Dependencies
    private let bloodSugarService: BloodSugarServiceProtocol
    
    
    // MARK: - Init
    init(bloodSugarService: BloodSugarServiceProtocol) {
        self.bloodSugarService = bloodSugarService
    }
    
    
    // MARK: - Public Methods
    // 화면 진입 시, 또는 날짜가 바뀔 때 호출
    func loadRecords() async {
        isLoading = true
        errorMessage = nil
        
        let dateString = DateStringFormatter.dateString(from: selectedDate)
        
        do {
            // 1. 온보딩에서 설정한 하루 혈당 측정 횟수 조회
            let setting = try await bloodSugarService.fetchBloodSugarSetting()
            
            // 2. 선택된 날짜의 혈당 기록 조회
            let response = try await bloodSugarService.fetchBloodSugarRecords(date: dateString)
            
            // 3. 설정 count + 기록 records를 합쳐 화면용 모델 생성
            items = makeRecordItems(
                settingCount: setting.count,
                records: response.records
            )
            
            isLoading = false
            
        } catch {
            errorMessage = "혈당 기록을 불러오지 못했어요."
            isLoading = false
            print("혈당 기록 로딩 실패: \(error)")
        }
    }
    
    
    // DatePicker에서 날짜가 바뀌었을 때 호출
    func changeDate(_ date: Date) async {
        selectedDate = date
        await loadRecords()
    }
    
    
    // 기록 저장/수정/삭제 완료 후 다시 fetch
    func refreshAfterEditing() async {
        await loadRecords()
    }
    
    
    // MARK: - Input View에서 사용할 저장 로직
    
    // 기존 기록이 없을 때 새로 저장
    func createRecord(
        sequence: Int,
        sugarValue: Int,
        recordedTime: Date
    ) async {
        print("createRecord sequence:", sequence)
        print("createRecord sugarValue:", sugarValue)
        print("createRecord recordedTime:", recordedTime)

        let dateString = DateStringFormatter.dateString(from: selectedDate)
        let timeString = DateStringFormatter.timeString(from: recordedTime)

        
        let request = BloodSugarCreateRequestDTO(
            recordedDate: dateString,
            recordedTime: timeString,
            sequence: sequence,
            sugarValue: sugarValue
        )
        
        do {
            _ = try await bloodSugarService.createBloodSugarRecord(request)
            await loadRecords()
        } catch {
            errorMessage = "혈당 기록 저장에 실패했어요."
            print("혈당 기록 저장 실패: \(error)")
        }
    }
    
    
    // 기존 기록이 있을 때 수정
    func updateRecord(
        sequence: Int,
        sugarValue: Int,
        recordedTime: Date
    ) async {
        let dateString = DateStringFormatter.dateString(from: selectedDate)
        let timeString = DateStringFormatter.timeString(from: recordedTime)
        
        let request = BloodSugarUpdateRequestDTO(
            recordedDate: dateString,
            recordedTime: timeString,
            sequence: sequence,
            sugarValue: sugarValue
        )
        
        do {
            try await bloodSugarService.updateBloodSugarRecord(request)
            await loadRecords()
        } catch {
            errorMessage = "혈당 기록 수정에 실패했어요."
            print("혈당 기록 수정 실패: \(error)")
        }
    }
    
    
    // 기존 기록을 삭제
    func deleteRecord(sequence: Int) async {
        let dateString = DateStringFormatter.dateString(from: selectedDate)
        
        do {
            try await bloodSugarService.deleteBloodSugarRecord(
                sequence: sequence,
                date: dateString
            )
            await loadRecords()
        } catch {
            errorMessage = "혈당 기록 삭제에 실패했어요."
            print("혈당 기록 삭제 실패: \(error)")
        }
    }
    
    
    // MARK: - Private Methods
    
    // setting.count 기준으로 버튼 개수를 만들고, 해당 sequence에 기록이 있으면 기록 상태로 UI 모델 생성
    private func makeRecordItems(
        settingCount: Int,
        records: [BloodSugarRecordDTO]
    ) -> [BloodSugarRecordItem] {
        
        guard settingCount > 0 else { return [] }
        
        return (1...settingCount).map { sequence in
            let matchedRecord = records.first { $0.sequence == sequence }
            
            return BloodSugarRecordItem(
                sequence: sequence,
                recordTime: matchedRecord?.recordTime,
                sugarValue: matchedRecord?.sugarValue,
                sugarStatus: matchedRecord?.sugarStatus
            )
        }
    }
}
