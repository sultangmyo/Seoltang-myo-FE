//
//  HomeWeekChartView.swift
//  sugarcat
//
//  Created by 서세린 on 6/23/26.
//

import SwiftUI
import Charts

// 홈 화면의 주 단위 혈당 그래프 View
struct HomeWeekChartView: View {
    
    // ViewModel에서 변환된 주간 그래프 데이터
    let points: [WeeklyGraphPoint]
    
    // 드래그 중 선택된 지점
    @State private var selectedPoint: WeeklyGraphPoint?
    
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

private extension HomeWeekChartView {
    
    var chartView: some View {
        Chart {
            // 정상 혈당 범위 80~150 배경 표시
            RectangleMark(
                xStart: .value("Start", 0),
                xEnd: .value("End", 6),
                yStart: .value("Normal Low", 80),
                yEnd: .value("Normal High", 150)
            )
            .foregroundStyle(Color.primary0.opacity(0.1))
            
            // 주간 평균 혈당 그래프 라인
            ForEach(points) { point in
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
                x: .value("Y Axis Baseline", 6)
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
        .chartXScale(domain: 0...6)
        .chartYScale(domain: 0...310)
        
        // x축: 월 화 수 목 금 토 일
        .chartXAxis {
            AxisMarks(values: [0, 1, 2, 3, 4, 5, 6]) { value in
                AxisGridLine()

                if let index = value.as(Int.self) {
                    AxisValueLabel(
                        anchor: xAxisLabelAnchor(for: index)
                    ) {
                        Text(dayLabel(for: index))
                    }
                }
            }
        }
        
        // y축: 일간 그래프와 동일
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
        
        // 드래그로 가장 가까운 요일 point 선택
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
    
    func tooltipView(for point: WeeklyGraphPoint) -> some View {
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
    
    // 드래그 위치와 가장 가까운 요일 point 찾기
    func nearestPoint(to dayIndex: Double) -> WeeklyGraphPoint? {
        points.min {
            abs($0.dayIndex - dayIndex) < abs($1.dayIndex - dayIndex)
        }
    }
    
    // x축 숫자 좌표를 한글 요일로 변환
    func dayLabel(for index: Int) -> String {
        switch index {
        case 0:
            return "월"
        case 1:
            return "화"
        case 2:
            return "수"
        case 3:
            return "목"
        case 4:
            return "금"
        case 5:
            return "토"
        case 6:
            return "일"
        default:
            return ""
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
    // 기록이 없는 날은 회색, 300 초과는 주황색, 나머지는 primary0
    func pointColor(for point: WeeklyGraphPoint) -> Color {
        if !point.hasRecord {
            return Color.gray1
        }
        
        if point.isOverLimit {
            return Color.pointo
        }
        
        return Color.primary0
    }
    
    // 툴팁 배경색
    // avg 기준으로 low / normal / high 판단
    func tooltipColor(for point: WeeklyGraphPoint) -> Color {
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
    func tooltipXOffset(for point: WeeklyGraphPoint) -> CGFloat {
        if point.dayIndex < 1 {
            return 30
        } else if point.dayIndex > 5 {
            return -35
        } else {
            return 0
        }
    }
    
    // 혈당 평균값이 높으면 tooltip을 아래쪽에 표시
    func tooltipPosition(
        for point: WeeklyGraphPoint
    ) -> AnnotationPosition {
        point.chartValue >= 250
        ? .bottom
        : .top
    }
    
    //일요일 글자를 보이게 하는 헬퍼
    func xAxisLabelAnchor(for index: Int) -> UnitPoint {
        switch index {
        case 0:
            return .topLeading
        case 6:
            return .topTrailing
        default:
            return .top
        }
    }
}

#Preview {
    HomeWeekChartView(
        points: [
            WeeklyGraphPoint(dayOfWeek: .mon, dayIndex: 0, dayLabel: "월", avg: 145, min: 90, max: 210, count: 3),
            WeeklyGraphPoint(dayOfWeek: .tue, dayIndex: 1, dayLabel: "화", avg: 130, min: 85, max: 180, count: 2),
            WeeklyGraphPoint(dayOfWeek: .wed, dayIndex: 2, dayLabel: "수", avg: nil, min: nil, max: nil, count: 0),
            WeeklyGraphPoint(dayOfWeek: .thu, dayIndex: 3, dayLabel: "목", avg: 120, min: 95, max: 150, count: 4),
            WeeklyGraphPoint(dayOfWeek: .fri, dayIndex: 4, dayLabel: "금", avg: 160, min: 110, max: 240, count: 5),
            WeeklyGraphPoint(dayOfWeek: .sat, dayIndex: 5, dayLabel: "토", avg: nil, min: nil, max: nil, count: 0),
            WeeklyGraphPoint(dayOfWeek: .sun, dayIndex: 6, dayLabel: "일", avg: 118, min: 90, max: 140, count: 2)
        ]
    )
    .padding()
}
