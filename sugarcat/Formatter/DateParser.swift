//
//  DateFormatter.swift
//  sugarcat
//
//  Created by 서세린 on 4/11/26.
//

import Foundation

// MARK: 데이터 타입을 String -> Date 로 바꾸는 포매터
enum DateParser {
    
    // "yyyy-MM-dd" 형식의 문자열을 Date로 변환
    static func parse(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        return formatter.date(from: dateString)
    }
    
    // "HH:mm:ss" → Date
    static func parseTime(_ timeString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.date(from: timeString)

    }
}

// MARK: 알림 설정 API 시간 문자열 전용 파서
enum NotificationTimeParser {
    static func parse(_ timeString: String) -> Date? {
        for format in ["HH:mm:ss", "HH:mm"] {
            let formatter = DateFormatter()
            formatter.dateFormat = format
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            formatter.isLenient = false

            if let date = formatter.date(from: timeString) {
                return date
            }
        }
        return nil
    }
}
