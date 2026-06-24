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
    
    // MARK: - 전역 프로퍼티
    
    // 현재 선택된 그래프 범위
    // 지금은 day만 실제 구현하고, week/month는 나중에 구현
    @Published var selectedRange: GraphRange = .day
    
    // 일 단위 그래프에 표시할 데이터
    @Published var dayPoints: [GraphPoint] = []
    
    // 주 단위 그래프에 표시할 데이터
    // 주간 혈당 통계 API 응답을 WeeklyGraphPoint로 변환한 배열
    @Published var weekPoints: [WeeklyGraphPoint] = []
    
    // 로딩 상태
    @Published var isLoading: Bool = false
    
    // 에러 메시지
    @Published var errorMessage: String?
    
    // MARK: - 의존성
    
    // 혈당 기록 조회 서비스
    // 일 단위 그래프 서비스는 혈당뷰와 혈당입력뷰에 있는 서비스를 가져다 씁니다.
    private let bloodSugarService: BloodSugarServiceProtocol
    
    // 주간/월간 그래프용 서비스
    private let graphService: GraphServiceProtocol
    
    // NotificationCenter 구독을 저장하는 변수
    // 이 변수를 보관하지 않으면 구독이 바로 해제될 수 있음
    private var cancellables = Set<AnyCancellable>()
    
    init(bloodSugarService: BloodSugarServiceProtocol, graphService: GraphServiceProtocol) {
        self.bloodSugarService = bloodSugarService
        self.graphService = graphService
        
        // 혈당 기록 생성/수정/삭제 알림을 감지하도록 설정 - 일간 그래프 갱신에만 사용합니다.
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
    
    // 정책:
    // - 일간: 이미 데이터가 있으면 재호출하지 않음
    // - 주간: 처음 주 탭에 진입했을 때만 호출
    // - 월간: 아직 미구현
    func loadGraphIfNeeded(for range: GraphRange) async {
        switch range {
        case .day:
            if dayPoints.isEmpty {
                await loadTodayGraph()
            }

        case .week:
            if weekPoints.isEmpty {
                await loadWeeklyGraph()
            }

        case .month:
            // 월간 그래프는 추후 구현 예정
            break
        }
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
    
    // 주간 혈당 그래프 데이터로 변환
    func loadWeeklyGraph() async {
        isLoading = true
        errorMessage = nil

        do {
            // 현재 날짜가 포함된 주의 월요일 날짜를 구함
            let monday = startOfWeek(from: Date())

            // 월요일 Date를 yyyy-MM-dd 문자열로 변환
            let weekStartDate = DateStringFormatter.dateString(from: monday)

            // 주간 혈당 통계 API 호출
            let response = try await graphService.fetchWeeklyGraph(
                date: weekStartDate
            )

            // WeeklyGraphResponseDTO를 주간 그래프 화면용 모델로 변환
            weekPoints = WeeklyGraphMapper.map(from: response)
        } catch {
            errorMessage = "주간 혈당 그래프 데이터를 불러오지 못했어요."
            print("혈당 주간 그래프 조회 실패:", error)
        }
        isLoading = false
    }
    // 주 시작일(월요일)을 계산하는 함수
    private func startOfWeek(from date: Date) -> Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "ko_KR")
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current

        // 1 = 일요일, 2 = 월요일
        // 따라서 월요일을 한 주의 시작으로 설정
        calendar.firstWeekday = 2

        // yearForWeekOfYear와 weekOfYear를 사용하면
        // 해당 날짜가 속한 주의 시작일을 계산할 수 있음
        let components = calendar.dateComponents(
            [.yearForWeekOfYear, .weekOfYear],
            from: date
        )
        return calendar.date(from: components) ?? date
    }
}
