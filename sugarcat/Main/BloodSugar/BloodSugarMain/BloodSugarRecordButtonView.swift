//
//  BloodSugarRecordButtonView.swift
//  sugarcat
//
//  Created by 서세린 on 4/25/26.
//

import SwiftUI

struct BloodSugarRecordButtonView: View {
    
    let item: BloodSugarRecordItem
    
    var body: some View {
        if item.hasRecord {
            recordedButton
        } else {
            emptyButton
        }
    }
}

private extension BloodSugarRecordButtonView {
    
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
            Text(item.recordTime ?? "")
                .subTitle2B()
                .foregroundColor(.textbg2)
            
            HStack(alignment: .firstTextBaseline){
                Spacer()
                Text("\(item.sugarValue ?? 0)")
                    .numberCaption2()
                    .foregroundColor(.textbg2)
                Text("mg/dL")
                    .subTitle2B()
                    .foregroundColor(.textbg2)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .center)
        .frame(height: 114)
        .background(recordColor)
        .cornerRadius(10)
    }
    
    var recordColor: Color {
        switch item.sugarStatus {
        case .low:
            return Color.pointn
        case .normal:
            return Color.primary0
        case .high:
            return Color.pointo
        case .none:
            return Color.white
        }
    }
}
