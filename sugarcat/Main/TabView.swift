//
//  TabView.swift
//  sugarcat
//
//  Created by 서세린 on 4/9/26.
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }
            
            BloodSugarView()
                .tabItem {
                    Image(systemName: "drop")
                    Text("혈당")
                }
            
            MealView()
                .tabItem {
                    Image("tab_mealicon")
                    Text("식사")
                }
            MyPageView()
                .tabItem {
                    Image(systemName: "person")
                    Text("마이")
                }
        }
        .tint(Color("primary0"))
    }
}

#Preview {
    MainTabView()
}
