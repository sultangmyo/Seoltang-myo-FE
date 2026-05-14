
 // AuthEP.swift
 // sugarcat

 // Created by 서세린 on 5/13/26.


import Foundation

enum AuthEndpoint {
    // MARK: - AUTH
    case onBoardingCompleted
    //온보딩 완료 여부 검사
    case onBoardingCheck
    case apnsDeviceToken
    case jwtRefresh
    case logout
    
}

extension AuthEndpoint {
    
    var path: String {
        switch self {
        // 1.4 온보딩 완료 여부 저장, 온보딩 완료 여부 검사
        case .onBoardingCompleted, .onBoardingCheck:
            return "/api/v1/auth/onboarding"
        
        // 1.0 apns device Token 여부 검사
        case .apnsDeviceToken:
            return "/api/v1/notifications/device-token"
           
        // 1.3 jwt 재발급
        case .jwtRefresh:
            return "/api/v1/auth/refresh"
        // 1.1.2 로그아웃
        case .logout:
            return "/api/v1/auth/logout"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .onBoardingCompleted, .apnsDeviceToken, .jwtRefresh, .logout:
            return .post
            
        case .onBoardingCheck:
            return .get
            
        }
    }
}
