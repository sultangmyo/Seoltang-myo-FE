//
//  DDayFormatter.swift
//  sugarcat
//
//  Created by 서세린 on 4/11/26.
//

import Foundation

enum DDayFormatter {
    
    // Date를 받아서 D+N 문자열 생성
    static func makeDDayText(from date: Date) -> String {
        let calendar = Calendar.current
        
        // 기준 날짜(진단일)를 해당 날짜의 00:00으로 맞춤
        let startOfTarget = calendar.startOfDay(for: date)
        
        // 현재 시각(Date())을 오늘 날짜의 00:00으로 변환
        let startOfToday = calendar.startOfDay(for: Date())
        
        // 진단일 ~ 오늘까지의 날짜 차이(일 단위) 계산
        let days = calendar.dateComponents([.day], from: startOfTarget, to: startOfToday).day ?? 0
        
        return "D+\(days)"
    }
}
