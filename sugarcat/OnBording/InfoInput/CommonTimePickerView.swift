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
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color("textbg1"))
                        
                        Spacer()
                        
                       
                        ZStack(alignment: .trailing) {
                            
                           
                            DatePicker(
                                "",
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
                            )
                            .labelsHidden()
                            .environment(\.locale, Locale(identifier: "en_US"))
                            .opacity(0.011)
                            .zIndex(2)
                            
                            
                            Group {
                                if selectedTimes.indices.contains(index), let targetDate = selectedTimes[index] {
                                  
                                    Text(formattedTimeString(from: targetDate))
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color("primary0").opacity(0.6))
                                        .cornerRadius(20)
                                } else {
                                   
                                    Text("시간 입력")
                                        .font(.system(size: 16, weight: .medium))
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
    
    // "12:30 AM" 형태의 북미권 시간 표기법 양식 변환기
    private func formattedTimeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: date)
    }
}

#Preview {
    CommonTimePickerView(
        title: "정기 식사 시간을\n알려주세요",
        category: "식사",
        count: 3,
        selectedTimes: .constant([nil, nil, nil])
    )
}
