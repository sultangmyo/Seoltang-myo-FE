//
//  MealRecordButton.swift
//  sugarcat
//
//  Created by 서세린 on 5/2/26.
//

import SwiftUI

struct MealRecordButtonView: View {
    
    let item: MealRecordItem
    
    var body: some View {
        if item.hasRecord {
            recordedButton
        } else {
            emptyButton
        }
    }
}

private extension MealRecordButtonView {
    
    var emptyButton: some View {
        VStack {
            Image(systemName: "plus")
                .subTitle2B()
                .padding(.bottom, 8)
            Text(item.emptyTitleText)
                .body2R()
        }
        .foregroundColor(.gray0)
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 114)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.black.opacity(0.1), lineWidth: 1)
        )
    }
    
    var recordedButton: some View {
        
        VStack(alignment: .leading) {
            Text(item.displayTime)
                .subTitle2B()
                .foregroundColor(recordColorText)
            
            HStack(alignment: .bottom){
                Spacer()
                Text(item.statusText)
                    .subTitle2B()
                    .foregroundColor(recordColorText)
                recordIcon
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 114)
        .background(recordColor)
        .cornerRadius(10)
    }
    
    //버튼 배경색
    var recordColor: Color {
        switch item.mealStatus {
        case .full:
            return .primary0
        case .partial:
            return .prisub2
        case .none:
            return .white
        }
    }
    
    //버튼 텍스트 색
    var recordColorText: Color {
        switch item.mealStatus {
        case .full:
            return .textbg2
        case .partial:
            return .prisub1
        case .none:
            return .white
        }
    }
    
    // 버튼 아이콘
    var recordIcon: Image {
        switch item.mealStatus {
        case .full:
            return Image("full_meal")
        case .partial:
            return Image("partial_meal")
        case .none:
            return Image(systemName: "square")
        }
    }
}

#Preview {
    VStack(spacing: 10) {
        
        // 1️⃣ 기록 없음 상태
        MealRecordButtonView(
            item: MealRecordItem(
                sequence: 1,
                recordTime: nil,
                mealStatus: nil
            )
        )
        
        // 2️⃣ 다 먹음 상태 (FULL)
        MealRecordButtonView(
            item: MealRecordItem(
                sequence: 2,
                recordTime: "09:41:00",
                mealStatus: .full
            )
        )
        
        // 3️⃣ 일부만 먹음 상태 (PARTIAL)
        MealRecordButtonView(
            item: MealRecordItem(
                sequence: 3,
                recordTime: "13:20:00",
                mealStatus: .partial
            )
        )
        
    }
    .padding()
    .background(Color.white)
}
