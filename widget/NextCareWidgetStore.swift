//
//  NextCareWidgetStore.swift
//  sugarcat
//
//  Created by 서세린 on 5/17/26.
//

import Foundation

// 위젯 데이터를 저장/불러오는 저장소
enum NextCareWidgetStore {
    
    // App Group 이름
    // 앱과 위젯이 같은 저장 공간을 공유하기 위해 사용
    private static let suiteName = "group.com.godaemo.sugarcat"
    
    // UserDefaults에 저장될 key 이름
    private static let key = "nextCareWidgetData"
    
    // App Group 전용 UserDefaults
    // 일반 UserDefaults가 아니라 앱/위젯 공유 저장소
    private static var userDefaults: UserDefaults? {
        UserDefaults(suiteName: suiteName)
    }
    
    // 위젯 데이터를 저장하는 함수
    static func save(_ data: NextCareWidgetData) {
        
        // Swift 객체를 JSON Data로 변환
        // UserDefaults는 Codable 객체를 직접 저장 못하므로 encode 필요
        guard let encoded = try? JSONEncoder().encode(data) else {
            return
        }
        
        // App Group UserDefaults에 저장
        userDefaults?.set(encoded, forKey: key)
    }
    
    // 저장된 위젯 데이터를 불러오는 함수
    static func load() -> NextCareWidgetData {
        
        // 1. 저장된 Data 가져오기
        // 2. JSON Data → Swift 객체 decode
        guard
            let data = userDefaults?.data(forKey: key),
            let decoded = try? JSONDecoder().decode(
                NextCareWidgetData.self,
                from: data
            )
        else {
            // 저장된 데이터가 없으면
            // "등록된 일정 없음" 상태 반환
            return .noSchedule
        }
        
        // decode 성공 시 위젯 데이터 반환
        return decoded
    }
    
    // 저장된 위젯 데이터 삭제 함수
    static func clear() {
        userDefaults?.removeObject(forKey: key)
    }
}
