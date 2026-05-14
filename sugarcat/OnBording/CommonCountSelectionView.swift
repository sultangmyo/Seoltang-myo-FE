//
//  CommonCountSelectionView.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/14/26.
//

import SwiftUI

struct CommonCountSelectionView: View {
    
    let title: AttributedString
    let countOptions: [Int]
    @Binding var selectedCount: Int
    
    // 2열 그리드 설정
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
    ScrollView(.vertical, showsIndicators: false) {
        VStack(alignment: .leading, spacing: 30) {
            
            // 타이틀 텍스트
            Text(title)
                .mainTitleB()
                .multilineTextAlignment(.leading)
                .lineSpacing(6)
                .padding(.top, 20)
            
            // 1~4회 버튼 그리드
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(countOptions, id: \.self) { num in
                    Button(action: {
                        selectedCount = num
                    }) {
                        
                        ZStack(alignment: .bottomTrailing) {
                            Color.clear
                                .frame(maxWidth: .infinity)
                                .frame(height: 109)
                            
                            Text("\(num)회")
                                .font(.system(size: 28, weight: .medium))
                                .foregroundColor(selectedCount == num ? Color("textbg2") : Color("textbg1"))
                                .padding(.trailing, 20)
                                .padding(.bottom, 16)
                        }
                        // 버튼 자체의 배경색
                        .background(selectedCount == num ? Color("primary0") : Color("textbg2"))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(selectedCount == num ? Color("primary0") : Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }
                }
            }
            
            
            .padding(.bottom, 20)
        }
    }
        .padding(.horizontal, 16)
    }
}

#Preview {
    CommonCountSelectionView(
        title: "하루에 몇 회\n식사를 급여하시나요?",
        countOptions: [1, 2, 3, 4],
        selectedCount: .constant(3)
    )
}
