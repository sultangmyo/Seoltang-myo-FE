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
        formatter.dateFormat = "HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.date(from: timeString)

    }
}
