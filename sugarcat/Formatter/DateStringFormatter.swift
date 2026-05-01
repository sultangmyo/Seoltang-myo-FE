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
    
    // MARK: - Date → "HH:mm:ss"
    static func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm:ss"
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
}
