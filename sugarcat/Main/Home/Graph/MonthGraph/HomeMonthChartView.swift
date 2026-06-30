//
//  HomeMonthChartView.swift
//  sugarcat
//
//  Created by 서세린 on 6/30/26.
//

import SwiftUI
import Charts

// 홈 화면의 월 단위 혈당 그래프 View
struct HomeMonthChartView: View {
    
    // ViewModel에서 변환된 월간 그래프 데이터
    let points: [MonthlyGraphPoint]
    
    // 드래그 중 선택된 지점
    @State private var selectedPoint: MonthlyGraphPoint?
    
    var body: some View {
        VStack {
            // y축 오른쪽 상단 단위 표시
            HStack {
                Spacer()
                Text("mg/dl")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(.gray)
            }
            
            chartView
        }
    }
}

private extension HomeMonthChartView {
    
    // count가 0인 날짜는 그래프에 표시하지 않음
    var visiblePoints: [MonthlyGraphPoint] {
        points.filter { $0.hasRecord }
    }
    
    var chartView: some View {
        Chart {
            // 정상 혈당 범위 80~150 배경 표시
            RectangleMark(
                xStart: .value("Start", 1),
                xEnd: .value("End", 31),
                yStart: .value("Normal Low", 80),
                yEnd: .value("Normal High", 150)
            )
            .foregroundStyle(Color.primary0.opacity(0.1))
            
            // 월간 평균 혈당 그래프 라인
            // 기록이 있는 날짜들끼리만 연결
            ForEach(visiblePoints) { point in
                LineMark(
                    x: .value("Day", point.dayIndex),
                    y: .value("Average Sugar", point.chartValue)
                )
                .foregroundStyle(Color.primary0)
                
                PointMark(
                    x: .value("Day", point.dayIndex),
                    y: .value("Average Sugar", point.chartValue)
                )
                .foregroundStyle(pointColor(for: point))
            }
            
            // 고정 x축 baseline
            RuleMark(
                y: .value("X Axis Baseline", 0)
            )
            .foregroundStyle(Color.gray1)
            .lineStyle(StrokeStyle(lineWidth: 1))
            
            // 오른쪽 y축 baseline
            RuleMark(
                x: .value("Y Axis Baseline", 31)
            )
            .foregroundStyle(Color.gray1)
            .lineStyle(StrokeStyle(lineWidth: 1))
            
            // 드래그 중 선택된 지점 표시
            if let selectedPoint {
                RuleMark(
                    x: .value("Selected Day", selectedPoint.dayIndex)
                )
                .foregroundStyle(Color.gray.opacity(0.4))
                
                PointMark(
                    x: .value("Selected Day", selectedPoint.dayIndex),
                    y: .value("Selected Average Sugar", selectedPoint.chartValue)
                )
                .foregroundStyle(Color.primary0)
                .symbolSize(80)
                .annotation(
                    position: tooltipPosition(for: selectedPoint)
                ) {
                    tooltipView(for: selectedPoint)
                        .offset(x: tooltipXOffset(for: selectedPoint))
                }
            }
        }
        .chartXScale(domain: 1...31)
        .chartYScale(domain: 0...310)
        
        // x축: 월간 일자 표시
        // 모든 날짜를 표시하면 너무 빽빽하므로 일부 날짜만 표시
        .chartXAxis {
            AxisMarks(values: [1, 6, 11, 16, 21, 26]) { value in
                AxisGridLine()
                
                if let day = value.as(Int.self) {
                    AxisValueLabel(
                        anchor: xAxisLabelAnchor(for: day)
                    ) {
                        Text("\(day)")
                    }
                }
            }
        }
        
        // y축: 일간/주간 그래프와 동일한 기준
        .chartYAxis {
            AxisMarks(values: [80, 150, 250]) { value in
                AxisValueLabel {
                    if let intValue = value.as(Int.self) {
                        Text("\(intValue)")
                    }
                }
            }
            
            AxisMarks(values: [0, 50, 100, 150, 200, 250, 300]) { _ in
                AxisGridLine()
            }
        }
        
        // 드래그로 가장 가까운 기록 point 선택
        .chartOverlay { proxy in
            GeometryReader { geometry in
                Rectangle()
                    .fill(.clear)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                guard let plotFrameAnchor = proxy.plotFrame else {
                                    return
                                }
                                
                                let plotFrame = geometry[plotFrameAnchor]
                                let xPosition = value.location.x - plotFrame.origin.x
                                
                                guard
                                    xPosition >= 0,
                                    xPosition <= plotFrame.width,
                                    let dayIndex: Double = proxy.value(atX: xPosition)
                                else {
                                    return
                                }
                                
                                selectedPoint = nearestPoint(to: dayIndex)
                            }
                            .onEnded { _ in
                                selectedPoint = nil
                            }
                    )
            }
        }
        .frame(height: 250)
    }
    
    // MARK: - 툴팁 UI
    
    func tooltipView(for point: MonthlyGraphPoint) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("평균 : \(displayValue(point.avg))")
            Text("최대 : \(displayValue(point.max))")
            Text("최소 : \(displayValue(point.min))")
        }
        .font(.system(size: 12, weight: .medium))
        .fixedSize()
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(tooltipColor(for: point))
        .foregroundStyle(.textbg2)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // MARK: - Helper
    
    // 드래그 위치와 가장 가까운 기록 point 찾기
    // count == 0인 날짜는 visiblePoints에서 제외했기 때문에 선택되지 않음
    func nearestPoint(to dayIndex: Double) -> MonthlyGraphPoint? {
        visiblePoints.min {
            abs($0.dayIndex - dayIndex) < abs($1.dayIndex - dayIndex)
        }
    }
    
    // nil 값은 "-"로 표시
    // 정수형 Double은 소수점 없이 표시
    func displayValue(_ value: Double?) -> String {
        guard let value else {
            return "-"
        }
        
        if value.truncatingRemainder(dividingBy: 1) == 0 {
            return "\(Int(value))"
        } else {
            return String(format: "%.1f", value)
        }
    }
    
    // point 색상
    // 월간 그래프에서는 기록이 없는 날짜는 아예 표시하지 않음
    // 300 초과는 주황색, 나머지는 primary0
    func pointColor(for point: MonthlyGraphPoint) -> Color {
        if point.isOverLimit {
            return Color.pointo
        }
        
        return Color.primary0
    }
    
    // 툴팁 배경색
    // avg 기준으로 low / normal / high 판단
    func tooltipColor(for point: MonthlyGraphPoint) -> Color {
        guard let avg = point.avg else {
            return Color.gray1
        }
        
        if avg < 80 {
            return Color.pointn
        } else if avg > 150 {
            return Color.pointo
        } else {
            return Color.primary0
        }
    }
    
    // 툴팁이 차트 좌우 바깥으로 나가지 않도록 위치 보정
    func tooltipXOffset(for point: MonthlyGraphPoint) -> CGFloat {
        if point.dayIndex <= 3 {
            return 30
        } else if point.dayIndex >= 29 {
            return -35
        } else {
            return 0
        }
    }
    
    // 혈당 평균값이 높으면 tooltip을 아래쪽에 표시
    func tooltipPosition(
        for point: MonthlyGraphPoint
    ) -> AnnotationPosition {
        point.chartValue >= 250
        ? .bottom
        : .top
    }
    
    // x축 양 끝 라벨이 잘리지 않도록 anchor 조정
    func xAxisLabelAnchor(for day: Int) -> UnitPoint {
        switch day {
        case 1:
            return .topLeading
        case 28, 31:
            return .topTrailing
        default:
            return .top
        }
    }
}

#Preview {
    HomeMonthChartView(
        points: [
            // 1일: 정상
            MonthlyGraphPoint(
                date: "2026-06-01",
                day: 1,
                dayIndex: 1,
                avg: 145,
                min: 90,
                max: 210,
                count: 3
            ),
            
            // 2일: 정상
            MonthlyGraphPoint(
                date: "2026-06-02",
                day: 2,
                dayIndex: 2,
                avg: 130,
                min: 85,
                max: 180,
                count: 2
            ),
            
            // 3일: 기록 없음 → 월간 그래프에서는 표시되지 않아야 함
            MonthlyGraphPoint(
                date: "2026-06-03",
                day: 3,
                dayIndex: 3,
                avg: nil,
                min: nil,
                max: nil,
                count: 0
            ),
            
            // 7일: 낮은 평균
            MonthlyGraphPoint(
                date: "2026-06-07",
                day: 7,
                dayIndex: 7,
                avg: 65,
                min: 50,
                max: 78,
                count: 2
            ),
            
            // 12일: 정상
            MonthlyGraphPoint(
                date: "2026-06-12",
                day: 12,
                dayIndex: 12,
                avg: 118,
                min: 90,
                max: 140,
                count: 4
            ),
            
            // 16일: 높은 평균
            MonthlyGraphPoint(
                date: "2026-06-16",
                day: 16,
                dayIndex: 16,
                avg: 185,
                min: 130,
                max: 260,
                count: 5
            ),
            
            // 20일: 기록 없음 → 표시되지 않아야 함
            MonthlyGraphPoint(
                date: "2026-06-20",
                day: 20,
                dayIndex: 20,
                avg: nil,
                min: nil,
                max: nil,
                count: 0
            ),
            
            // 24일: 300 초과 평균 → 300 위치에 표시되어야 함
            MonthlyGraphPoint(
                date: "2026-06-24",
                day: 24,
                dayIndex: 24,
                avg: 340,
                min: 280,
                max: 420,
                count: 3
            ),
            
            // 28일: 정상
            MonthlyGraphPoint(
                date: "2026-06-28",
                day: 28,
                dayIndex: 28,
                avg: 125,
                min: 95,
                max: 155,
                count: 2
            ),
            
            // 31일: 월말 테스트용
            MonthlyGraphPoint(
                date: "2026-06-31",
                day: 31,
                dayIndex: 31,
                avg: 150,
                min: 110,
                max: 190,
                count: 3
            )
        ]
    )
    .padding()
}
