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
struct MessageResponseDTO: Codable {
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

// MARK: - 7.2 사용자 수정
// request dto
struct UpdateUserRequestDTO: Codable {
    let nickname: String
}

// response dto
// MessageResponseDTO를 재활용 합니다

//MARK: - 사용자 삭제
// response dto
// MessageResponseDTO를 재활용 합니다

// MARK: - 사용자 알림 정보 조회
// 알림 정보 api가 만들어지면 코드를 추가합니다.


