//
//  CommonTimePickerView.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/14/26.
//

import SwiftUI

struct CommonTimePickerView: View {
    let title: AttributedString
    let category: String 
    let count: Int
    @Binding var selectedTimes: [Date]
    
    var body: some View {
      
        VStack(alignment: .leading, spacing: 30) {
            
            // 타이틀
            Text(title)
                .mainTitleB()
                .multilineTextAlignment(.leading)
                .lineSpacing(6)
                .padding(.top, 20)
            
          
            VStack(spacing: 16) {
                ForEach(0..<count, id: \.self) { index in
                    HStack {
                        
                        Text("\(index + 1)번째 \(category)")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color("textbg1"))
                        
                        Spacer()
                        
                        //시간 선택기
                        DatePicker(
                            "",
                            selection: Binding(
                                get: {
                                    if selectedTimes.indices.contains(index) {
                                        return selectedTimes[index]
                                    } else { return Date() }
                                },
                                set: { newValue in
                                    if selectedTimes.indices.contains(index) {
                                        selectedTimes[index] = newValue
                                    }
                                }
                            ),
                            displayedComponents: .hourAndMinute
                        )
                        .labelsHidden()
                        .environment(\.locale, Locale(identifier: "en_US"))
                    }
                    .frame(height: 44)
                }
            }
            
           
            Spacer()
        }
        .padding(.horizontal, 16)
        .onAppear {
            // 로직 유지: 선택된 횟수만큼 배열 방 만들기
            if selectedTimes.count != count {
                selectedTimes = Array(repeating: Date(), count: count)
            }
        }
    }
}

#Preview {
    CommonTimePickerView(
        title: "정기 식사 시간을\n알려주세요",
        category: "식사",
        count: 3,
        selectedTimes: .constant([Date(), Date(), Date()])
    )
}
