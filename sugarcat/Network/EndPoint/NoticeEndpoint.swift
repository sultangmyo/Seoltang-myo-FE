//
//  NoticeEndpoint.swift
//  sugarcat
//
//  Created by 서세린 on 7/11/26.
//

import Foundation

// MARK: - Notice Endpoint

enum NoticeEndpoint {
    case active
}

extension NoticeEndpoint {
    
    var path: String {
        switch self {
        case .active:
            return "/api/v1/notices/active"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .active:
            return .get
        }
    }
}
