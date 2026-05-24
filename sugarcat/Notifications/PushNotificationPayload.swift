//
//  PushNotificationPayload.swift
//  sugarcat
//
//  Created by 서세린 on 5/24/26.
//

import Foundation

enum NotificationType: String {
    case insulinReminder = "INSULIN_REMINDER"
    case insulinCompleted = "INSULIN_COMPLETED"
    case bloodSugarReminder = "BLOOD_SUGAR_REMINDER"
    case bloodSugarCompleted = "BLOOD_SUGAR_COMPLETED"
    case mealReminder = "MEAL_REMINDER"
    case mealCompleted = "MEAL_COMPLETED"
    case weeklyReport = "WEEKLY_REPORT"
}


// APNs payload를 앱 내부에서 쉽게 사용하기 위한 모델
struct PushNotificationPayload {
    // 알림 종류
    // ex: INSULIN_REMINDER
    let notificationType: NotificationType
    
    // 알림 대상 날짜
    // ex: "2026-05-09"
    let targetDate: String?
    
    // 몇 번째 케어인지
    // ex: 1회차
    let sequence: Int?
    
    // APNs userInfo 딕셔너리를
    // 앱에서 사용할 모델로 변환
    init?(userInfo: [AnyHashable: Any]) {
        
        // notificationType 문자열 추출
        // ex: "INSULIN_REMINDER"
        guard
            let typeString = userInfo["notificationType"] as? String,
            
            // 문자열 → enum 변환
            let notificationType = NotificationType(
                rawValue: typeString
            )
        else {
            // notificationType이 없거나 잘못된 경우
            return nil
        }
        
        // 필수값 저장
        self.notificationType = notificationType
        
        // optional 값 저장
        self.targetDate = userInfo["targetDate"] as? String
        self.sequence = userInfo["sequence"] as? Int
    }
}

extension PushNotificationPayload {
    
    // APNs payload를 앱 내부 이동 경로로 변환
    var route: PushNotificationRoute {
        
        switch notificationType {
            
        // 인슐린은 별도 입력뷰가 아니라 홈에서 체크/확인하는 구조이므로 홈으로 이동
        case .insulinReminder,
             .insulinCompleted:
            return .home
            
        // 혈당 알림은 혈당 입력뷰로 이동
        case .bloodSugarReminder,
             .bloodSugarCompleted:
            return .bloodSugarInput(
                targetDate: targetDate ?? DateStringFormatter.dateString(from: Date()),
                sequence: sequence
            )
            
        // 식사 알림은 식사 입력뷰로 이동
        case .mealReminder,
             .mealCompleted:
            return .mealInput(
                targetDate: targetDate ?? DateStringFormatter.dateString(from: Date()),
                sequence: sequence
            )
            
        // 주간리포트는 홈으로 이동
        case .weeklyReport:
            return .home
        }
    }
}
