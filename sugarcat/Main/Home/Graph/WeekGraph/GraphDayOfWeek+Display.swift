//
//  GraphDayOfWeek+Display.swift
//  sugarcat
//
//  Created by 서세린 on 6/23/26.
//

import Foundation

// dto에 x좌표에 맞게 월 화 수 목 금 토 일을 배치할 수 있도록 변환
extension GraphDayOfWeek {
    
    var index: Double {
        switch self {
        case .mon:
            return 0
        case .tue:
            return 1
        case .wed:
            return 2
        case .thu:
            return 3
        case .fri:
            return 4
        case .sat:
            return 5
        case .sun:
            return 6
        }
    }
    
    var koreanLabel: String {
        switch self {
        case .mon:
            return "월"
        case .tue:
            return "화"
        case .wed:
            return "수"
        case .thu:
            return "목"
        case .fri:
            return "금"
        case .sat:
            return "토"
        case .sun:
            return "일"
        }
    }
}
