//
//  MealNFsettingView1.swift
//  sugarcat
//
//  Created by 서세린 on 5/13/26.
//


import SwiftUI

struct MealNFsettingView1: View {
   
    @StateObject private var viewModel = NotificationSettingViewModel(category: .meal)
    
    @State private var currentStep: Int = 1
    @Environment(\.dismiss) private var dismiss

   
    private var step1Title: AttributedString {
        var string = AttributedString("하루에 몇 번\n식사를 급여하시나요?")
        if let range = string.range(of: "식사") {
            string[range].foregroundColor = Color("primary0")
        }
        return string
    }

    private var step2Title: AttributedString {
        var string = AttributedString("식사를 급여하는 시간을\n알려주세요")
        if let range = string.range(of: "식사를 급여하는 시간") {
            string[range].foregroundColor = Color("primary0")
        }
        return string
    }

    var body: some View {
        VStack {
            // 네비게이션 상단 바 및 뒤로가기 제스처
            NavigationIncludeBackView(title: "식사 알림 설정")
                .onTapGesture {
                    if currentStep == 2 {
                        currentStep = 1
                    } else {
                        dismiss()
                    }
                }

            if viewModel.isLoading {
                Spacer()
                ProgressView("기존 설정을 불러오는 중...")
                    .tint(Color("primary0"))
                Spacer()
            } else {
                if currentStep == 1 {
                    // 횟수 선택
                    CommonCountSelectionView(
                        title: step1Title,
                        countOptions: [1, 2, 3, 4],
                        selectedCount: $viewModel.existingCount
                    )

                    Spacer()

                    Button(action: { currentStep = 2 }) { Text("다음") }
                        .buttonStyle(OnboardingButtonStyle(isValid: true, isLoading: false))
                        .padding(.bottom, 10)

                } else {
                    // 시간 선택
                    CommonTimePickerView(
                        title: step2Title,
                        category: "급여",
                        count: viewModel.existingCount,
                        selectedTimes: $viewModel.existingTimes
                    )

                    Spacer()

                    Button(action: {
                        Task {
                            // 완료 성공시 화면 닫음
                            await viewModel.saveDataToBackend { dismiss() }
                        }
                    }) {
                        Text("완료")
                    }
                    .buttonStyle(OnboardingButtonStyle(isValid: true, isLoading: viewModel.isSaving))
                    .padding(.bottom, 10)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.loadSettingsFromServer()
        }
    }
}

#Preview {
    NavigationStack {
        MealNFsettingView1()
    }
}
