//
//  InsulinEP.swift
//  sugarcat
//
//  Created by 서세린 on 5/13/26.
//

import Foundation


// MARK: - Insulin

enum Endpoint {
    // 4.3 인슐린 투여 기록 저장
    case saveInsulinRecord
    // 4.3 날짜별 인슐린 투여 기록 조회
    case fetchInsulinRecords(date: String)
}

extension Endpoint {
    var path: String {
        switch self {
        // 인슐린 투여 기록 저장
        case .saveInsulinRecord:
            return "/api/v1/insulin-records/me"

        // 날짜별 인슐린 투여 기록 조회
        case .fetchInsulinRecords(let date):
            return "/api/v1/insulin-records/me?date=\(date)"
        }
    }

    
    var method: HTTPMethod {
        switch self {
        case .saveInsulinRecord:
            return .post
        case .fetchInsulinRecords:
            return .get

        }
    }
}
