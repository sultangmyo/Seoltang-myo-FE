//
//  InsulinChecklistSectionView.swift
//  sugarcat
//
//  Created by 서세린 on 4/15/26.
//

import SwiftUI

// 인슐린 투여 기록 섹션 전체를 담당하는 View
// 제목 + 체크리스트 목록 + 확인 alert까지 포함
struct InsulinChecklistSectionView: View {
    
    // MARK: - StateObject
    
    // 인슐린 체크리스트의 상태와 로직을 관리하는 ViewModel
    @StateObject private var viewModel: InsulinChecklistViewModel
    
    // 다음 자정에 실행될 작업을 저장해두는 상태
    // 뷰가 사라질 때 취소할 수 있도록 Task를 보관함
    @State private var midnightRefreshTask: Task<Void, Never>?
    
    
    // MARK: - Init
    
    // 외부에서 서비스를 주입받아 ViewModel을 생성
    // 지금은 HomeView에서 MockInsulinService를 넘겨줄 예정
    init(insulinService: InsulinServiceProtocol) {
        _viewModel = StateObject(
            wrappedValue: InsulinChecklistViewModel(insulinService: insulinService)
        )
    }
    
    
    // MARK: - Body
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            sectionTitle
            
            checklistListView
        }
        .padding(.horizontal, 16)
        .task {
            // 화면이 처음 그려질 때 체크리스트 로딩
            await viewModel.loadChecklist()
            
            // 자정 갱신 예약 시작
            scheduleMidnightRefresh()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            // 앱이 다시 foreground로 돌아오면 최신 날짜 기준으로 다시 로딩
            Task {
                await viewModel.loadChecklist()
                
                // foreground 진입 시점 기준으로 다음 자정 예약을 다시 잡음
                scheduleMidnightRefresh()
            }
        }
        .onDisappear {
            // 뷰가 사라질 때 예약된 자정 작업 취소
            midnightRefreshTask?.cancel()
            midnightRefreshTask = nil
        }
        .alert(
            "정말 인슐린을 투여했습니까?",
            isPresented: alertBinding
        ) {
            Button("예") {
                Task {
                    await viewModel.confirmInjection()
                }
            }
            
            Button("아니요", role: .cancel) {
                viewModel.cancelAlert()
            }
        }
    }
}


// MARK: - Subviews
private extension InsulinChecklistSectionView {
    
    // 섹션 제목
    var sectionTitle: some View {
        Text("인슐린 투여 기록")
            .mainTitleB()
            .foregroundColor(.textbg1)
    }
    
    
    // 체크리스트 목록
    var checklistListView: some View {
        VStack {
            ForEach(viewModel.items) { item in
                InsulinChecklistRowView(item: item) { sequence in
                    // 각 row의 체크 버튼을 누르면 ViewModel에 sequence 전달
                    viewModel.didTapCheckButton(sequence: sequence)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
    
    
    // alert 표시 여부를 제어하는 Binding
    // selectedSequenceForAlert가 nil이 아니면 alert 표시
    var alertBinding: Binding<Bool> {
        Binding(
            get: {
                viewModel.selectedSequenceForAlert != nil
            },
            set: { _ in }
        )
    }
}

// MARK: - Midnight Refresh
private extension InsulinChecklistSectionView {
    
    // 다음 자정이 되면 체크리스트를 다시 로딩하는 작업을 예약
    func scheduleMidnightRefresh() {
        // 기존에 예약된 작업이 있으면 먼저 취소
        midnightRefreshTask?.cancel()
        
        // 현재 시각
        let now = Date()
        let calendar = Calendar.current
        
        // "다음 자정" 계산
        guard let nextMidnight = calendar.nextDate(
            after: now,
            matching: DateComponents(hour: 0, minute: 0, second: 0),
            matchingPolicy: .nextTime
        ) else {
            return
        }
        
        // 현재 시각부터 다음 자정까지 남은 시간(초)
        let secondsUntilMidnight = nextMidnight.timeIntervalSince(now)
        
        // 자정까지 대기했다가 한 번만 실행하는 Task 생성
        midnightRefreshTask = Task {
            do {
                // 초 → 나노초 변환
                let nanoseconds = UInt64(secondsUntilMidnight * 1_000_000_000)
                
                // 자정까지 대기
                try await Task.sleep(nanoseconds: nanoseconds)
                
                // 취소되었는지 확인
                guard !Task.isCancelled else { return }
                
                // 자정이 되었으므로 새 날짜 기준으로 체크리스트 다시 로딩
                await viewModel.loadChecklist()
                
                // 다음 날 자정 갱신도 이어서 예약
                scheduleMidnightRefresh()
                
            } catch {
                // Task.sleep이 취소되면 여기로 들어올 수 있음
                // 별도 처리 없이 종료
            }
        }
    }
}
// MARK: - Preview
#Preview {
    InsulinChecklistSectionView(
        insulinService: MockInsulinService()
    )
}
