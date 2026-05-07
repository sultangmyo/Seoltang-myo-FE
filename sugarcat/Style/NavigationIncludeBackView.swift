//
//  NavigationIncludeBackView.swift
//  sugarcat
//
//  Created by 서세린 on 5/6/26.
//

import SwiftUI
import Foundation

// 뒤로가기 버튼이 있는 네비게이션 스타일
// 해당 스타일 사용할 때 스택 마지막에 .navigationBarBackButtonHidden(true) 이 코드 붙이셔야 합니다.
struct NavigationIncludeBackView: View {
    
    let title: String
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("뒤로가기")
                    }
                }
                Spacer()
            }
            .padding(.leading, 8)
            
            Text(title)
                .frame(maxWidth: .infinity)
                .BodyEmphasized() //폰트 모디파이어 사용.
        }
        .padding(.vertical, 11)
    }
}

#Preview {
    NavigationIncludeBackView(title: "인쇄 및 저장")
}
