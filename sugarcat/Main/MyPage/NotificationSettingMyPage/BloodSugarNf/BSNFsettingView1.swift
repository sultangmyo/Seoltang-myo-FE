//
//  BSNFsettingView1.swift
//  sugarcat
//
//  Created by 서세린 on 5/13/26.
//

import SwiftUI

struct BSNFsettingView1: View {
    
    @StateObject private var viewModel = NotificationSettingViewModel(category: .bloodSugar)
    
    @State private var currentStep: Int = 1
    @Environment(\.dismiss) private var dismiss

    private var step1Title: AttributedString {
        var string = AttributedString("하루에 몇 번\n혈당을 재시나요?")
        if let range = string.range(of: "혈당") { string[range].foregroundColor = Color("primary0") }
        return string
    }

    private var step2Title: AttributedString {
        var string = AttributedString("혈당을 재는 시간을\n알려주세요")
        if let range = string.range(of: "혈당을 재는 시간") { string[range].foregroundColor = Color("primary0") }
        return string
    }

    var body: some View {
        VStack {
            NavigationIncludeBackView(title: "혈당 알림 설정")
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
                        countOptions: [1, 2, 3, 4, 5, 6, 7, 8],
                        selectedCount: $viewModel.existingCount
                    )

                    Spacer()

                    Button(action: { currentStep = 2 }) { Text("다음") }
                        .buttonStyle(OnboardingButtonStyle(isValid: true, isLoading: false))
                        .padding(.bottom, 10)

                } else {
                    CommonTimePickerView(
                        title: step2Title,
                        category: "측정",
                        count: viewModel.existingCount,
                        selectedTimes: $viewModel.existingTimes
                    )

                    Spacer()

                    // 🌟 1. 유저가 선택한 횟수(Count) 만큼 잘 채워 넣었는지 안전하게 체크해주는 변수
                    let dynamicSelection = viewModel.existingTimes.prefix(viewModel.existingCount)
                    let isAllFilled = dynamicSelection.allSatisfy { $0 != nil }

                    // 🌟 2. 상태에 맞춰 "완료" 혹은 "건너뛰기" 분기 처리 로직
                    Button(action: {
                        Task {
                            if isAllFilled {
                                // 다 채웠으면 백엔드 서버에 patch 요청 후 닫기
                                await viewModel.saveDataToBackend { dismiss() }
                            } else {
                                // 하나라도 안 채우고 '건너뛰기'를 눌렀다면 통신 없이 화면만 깔끔하게 닫기
                                // (백엔드에 null을 바로 쏘기로 로직이 완성되어있다면 이대로 dismiss()만 해도 무방합니다)
                                dismiss()
                            }
                        }
                    }) {
                        // 🌟 시안 필터링에 맞춰 버튼 글씨 동적 변경
                        Text(isAllFilled ? "완료" : "건너뛰기")
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
        BSNFsettingView1()
    }
}
