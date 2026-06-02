//
//  DateStringFormatter.swift
//  sugarcat
//
//  Created by 서세린 on 4/13/26.
//

import Foundation

enum DateStringFormatter {
    
    // 오늘 날짜를 "yyyy-MM-dd" 문자열로 반환
    static func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        return formatter.string(from: Date())
    }
    
    // MARK: - Date → "yyyy-MM-dd" 
    static func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        return formatter.string(from: date)
    }
    // MARK : 화면 디자인 반영 (점이 들어간 형식) "yyyy.MM.dd"
    static func displayDotDate(from date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy.MM.dd"
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            return formatter.string(from: date)
        }
    
    
    // MARK: - Date → "HH:mm:ss" 시간이 저장되어 백엔드로 보내질 때 사용
    static func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        return formatter.string(from: date)
    }
    
    // MARK: - Date -> yyyy. M. d. (E) 혈당입력뷰, 식사 입력뷰에 사용
    static func displayKoreanDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy. M. d. (E)"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        return formatter.string(from: date)
    }
    
    // MARK: - "HH:mm:ss" → "h:mm a" 혈당뷰와 식사입력뷰 버튼에 보여주는 용으로 사용.
    static func displayTime(from timeString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "ko_KR")
        inputFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "h:mm a"
        outputFormatter.locale = Locale(identifier: "en_US_POSIX")
        outputFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let date = inputFormatter.date(from: timeString) else {
            return timeString
        }
        
        return outputFormatter.string(from: date)
    }
}
