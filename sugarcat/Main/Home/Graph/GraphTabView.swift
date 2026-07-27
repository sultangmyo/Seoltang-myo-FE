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
        bloodSugarService: BloodSugarServiceProtocol,
        graphService: GraphServiceProtocol
    ) {
        _viewModel = StateObject(
            wrappedValue: HomeGraphViewModel(
                bloodSugarService: bloodSugarService,
                graphService: graphService
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
                    Task {
                        await viewModel.loadGraphIfNeeded(for: range)
                    }
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
        if viewModel.isLoading {
            ProgressView()
                .tint(Color.primary0)
                .frame(maxWidth: .infinity)
                .frame(height: 250)
        } else if let errorMessage = viewModel.errorMessage {
            graphMessageView(message: errorMessage, showsRetryButton: true)
        } else if hasNoData {
            graphMessageView(message: "표시할 혈당 기록이 없어요.", showsRetryButton: false)
        } else {
            switch viewModel.selectedRange {
            case .day:
                HomeDayChartView(points: viewModel.dayPoints)

            case .week:
                HomeWeekChartView(points: viewModel.weekPoints)

            case .month:
                HomeMonthChartView(points: viewModel.monthPoints)
            }
        }
    }

    var hasNoData: Bool {
        switch viewModel.selectedRange {
        case .day:
            return viewModel.dayPoints.isEmpty
        case .week:
            return !viewModel.weekPoints.contains { $0.hasRecord }
        case .month:
            return viewModel.monthPoints.isEmpty
        }
    }

    func graphMessageView(message: String, showsRetryButton: Bool) -> some View {
        VStack(spacing: 12) {
            Text(message)
                .caption2R()
                .foregroundStyle(Color.gray1)

            if showsRetryButton {
                Button("다시 시도") {
                    Task {
                        await viewModel.reloadSelectedGraph()
                    }
                }
                .body2R()
                .foregroundStyle(Color.primary0)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 250)
    }
}

#Preview {
    HomeView()
}
