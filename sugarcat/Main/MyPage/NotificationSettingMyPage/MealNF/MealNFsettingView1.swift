//
//  MealNFsettingView1.swift
//  sugarcat
//
//  Created by 서세린 on 5/13/26.
//

import SwiftUI

struct MealNFsettingView1: View {
    
    var body: some View {
        VStack {
            NavigationIncludeBackView(title: "식사 알림 설정")
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true) // 자동으로 만들어지는 back navigation 없애고 커스텀 네비게이션을 사용하는 코드
    }
}

//#Preview {
//    MealNFsettingView1()
//}
