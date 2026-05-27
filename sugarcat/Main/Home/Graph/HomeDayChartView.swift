//
//  HomeDayChartView.swift
//  sugarcat
//
//  Created by 서세린 on 5/26/26.
//

import SwiftUI
import Charts

// 홈 화면의 일 단위 혈당 그래프 View
struct HomeDayChartView: View {
    
    // ViewModel에서 변환된 그래프 데이터
    let points: [GraphPoint]
    
    // 드래그 중 선택된 지점
    @State private var selectedPoint: GraphPoint?
    
    var body: some View {
        
        VStack{
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

private extension HomeDayChartView {
    var chartView: some View {
        Chart {
            // 정상 혈당 범위 80~150 배경 표시
            RectangleMark(
                xStart: .value("Start", 0),
                xEnd: .value("End", 24),
                yStart: .value("Normal Low", 80),
                yEnd: .value("Normal High", 150)
            )
            .foregroundStyle(Color.primary0.opacity(0.1))
            
            // 혈당 그래프 라인
            ForEach(points) { point in
                LineMark(
                    x: .value("Time", point.hour),
                    y: .value("Sugar", point.chartValue)
                )
                .foregroundStyle(Color.primary0)
                
                PointMark(
                    x: .value("Time", point.hour),
                    y: .value("Sugar", point.chartValue)
                )
                .foregroundStyle(point.isOverLimit ? Color.pointo : .clear)
            }
            
            // 고정 x축 ycbr baseline
            RuleMark(
                y: .value("X Axis Baseline", 0)
            )
            .foregroundStyle(Color.gray1)
            .lineStyle(StrokeStyle(lineWidth: 1))
            RuleMark(
                x: .value("Y Axis Baseline", 24)
            )
            .foregroundStyle(Color.gray1)
            .lineStyle(StrokeStyle(lineWidth: 1))
            
            // 드래그 중 선택된 지점 막대로 표시
            if let selectedPoint {
                RuleMark(
                    x: .value("Selected Time", selectedPoint.hour)
                )
                .foregroundStyle(Color.gray.opacity(0.4))
                
                PointMark(
                    x: .value("Selected Time", selectedPoint.hour),
                    y: .value("Selected Sugar", selectedPoint.chartValue)
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
        .chartXScale(domain: 0...24)
        .chartYScale(domain: 0...310)
        //차트 x축 구성
        .chartXAxis {
            AxisMarks(values: [0, 4, 8, 12, 16, 20, 24]) { value in
                AxisGridLine()
                AxisValueLabel {
                    if let hour = value.as(Int.self) {
                        Text(String(format: "%02d", hour))
                    }
                }
            }
        }
        //차트 y축 구성
        .chartYAxis {
            AxisMarks(values: [0, 80, 150]) { value in
                // y축 숫자 표시
                AxisValueLabel {
                    if let intValue = value.as(Int.self) {
                        Text("\(intValue)")
                    }
                }
            }
            AxisMarks(values: [0, 50, 100, 150, 200, 250, 300]) { value in
                // y축 그리드 라인 표시
                AxisGridLine()
            }
        }
        
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
                                    let hour: Double = proxy.value(atX: xPosition)
                                else {
                                    return
                                }
                                
                                selectedPoint = nearestPoint(to: hour)
                            }
                            .onEnded { _ in
                                selectedPoint = nil
                            }
                    )
            }
        }
        .frame(height: 300)
    }
    
    // MARK: - 툴팁 UI
    func tooltipView(for point: GraphPoint) -> some View {
        VStack(spacing: 2) {
            //여기 폰트 모디파이어 따로 없어 임의로 지정했습니다.
            HStack(spacing:3){
                Text("\(point.sugarValue)")
                    .font(.system(size: 18, weight: .bold))
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 18, weight: .bold))
            }
            .fixedSize()
                        
            Text(DateStringFormatter.displayTime(from: point.recordTime))
                .font(.system(size: 12, weight: .medium))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(tooltipColor(for: point))
        .foregroundStyle(.textbg2)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // 드래그 위치와 가장 가까운 기록 찾기
    func nearestPoint(to hour: Double) -> GraphPoint? {
        points.min {
            abs($0.hour - hour) < abs($1.hour - hour)
        }
    }
}

// 혈당 상태에 따른 툴팁 배경색
func tooltipColor(for point: GraphPoint) -> Color {
    switch point.sugarStatus {
    case .low:
        return Color.pointn
    case .normal:
        return Color.primary0
    case .high:
        return Color.pointo

    }

}
// 툴팁이 차트 좌우 바깥으로 나가지 않도록 위치 보정
func tooltipXOffset(for point: GraphPoint) -> CGFloat {
    if point.hour < 2 {
        return 30      // 왼쪽 끝이면 오른쪽으로 밀기
    } else if point.hour > 23 {
        return -35     // 오른쪽 끝이면 왼쪽으로 밀기
    } else {
        return 0
    }
}

// 혈당 수치가 높으면 tooltip을 아래쪽에 표시
// 높은 값에서 tooltip이 차트 밖으로 나가는 문제를 방지
func tooltipPosition(
    for point: GraphPoint
) -> AnnotationPosition {
    
    point.chartValue >= 250
    ? .bottom
    : .top
}

// MARK: - preview
#Preview {
    
    let mockPoints: [GraphPoint] = [
        GraphPoint(
            recordTime: "00:12:00",
            hour: 0.1,
            sugarValue: 60,
            sugarStatus: .low
        ),
        
        GraphPoint(
            recordTime: "08:12:00",
            hour: 8.2,
            sugarValue: 60,
            sugarStatus: .low
        ),
        
        GraphPoint(
            recordTime: "12:30:00",
            hour: 12.5,
            sugarValue: 168,
            sugarStatus: .high
        ),
        
        GraphPoint(
            recordTime: "18:03:00",
            hour: 18.0,
            sugarValue: 132,
            sugarStatus: .normal
        ),
        
        GraphPoint(
            recordTime: "22:10:00",
            hour: 23.5,
            sugarValue: 320,
            sugarStatus: .high
        )
    ]
    
    return HomeDayChartView(
        points: mockPoints
    )
    .padding()
}
