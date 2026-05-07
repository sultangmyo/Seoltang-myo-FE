//
//  HomeView.swift
//  sugarcat
//
//  Created by 서세린 on 4/9/26.
//

import SwiftUI

struct MealView: View {
    
    @State private var path = NavigationPath()
    
    @StateObject private var viewModel = MealViewModel(
        mealService: MockMealService()
    )
    
    var body: some View {
        NavigationStack(path: $path) {
            //네비게이션 헤더
            VStack{
                NavigationHeaderView(title: "식사 기록")
            }
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    Text("오늘의 식사를 \n알려주세요")
                        .mainTitleB()
                        .foregroundColor(.textbg1)
                    datePickerSection

                    recordButtonList

                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
            }
            .background(Color.white)

            .task {
                await viewModel.loadRecords()
            }
            .navigationDestination(for: MealRecordItem.self) { item in
                MealInputView(
                    item: item,
                    selectedDate: viewModel.selectedDate,
                    viewModel: viewModel
                )
            }
        }
    }
}

private extension MealView {
    
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
                    path.append(item)
                } label: {
                    MealRecordButtonView(item: item)
                }
                .buttonStyle(.plain)
                .padding(.bottom, 10)
            }
        }
    }
}

#Preview {
    MealView()
}
