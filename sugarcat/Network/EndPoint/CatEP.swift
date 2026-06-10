//
//  CatEP.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/14/26.
//



import Foundation

enum CatEndpoint {
   // MARK: - AUTH
   case catInfoCreate
   case catInfoCheck
   case catInfoRewrite
   case catDelete
   case catInviteCreate
    case catInviteCheck
    case catInviteVerification(inviteCode: String)
    case catPDFCheck(startDate: String, endDate: String)
   
}

extension CatEndpoint {
   
   var path: String {
       switch self {
       // 2.2 고양이 기본정보 생성
       case .catInfoCreate:
           return "/api/v1/cats"
       
       // 7.2 고양이 기본정보 조회, 7.3 고양이 기본정보 수정, 고양이삭제
       case .catInfoCheck,.catInfoRewrite, .catDelete:
           return "/api/v1/cats/me"
          
      // 7.3 초대코드 생성,  7.3 초대코드 조회
       case .catInviteCreate, .catInviteCheck:
           return "/api/v1/cats/me/invite-code"
          
       // 2.4 초대코드 유효성 검증
       case .catInviteVerification(let inviteCode):
           return "/api/v1/cats/invite?code=\(inviteCode)"
       // 7.4 PDF 데이터 조회
       case .catPDFCheck (let startDate, let endDate):
           return "/api/v1/cats/me/export?startDate=\(startDate)&endDate=\(endDate)"
       }
   }
   
   var method: HTTPMethod {
       switch self {
       case .catInfoCreate:
           return .post
           
       case .catInfoCheck, .catInviteCheck, .catPDFCheck:
           return .get
           
       case .catInfoRewrite, .catInviteCreate, .catInviteVerification:
           return .patch
           
       case .catDelete:
           return .delete
           
       }
   }
}
