//
//  CatCareEP.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/14/26.
//

import Foundation

// MARK: - BloodSugar

enum CatCareEndpoint {
    // 식사정보 조회
    case mealRecordCheck
    // 혈당 체크 정보 조회
    case bloodsugarRecordsCheck
    // 인슐린 정보 조회
    case insulinRecordCheck
    // 2.3 식사 설정 수정
    case mealRecordEdit
    // 2.3 혈당 체크 설정 수정
    case bloodsugarRecordEdit
    // 2.3 인슐린 설정 수정
    case insulinRecordEdit
}

extension CatCareEndpoint {
    
    var path: String {
        switch self {
        case .mealRecordCheck, .mealRecordEdit:
            return "/api/v1/care_schedules/me/meal"
            
        case .bloodsugarRecordsCheck, .bloodsugarRecordEdit:
            return "/api/v1/care_schedules/me/blood-sugar"
            
        case .insulinRecordCheck, .insulinRecordEdit:
            return "/api/v1/care_schedules/me/insulin"
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .mealRecordCheck, .bloodsugarRecordsCheck, .insulinRecordCheck:
            return .get
            
        case .mealRecordEdit, .bloodsugarRecordEdit, .insulinRecordEdit:
            return .patch
        }
    }
}
