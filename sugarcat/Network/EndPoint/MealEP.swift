//
//  MealEP.swift
//  sugarcat
//
//  Created by 서세린 on 5/13/26.
//

import Foundation

// MARK: - Meal

enum MealEndpoint {
    // 6.3 식사 기록 저장
    case saveMealRecord(date: String, sequence: Int)
    // 6.1 날짜별 식사 기록 조회
    case fetchMealRecords(date: String)
    // 6.4 식사 기록 수정
    case updateMealRecord
}

extension MealEndpoint {
    
    var path: String {
        switch self {
        case .saveMealRecord(let date, let sequence):
            return "/api/v1/meals/me?date=\(date)&sequence=\(sequence)"
            
        case .fetchMealRecords(let date):
            return "/api/v1/meals/me?date=\(date)"
            
        case .updateMealRecord:
            return "/api/v1/meals/me"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .saveMealRecord:
            return .post
            
        case .fetchMealRecords:
            return .get
            
        case .updateMealRecord:
            return .patch
        }
    }
}
