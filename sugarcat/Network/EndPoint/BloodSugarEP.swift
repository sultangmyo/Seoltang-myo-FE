//
//  BloodSugarEP.swift
//  sugarcat
//
//  Created by 서세린 on 5/13/26.
//

import Foundation

// MARK: - BloodSugar

enum BloodSugarEndpoint {
    // 혈당 기록 저장
    case saveBloodSugarRecord
    // 날짜별 혈당 기록 조회
    case fetchBloodSugarRecords(date: String)
    // 혈당 기록 수정
    case updateBloodSugarRecord
    // 혈당 기록 삭제
    case deleteBloodSugarRecord(sequence: Int, date: String)
}

extension BloodSugarEndpoint {
    
    var path: String {
        switch self {
        case .saveBloodSugarRecord:
            return "/api/v1/blood-sugar-records/me"
            
        case .fetchBloodSugarRecords(let date):
            return "/api/v1/blood-sugar-records/me?date=\(date)"
            
        case .updateBloodSugarRecord:
            return "/api/v1/blood-sugar-records/me"
            
        case .deleteBloodSugarRecord(let sequence, let date):
            return "/api/v1/blood-sugar-records/me?sequence=\(sequence)&date=\(date)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .saveBloodSugarRecord:
            return .post
            
        case .fetchBloodSugarRecords:
            return .get
            
        case .updateBloodSugarRecord:
            return .patch
            
        case .deleteBloodSugarRecord:
            return .delete
        }
    }
}
