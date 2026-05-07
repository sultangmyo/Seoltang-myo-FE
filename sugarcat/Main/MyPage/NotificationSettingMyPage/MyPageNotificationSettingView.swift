//
//  MyPageNotificationSettingView.swift
//  sugarcat
//
//  Created by 서세린 on 5/6/26.
//

import SwiftUI

struct MyPageNotificationSettingView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationIncludeBackView(title: " ")
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true) // 자동으로 만들어지는 back navigation 없애고 커스텀 네비게이션을 사용하는 코드
    }
}

#Preview {
    MyPageNotificationSettingView()
}
