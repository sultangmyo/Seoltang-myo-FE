//
//  GraphEP.swift
//  sugarcat
//
//  Created by 서세린 on 6/23/26.
//

import Foundation

enum GraphEP {
    case weekly(date: String)
    case monthly(date: String)
}

extension GraphEP {
    var path: String {
        switch self {
        case .weekly(let date):
            return "/api/v1/blood-sugar-statistics/me/weekly?period=weekly&date=\(date)"
            
        case .monthly(let date):
            return "/api/v1/blood-sugar-statistics/me/monthly?period=monthly&date=\(date)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .weekly, .monthly:
            return .get
        }
    }
}
