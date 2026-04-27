//
//  BloodSugarInputView.swift
//  sugarcat
//
//  Created by 서세린 on 4/25/26.
//

import SwiftUI

struct BloodSugarInputView: View {
    
    let item: BloodSugarRecordItem
    let selectedDate: Date
    let onComplete: (Int?, Date) -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var sugarText: String
    @State private var selectedTime: Date = Date()
    
    init(
        item: BloodSugarRecordItem,
        selectedDate: Date,
        onComplete: @escaping (Int?, Date) -> Void
    ) {
        self.item = item
        self.selectedDate = selectedDate
        self.onComplete = onComplete
        _sugarText = State(initialValue: item.sugarValue.map { String($0) } ?? "")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            DatePicker("시간", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .labelsHidden()
            
            TextField("혈당 입력", text: $sugarText)
                .keyboardType(.numberPad)
            
            Button("완료") {
                let trimmed = sugarText.trimmingCharacters(in: .whitespacesAndNewlines)
                let value = Int(trimmed)
                let time = selectedTime
                
                onComplete(value, time)
                dismiss()
            }
            
            Spacer()
        }
        .padding(20)
    }
}

#Preview {
    BloodSugarInputView(
        item: BloodSugarRecordItem(
            sequence: 1,
            recordTime: nil,
            sugarValue: nil,
            sugarStatus: nil
        ),
        selectedDate: Date()
    ) { _, _ in }
}
