//
//  User.swift
//  sugarcat
//
//  Created by 서세린 on 4/8/26.
//

import Foundation

// MARK: - 2.1 사용자 생성
// request dto
//struct CreateUserRequestDTO: Codable {
//    let nickname: String
//    let catId: String
//    let notificationEnabled: Bool
//}
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

// MARK: - 7.2 사용자 닉네임 수정
// request dto
struct UpdateUserRequestDTO: Codable {
    let nickname: String
}

// response dto
// MessageResponseDTO를 재활용 합니다

//MARK: - 사용자 삭제
// response dto
// MessageResponseDTO를 재활용 합니다


// MARK: - 사용자 알림 전체 수정 생성
struct UpdateAllNotificationRequest: Codable {
    let notificationEnabled: Bool
}

// MARK: - 사용자 알림 개별 수정
struct UpdateNotificationRequest: Codable {
    let inEnabled: Bool
}
// response dto
// MessageResponseDTO를 재활용 합니다

// MARK: - 사용자 알림 정보 조회
//response dto
struct NotificationSettingsResponse: Decodable {
    let insulinNotificationEnabled: Bool
    let bloodSugarNotificationEnabled: Bool
    let mealNotificationEnabled: Bool
    let weeklyReportNotificationEnabled: Bool
}
