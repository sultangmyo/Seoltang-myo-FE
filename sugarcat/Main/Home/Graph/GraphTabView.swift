//
//  GraphTabView.swift
//  sugarcat
//
//  Created by 서세린 on 5/26/26.
//

import SwiftUI

struct GraphTabView: View {
    
    // 홈 그래프 전용 ViewModel
    @StateObject private var viewModel: HomeGraphViewModel
    
    init(
        bloodSugarService: BloodSugarServiceProtocol
    ) {
        _viewModel = StateObject(
            wrappedValue: HomeGraphViewModel(
                bloodSugarService: bloodSugarService
            )
        )
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("혈당기록")
                .mainTitleB()
                .foregroundColor(.textbg1)
                .padding(.bottom, 10)
            
            rangeButtonView
            
            Divider()
                .padding(.bottom, 12)
            
            graphContentView
        }
        .task {
            await viewModel.loadTodayGraph()
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }
}

private extension GraphTabView {
    
    // 일 / 주 / 월 선택 버튼
    var rangeButtonView: some View {
        HStack(spacing: 0) {
            ForEach(GraphRange.allCases) { range in
                Button {
                    viewModel.selectedRange = range
                } label: {
                    VStack(spacing: 6) {
                            Text(range.title)
                                .graphBarTitle()
                                .foregroundStyle(.textbg1)
                            Rectangle()
                                .fill(
                                    viewModel.selectedRange == range
                                    ? Color.primary0
                                    : Color.clear
                                )
                                .frame(height: 3) // ← 여기서 굵기 조절
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                        .background(
                            viewModel.selectedRange == range
                            ? Color.gray4
                            : Color.textbg2
                        )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // 선택된 탭에 따라 그래프 표시
    @ViewBuilder
    var graphContentView: some View {
        switch viewModel.selectedRange {
        case .day:
            HomeDayChartView(points: viewModel.dayPoints)
            
        // 리팩토링 할 예정입니다.
        case .week:
            Text("주 그래프 준비 중")
                .foregroundStyle(.gray)
                .frame(height: 320)
            
        case .month:
            Text("월 그래프 준비 중")
                .foregroundStyle(.gray)
                .frame(height: 320)
        }
    }
}

#Preview {
    HomeView()
}
