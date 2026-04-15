//
//  sugarcatApp.swift
//  sugarcat
//
//  Created by 서세린 on 4/6/26.
//

import SwiftUI

@main
struct sugarcatApp: App {
    
    // userid 저장 로직이 구현이 안되어 있어, 임시로 만든 목업
    init() {
        // 테스트용 userId (한 번만 넣으면 됨)
        if UserDefaults.standard.string(forKey: "userId") == nil {
            UserDefaults.standard.set(
                "550E8400-E29B-41D4-A716-446655440000",
                forKey: "userId"
            )
        }
    }
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}
