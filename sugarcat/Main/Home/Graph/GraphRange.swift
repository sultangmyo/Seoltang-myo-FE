//
//  GraphRange.swift
//  sugarcat
//
//  Created by 서세린 on 5/26/26.
//

import Foundation

// 홈 혈당 그래프에서 보여줄 기간 단위
// 일 / 주 / 월 탭을 구분하기 위해 사용
enum GraphRange: String, CaseIterable, Identifiable {
    
    // 일 단위 그래프
    case day
    
    // 주 단위 그래프
    case week
    
    // 월 단위 그래프
    case month
    
    // ForEach에서 사용할 고유 id
    var id: String {
        rawValue
    }
    
    // 화면에 표시할 탭 이름
    var title: String {
        switch self {
        case .day:
            return "일"
        case .week:
            return "주"
        case .month:
            return "월"
        }
    }
}
