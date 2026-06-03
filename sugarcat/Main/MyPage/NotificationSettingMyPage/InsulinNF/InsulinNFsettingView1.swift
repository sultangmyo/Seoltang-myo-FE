//
//  InsulinNFsettingView1.swift
//  sugarcat
//
//  Created by 서세린 on 5/13/26.
//

import SwiftUI

struct InsulinNFsettingView1: View {

    @StateObject private var viewModel = NotificationSettingViewModel(category: .insulin)
    
    @State private var currentStep: Int = 1
    @Environment(\.dismiss) private var dismiss

    private var step1Title: AttributedString {
        var string = AttributedString("하루에 몇 번\n인슐린을 투여하시나요?")
        if let range = string.range(of: "인슐린") { string[range].foregroundColor = Color("primary0") }
        return string
    }

    private var step2Title: AttributedString {
        var string = AttributedString("인슐린 투여 시간을\n알려주세요")
        if let range = string.range(of: "인슐린 투여 시간") { string[range].foregroundColor = Color("primary0") }
        return string
    }

    var body: some View {
        VStack {
            NavigationIncludeBackView(title: "인슐린 알림 설정")
                .onTapGesture {
                    if currentStep == 2 { currentStep = 1 }
                    else { dismiss() }
                }

            if viewModel.isLoading {
                Spacer()
                ProgressView("기존 설정을 불러오는 중...")
                    .tint(Color("primary0"))
                Spacer()
            } else {
                if currentStep == 1 {
                    CommonCountSelectionView(
                        title: step1Title,
                        countOptions: [1, 2, 3], // 인슐린은 3회
                        selectedCount: $viewModel.existingCount
                    )

                    Spacer()

                    Button(action: { currentStep = 2 }) { Text("다음") }
                        .buttonStyle(OnboardingButtonStyle(isValid: true, isLoading: false))
                        .padding(.bottom, 10)

                } else {
                    CommonTimePickerView(
                        title: step2Title,
                        category: "투여",
                        count: viewModel.existingCount,
                        selectedTimes: $viewModel.existingTimes
                    )

                    Spacer()

                    Button(action: {
                        Task {
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
        InsulinNFsettingView1()
    }
}
