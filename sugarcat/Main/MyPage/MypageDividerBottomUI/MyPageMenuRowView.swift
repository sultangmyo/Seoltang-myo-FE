//
//  MyPageMenuRowView.swift
//  sugarcat
//
//  Created by 서세린 on 5/6/26.
//

import SwiftUI

//해당 파일은 divider 하단의 메뉴 한줄을 만듭니다.
//성격에 따라 버튼일 수도 있고, 단순텍스트 일수도 있기에 같은 스타일 적용을 위해 뷰를 분리하였습니다.
struct MyPageMenuRowView: View {
    
    let title: String
    let isButton: Bool
    let action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            
            if isButton {
                Button {
                    action?()
                } label: {
                    rowContent
                }
                .buttonStyle(.plain)
            } else {
                rowContent
            }

        }
    }
}

private extension MyPageMenuRowView {
    
    var rowContent: some View {
        HStack {
            Text(title)
                .body1SB()
                .foregroundColor(.textbg1)
            
            Spacer()
        }
        .padding(.vertical, 12)
    }
}

#Preview {
    VStack {
        MyPageMenuRowView(
            title: "로그아웃",
            isButton: true,
            action: {}
        )
        
        MyPageMenuRowView(
            title: "앱 버전",
            isButton: false,
            action: nil
        )
    }
    .padding()
}
