//
//  User.swift
//  sugarcat
//
//  Created by 서세린 on 4/8/26.
//

import Foundation

// MARK: - 2.1 사용자 생성
// request dto
struct CreateUserRequestDTO: Codable {
    let nickname: String
    let catId: String
    let notificationEnabled: Bool
}
// response dto
struct CreateUserResponseDTO: Codable {
    let message: String
}

// MARK: - 7.1 사용자 정보 조회
// response dto
struct UserInfoResponseDTO: Codable {
    let nickname: String
    let family: [FamilyMemberDTO]
}

// family 세부 dto
struct FamilyMemberDTO: Codable {
    let nickname: String
}
