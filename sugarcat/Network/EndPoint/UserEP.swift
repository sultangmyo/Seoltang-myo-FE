//
//  UserEP.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/14/26.
//



import Foundation

enum UserEndpoint {
   // MARK: - AUTH
   case userNicknameCheck
   case userNicknameEdit
   case userNotificationAllEdit
   case userNotificationEdit
   case userNotificationCheck
    case userDelete
   
}

extension UserEndpoint {
   
   var path: String {
       switch self {
       // 7.1 사용자 닉네임, 가족 닉네임 조회 , 사용자 삭제
       case .userNicknameCheck, .userDelete:
           return "/api/v1/users/me"
       
       // 7.2 사용자 닉네임 수정
       case .userNicknameEdit:
           return "/api/v1/users/me/nickname"
          
      // 7.2 사용자 알림 전체 수정, 사용자 알림 정보 조회
       case .userNotificationAllEdit, .userNotificationCheck:
           return "/api/v1/users/me/notification"
          
       // 7.2 사용자 알림 개별 조회
       case .userNotificationEdit:
           return "/api/v1/users/me/notification/{type}"
      
       }
   }
   
   var method: HTTPMethod {
       switch self {
       case .userNicknameCheck, .userNotificationCheck:
           return .get
           
       case .userNicknameEdit,.userNotificationAllEdit, .userNotificationEdit:
           return .patch
           
       case .userDelete:
           return .delete
           
       
       }
   }
}
