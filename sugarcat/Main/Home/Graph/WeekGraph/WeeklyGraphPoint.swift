//
//  WeeklyGraphPoint.swift
//  sugarcat
//
//  Created by 서세린 on 6/23/26.
//

import Foundation

// 주 단위 혈당 그래프에서 사용할 화면용 데이터 모델
struct WeeklyGraphPoint: Identifiable {
    
    let id = UUID()
    
    // MON / TUE / WED ...
    let dayOfWeek: GraphDayOfWeek
    
    // 월: 0, 화: 1, 수: 2 ... 일: 6
    let dayIndex: Double
    
    // 월 / 화 / 수 / 목 / 금 / 토 / 일
    let dayLabel: String
    
    // 주간 통계값
    let avg: Double?
    let min: Double?
    let max: Double?
    let count: Int
    
    // 그래프에 실제로 찍을 y값
    // 기록이 없으면 0에 표시
    // 평균이 300 초과면 300 위치에 표시
    var chartValue: Double {
        guard let avg else {
            return 0
        }
        
        return Swift.min(avg, 300)
    }
    
    // 기록이 있는 요일인지
    var hasRecord: Bool {
        count > 0
    }
    
    // 평균값이 300을 초과했는지 여부
    var isOverLimit: Bool {
        guard let avg else {
            return false
        }
        
        return avg > 300
    }
}
