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
}
