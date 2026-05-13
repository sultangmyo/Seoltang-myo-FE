//
//  BSNFsettingView1.swift
//  sugarcat
//
//  Created by 서세린 on 5/13/26.
//

import SwiftUI

struct BSNFsettingView1: View {
    
    var body: some View {
        VStack {
            NavigationIncludeBackView(title: "혈당 알림 설정")
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true) // 자동으로 만들어지는 back navigation 없애고 커스텀 네비게이션을 사용하는 코드
    }
}
