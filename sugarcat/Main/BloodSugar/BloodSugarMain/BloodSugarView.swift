//
//  HomeView.swift
//  sugarcat
//
//  Created by 서세린 on 4/9/26.
//

import SwiftUI

struct BloodSugarView: View {
    @State private var selectedItem: BloodSugarRecordItem?
    
    @StateObject private var viewModel = BloodSugarViewModel(
        bloodSugarService: MockBloodSugarService()
    )
    
    var body: some View {
        NavigationStack {
            //네비게이션 헤더
            VStack{
                NavigationHeaderView(title: "혈당 기록")
            }
            .padding(.bottom, 10)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("오늘의 혈당을 \n기록해주세요")
                        .mainTitleB()
                        .foregroundColor(.textbg1)
                    
                    datePickerSection
                    
                    recordButtonList
                }
                .padding(.horizontal, 16)
            }
            .background(Color.white)

            .task {
                await viewModel.loadRecords()
            }
            .sheet(item: $selectedItem) { item in
                BloodSugarInputView(
                    item: item,
                    selectedDate: viewModel.selectedDate
                ) { value, time in
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
                        } else {
                            if item.hasRecord {
                                await viewModel.deleteRecord(sequence: item.sequence)
                            }
                        }
                    }
                }
            }
        }
    }
}

private extension BloodSugarView {
    
    var datePickerSection: some View {
        DatePicker(
            "날짜 선택",
            selection: Binding(
                get: { viewModel.selectedDate },
                set: { newDate in
                    Task {
                        await viewModel.changeDate(newDate)
                    }
                }
            ),
            displayedComponents: .date
        )
        .datePickerStyle(.compact)
        .labelsHidden()
        .padding(.bottom, 29)
    }
    
    var recordButtonList: some View {
        VStack {
            ForEach(viewModel.items) { item in
                Button {
                    selectedItem = item
                } label: {
                    BloodSugarRecordButtonView(item: item)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

#Preview {
    BloodSugarView()
}
