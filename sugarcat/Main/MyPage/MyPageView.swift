//
//  HomeView.swift
//  sugarcat
//
//  Created by 서세린 on 4/9/26.
//

import SwiftUI

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
                    DividerBottomSection()
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
