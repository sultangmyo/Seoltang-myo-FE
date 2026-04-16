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
struct UpdateNotificationRequest: Codable {
    let notificationEnabled: Bool
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
//디코더 없어서 작성했습니다.
    enum CodingKeys: String, CodingKey {
        case insulinNotificationEnabled = "insulin_notification_enabled"
        case bloodSugarNotificationEnabled = "blood_sugar_notification_enabled"
        case mealNotificationEnabled = "meal_notification_enabled"
        case weeklyReportNotificationEnabled = "weekly_report_notification_enabled"
    }
}
