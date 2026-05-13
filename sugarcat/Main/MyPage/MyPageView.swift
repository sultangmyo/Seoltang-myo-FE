//
//  HomeView.swift
//  sugarcat
//
//  Created by 서세린 on 4/9/26.
//

import SwiftUI

enum MyPageRoute: Hashable {
    case printSave //인쇄 및 저장
    case notificationSetting // 알림 설정
    case insulinNFsetting1 // 알림설정 -> 인슐린
    case bsNFsetting1 // 알림설정 -> 혈당
    case mealNFsetting1 // 알림설정 -> 식사
}

struct MyPageView: View {
    //네비게이션
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            //네비게이션 헤더
            VStack (spacing: 0){
                VStack(spacing: 0) {
                    NavigationHeaderView(title: "마이페이지")
                    Divider()
                }
                ScrollView {
                    // MARK: - divider 상단 영역
                    //여기서 구현 하시면 됩니다
                    VStack (spacing: 0){
                        
                    }
                    
                    //커스텀 divider 적용
                    CustomDividerView()
                    
                    //divider 하단 영역 뷰 구현
                    DividerBottomSection(path: $path)
                }
            }
            .navigationDestination(for: MyPageRoute.self) { route in
                switch route {
                case .printSave:
                    PrintSaveView1(path: $path)
                case .notificationSetting:
                    MyPageNotificationSettingView(path: $path)
                case .insulinNFsetting1:
                    InsulinNFsettingView1()
                case .bsNFsetting1:
                    BSNFsettingView1()
                case .mealNFsetting1:
                    MealNFsettingView1()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MyPageView()
    }
}
