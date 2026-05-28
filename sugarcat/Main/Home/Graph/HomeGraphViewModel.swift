//
//  HomeGraphViewModel.swift
//  sugarcat
//
//  Created by 서세린 on 5/26/26.
//

import Foundation
import Combine

@MainActor
final class HomeGraphViewModel: ObservableObject {
    
    // 현재 선택된 그래프 범위
    // 지금은 day만 실제 구현하고, week/month는 나중에 구현
    @Published var selectedRange: GraphRange = .day
    
    // 일 단위 그래프에 표시할 데이터
    @Published var dayPoints: [GraphPoint] = []
    
    // 로딩 상태
    @Published var isLoading: Bool = false
    
    // 에러 메시지
    @Published var errorMessage: String?
    
    // 혈당 기록 조회 서비스
    // 일 단위 그래프 서비스는 혈당뷰와 혈당입력뷰에 있는 서비스를 가져다 씁니다.
    private let bloodSugarService: BloodSugarServiceProtocol
    
    // NotificationCenter 구독을 저장하는 변수
    // 이 변수를 보관하지 않으면 구독이 바로 해제될 수 있음
    private var cancellables = Set<AnyCancellable>()
    
    init(bloodSugarService: BloodSugarServiceProtocol) {
        self.bloodSugarService = bloodSugarService
        
        // 혈당 기록 생성/수정/삭제 알림을 감지하도록 설정
        bindBloodSugarRecordUpdateNotification()
    }
    
    // 혈당 기록 변경 notification을 감지하는 함수
    private func bindBloodSugarRecordUpdateNotification() {
        NotificationCenter.default.publisher(
            for: .bloodSugarRecordsDidUpdate
        )
        .sink { [weak self] _ in
            // notification을 받으면 오늘 그래프 데이터를 다시 조회
            Task { @MainActor in
                await self?.loadTodayGraph()
            }
        }
        .store(in: &cancellables)

    }
    
    // 오늘 혈당 기록을 조회해서 그래프 데이터로 변환
    func loadTodayGraph() async {
        isLoading = true
        errorMessage = nil
        
        do {
            // 오늘 날짜 문자열 생성
            // ex: "2026-05-16"
            let today = DateStringFormatter.dateString(from: Date())
            
            // 서버 또는 MockService에서 오늘 혈당 기록 조회
            let response = try await bloodSugarService.fetchBloodSugarRecords(
                date: today
            )
            
            // DTO 배열을 그래프용 GraphPoint 배열로 변환
            dayPoints = GraphMapper.map(response.records)
            
        } catch {
            errorMessage = "혈당 그래프 데이터를 불러오지 못했어요."
            print("혈당 그래프 조회 실패:", error)
        }
        
        isLoading = false
    }
}
