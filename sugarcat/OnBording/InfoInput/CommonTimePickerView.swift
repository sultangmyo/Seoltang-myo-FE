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
    
    
    @Binding var selectedTimes: [Date?]

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            
            // 타이틀
            Text(title)
                .mainTitleB()
                .multilineTextAlignment(.leading)
                .lineSpacing(6)
                .padding(.top, 20)
            
            // 시간 선택 영역 리스트
            VStack(spacing: 16) {
                ForEach(0..<count, id: \.self) { index in
                    HStack {
                        Text("\(index + 1)번째 \(category)")
                            .body1M()
                            .foregroundColor(Color("textbg1"))
                        
                        Spacer()
                        
                       
                        ZStack(alignment: .trailing) {
                            
                           
                            DatePicker(
                                selection: Binding(
                                    get: {
                                     
                                        selectedTimes.indices.contains(index) ? (selectedTimes[index] ?? Date()) : Date()
                                    },
                                    set: { newValue in
                                        if selectedTimes.indices.contains(index) {
                                            selectedTimes[index] = newValue
                                        }
                                    }
                                ),
                                displayedComponents: .hourAndMinute
                            ){
                                Text("")
                            }
                            .labelsHidden()
                            .environment(\.locale, Locale(identifier: "en_US"))
                            .opacity(0.011)
                            .zIndex(2)
                            
                            
                            Group {
                                if selectedTimes.indices.contains(index), let targetDate = selectedTimes[index] {
                                    Text(DateStringFormatter.displayTime12Hour(from: targetDate))
                                        .body2R()
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color("prisub1").opacity(0.6))
                                        .cornerRadius(20)
                                } else {
                                   
                                    Text("시간 입력")
                                        .body2R()
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color("primary0"))
                                        .cornerRadius(20)
                                }
                            }
                            .allowsHitTesting(false)
                            .zIndex(1)
                        }
                    }
                    .frame(height: 44)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .onAppear {
            
            if selectedTimes.count != count {
                selectedTimes = Array(repeating: nil, count: count)
            }
        }
    }
    

}

#Preview {
    CommonTimePickerView(
        title: "정기 식사 시간을\n알려주세요",
        category: "식사",
        count: 3,
        selectedTimes: .constant([nil, Date(), nil])
    )
}
