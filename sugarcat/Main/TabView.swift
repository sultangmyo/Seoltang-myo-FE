//
//  TabView.swift
//  sugarcat
//
//  Created by 서세린 on 4/9/26.
//

import SwiftUI

// 탭 종류
// TabView의 selection 값으로 사용
enum MainTab {
    case home
    case bloodSugar
    case meal
    case myPage
}

struct MainTabView: View {
    
    // 알림 route를 감지하기 위한 Router
    @StateObject private var pushRouter =
    PushNotificationRouter.shared
    
    // 현재 선택된 탭
    @State private var selectedTab: MainTab = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
                .tag(MainTab.home)
            
            BloodSugarView()
                .tabItem {
                    Image(systemName: "drop")
                    Text("혈당")
                }
                .tag(MainTab.bloodSugar)
            
            MealView()
                .tabItem {
                    Image("tab_mealicon")
                    Text("식사")
                }
                .tag(MainTab.meal)
            
            MyPageView()
                .tabItem {
                    Image(systemName: "person")
                    Text("마이")
                }
                .tag(MainTab.myPage)
            
        }
        .tint(Color("primary0"))
        
        // PushNotificationRouter의 pendingRoute 변화를 감지
        
        .onReceive(pushRouter.$pendingRoute) { route in
            // route가 없으면 종료
            guard let route else { return }
            
            // 알림 종류에 따라 탭 이동
            switch route {
                // 홈으로 이동
            case .home:
                selectedTab = .home
                
                // route 사용 완료
                
                pushRouter.clear()
                // 혈당 입력 알림
                // 우선 혈당 탭으로 이동
                // 실제 입력뷰 push는 BloodSugarView에서 처리
            case .bloodSugarInput:
                selectedTab = .bloodSugar
                
                // 식사 입력 알림
                // 우선 식사 탭으로 이동
                // 실제 입력뷰 push는 MealView에서 처리
            case .mealInput:
                selectedTab = .meal
                
            }
        }
    }
}

#Preview {
    MainTabView()
}
