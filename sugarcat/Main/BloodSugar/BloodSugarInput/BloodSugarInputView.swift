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
    @ObservedObject var viewModel: BloodSugarViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var sugarText: String
    @State private var selectedTime: Date = Date()
    
    init(
        item: BloodSugarRecordItem,
        selectedDate: Date,
        viewModel: BloodSugarViewModel
    ) {
        self.item = item
        self.selectedDate = selectedDate
        self.viewModel = viewModel
        _sugarText = State(initialValue: item.sugarValue.map { String($0) } ?? "")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            DatePicker("시간", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .labelsHidden()
            
            TextField("혈당 입력", text: $sugarText)
                .keyboardType(.numberPad)
            
            Button("입력 완료") {
                let trimmed = sugarText.trimmingCharacters(in: .whitespacesAndNewlines)
                let value = Int(trimmed)
                let time = selectedTime

                Task {
                    if let value {
                        if item.hasRecord {
                            await viewModel.updateRecord(
                                sequence: item.sequence,
                                sugarValue: value,
                                recordedTime: time
                            )
                        } else {
                            await viewModel.createRecord(
                                sequence: item.sequence,
                                sugarValue: value,
                                recordedTime: time
                            )
                        }
                    } else if item.hasRecord {
                        await viewModel.deleteRecord(sequence: item.sequence)
                    }

                    dismiss()
                }
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
        selectedDate: Date(),
        viewModel: BloodSugarViewModel(
            bloodSugarService: MockBloodSugarService()
        )
    )
}
