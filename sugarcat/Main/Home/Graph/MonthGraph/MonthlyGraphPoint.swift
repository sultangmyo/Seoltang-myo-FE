//
//  MonthlyGraphPoint.swift
//  sugarcat
//
//  Created by 서세린 on 6/30/26.
//

import Foundation

// 월 단위 혈당 그래프에서 사용할 화면용 데이터 모델
struct MonthlyGraphPoint: Identifiable {
    
    let id = UUID()
    
    // 원본 날짜
    // ex: "2026-05-01"
    let date: String
    
    // 해당 월의 일자
    // ex: 1, 2, 3 ... 31
    let day: Int
    
    // 그래프 x축에 사용할 좌표값
    // 1일 → 1, 2일 → 2 ... 31일 → 31
    let dayIndex: Double
    
    // 월간 통계값
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
    
    // 기록이 있는 날짜인지
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
