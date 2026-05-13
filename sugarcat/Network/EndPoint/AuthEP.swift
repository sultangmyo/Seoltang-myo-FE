//
//  AuthEP.swift
//  sugarcat
//
//  Created by 서세린 on 5/13/26.
//

//import Foundation
//
//enum Endpoint {
//    // MARK: - User
//    case fetchCurrentUserInfo
//    case updateNickname
//}
//
//extension Endpoint {
//    
//    var path: String {
//        switch self {
//        //7.1 사용자이름, 고양이 닉네임 조회
//        case .fetchCurrentUserInfo:
//            return "/api/v1/users/me/"
//        
//        //7.2 사용자 닉네임 수정
//        case .updateNickname:
//            return "/api/v1/users/me/nickname"
//        }
//    }
//    
//    var method: HTTPMethod {
//        switch self {
//        case .fetchCurrentUserInfo:
//            return .get
//            
//        case .updateNickname:
//            return .patch
//        }
//    }
//}
