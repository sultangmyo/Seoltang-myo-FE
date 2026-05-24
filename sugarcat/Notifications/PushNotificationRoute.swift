//
//  PushNotificationRoute.swift
//  sugarcat
//
//  Created by 서세린 on 5/24/26.
//

import Foundation

// 알림을 눌렀을 때 앱 내부에서 어디로 이동할지 표현하는 모델
enum PushNotificationRoute {
    
    // 홈 화면으로 이동
    // 인슐린 알림, 주간리포트 알림에서 사용
    case home
    
    // 혈당 입력 화면으로 이동
    // targetDate: 알림 대상 날짜
    // sequence: 몇 번째 혈당 기록인지
    case bloodSugarInput(
        targetDate: String,
        sequence: Int?
    )
    
    // 식사 입력 화면으로 이동
    // targetDate: 알림 대상 날짜
    // sequence: 몇 번째 식사 기록인지
    case mealInput(
        targetDate: String,
        sequence: Int?
    )
}
