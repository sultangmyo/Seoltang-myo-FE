//
//  HealthSetupContainerView.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/14/26.
//

import SwiftUI

enum HealthStep: Int, CaseIterable {
    case mealCount = 1
    case mealTime = 2
    case bloodSugarCount = 3
    case bloodSugarTime = 4
    case insulinCount = 5
    case insulinTime = 6
    
    
    var isTimeStep: Bool {
        return self == .mealTime || self == .bloodSugarTime || self == .insulinTime
    }
}

struct HealthSetupContainerView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var store: OnboardingDataStore
    @StateObject private var viewModel: HealthSetupViewModel
    let finishAction: () -> Void
    
    @State private var currentStep: HealthStep = .mealCount
    @State private var showAlarmAlert: Bool = false
    
    
    init(path: Binding<NavigationPath>, store: OnboardingDataStore, finishAction: @escaping () -> Void) {
        self._path = path
        self.finishAction = finishAction
        self._viewModel = StateObject(wrappedValue: HealthSetupViewModel(store: store))
    }
    
    var body: some View {
        VStack(spacing: 10) {
            // 프로그래스바
            HStack(spacing: 6) {
                ForEach(HealthStep.allCases, id: \.self) { step in
                    Capsule()
                        .fill(step.rawValue <= currentStep.rawValue ? Color.blue : Color.gray.opacity(0.3))
                        .frame(height: 4)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // 단계별 화면 분기
            switch currentStep {
            case .mealCount:
                CommonCountSelectionView(title: mealCountTitle, countOptions: [1, 2, 3, 4], selectedCount: $store.mealCount)
            case .mealTime:
                CommonTimePickerView(title: mealTimeTitle, category: "식사", count: store.mealCount, selectedTimes: $store.mealTimes)
            case .bloodSugarCount:
                CommonCountSelectionView(title: bloodSugarCountTitle, countOptions: Array(1...8), selectedCount: $store.bloodSugarCount)
            case .bloodSugarTime:
                CommonTimePickerView(title: bloodSugarTimeTitle, category: "혈당", count: store.bloodSugarCount, selectedTimes: $store.bloodSugarTimes)
            case .insulinCount:
                CommonCountSelectionView(title: insulinCountTitle, countOptions: [1, 2, 3], selectedCount: $store.insulinCount)
            case .insulinTime:
                CommonTimePickerView(title: insulintimeTitle, category: "인슐린", count: store.insulinCount, selectedTimes: $store.insulinTimes)
            }
            
            Spacer()
            
            // 하단 버튼 영역
            HStack(spacing: 6) {
                if currentStep.isTimeStep {
                    Button(action: moveToPreviousStep) {
                        Text("이전").buttontitle1().foregroundColor(Color("gray1"))
                            .frame(maxWidth: .infinity).frame(height: 68)
                            .background(Color(.systemBackground))
                            .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color("gray1"), lineWidth: 1))
                    }.frame(width: 110)
                }
                
                Button(action: {
                    if currentStep.rawValue < HealthStep.allCases.count {
                        withAnimation { currentStep = HealthStep(rawValue: currentStep.rawValue + 1)! }
                    } else {
                        // 마지막 단계(insulinTime) 완료 시 얼럿 호출
                        showAlarmAlert = true
                    }
                }) {
                    Text(getMainButtonTitle())
                }
                .buttonStyle(OnboardingButtonStyle(isValid: true, isLoading: viewModel.isLoading))
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 10).padding(.bottom, 10)
        }
        .navigationBarBackButtonHidden(true)
        // 알람 권한 요청 얼럿
        .alert("알림 설정", isPresented: $showAlarmAlert) {
            Button("허용하기") {
                Task {
                    let granted = await NotificationManager.requestPermission()
                
                                finalizeOnboarding(notificationEnabled: granted)
                }
            }
            Button("나중에 하기", role: .cancel) {
                finalizeOnboarding(notificationEnabled: false)
            }
        } message: {
            Text("인슐린 투여 시간에 맞춰 알람을 받으시겠어요?")
        }
    }
    
    private func finalizeOnboarding(notificationEnabled: Bool) {
        Task {
            await MainActor.run { store.isLoading = true }
            
            // 데이터
            let dataSuccess = await viewModel.submitAllData()
            
            // 온보딩
            let completeSuccess = await viewModel.completeOnboarding()
            
            // 알림
            let alarmSuccess = await viewModel.updateNotificationSetting(isEnabled: notificationEnabled)
            
            await MainActor.run {
                store.isLoading = false
                if dataSuccess && completeSuccess {
                    if !alarmSuccess {
                        print("⚠️ 온보딩은 완료됐지만 알림 설정 저장에 실패했습니다.")
                    }
                    finishAction()
                } else {
                    print("❌ 온보딩 필수 정보 저장에 실패했습니다.")
                }
            }
        }
    }
    
    private func moveToPreviousStep() {
        if let previous = HealthStep(rawValue: currentStep.rawValue - 1) {
            withAnimation { currentStep = previous }
        }
    }
    
    private func getMainButtonTitle() -> String {
        return currentStep == .insulinTime ? "완료" : "다음"
    }
    
    
    // 단계별 유효성 검사 함수
    private func checkCurrentStepValid() -> Bool {
        return true
    }
    
    
    private var mealCountTitle: AttributedString {
        var string = AttributedString("하루에 몇 회\n식사를 급여하시나요?")
        if let range = string.range(of: "식사") { string[range].foregroundColor = Color("primary0") }
        return string
    }
    
    private var mealTimeTitle: AttributedString {
        var string = AttributedString("정기 식사 시간을\n알려주세요")
        if let range = string.range(of: "정기 식사 시간") { string[range].foregroundColor = Color("primary0") }
        return string
    }
    
    private var bloodSugarCountTitle: AttributedString {
        var string = AttributedString("하루에 몇 회\n혈당을 재시나요?")
        if let range = string.range(of: "혈당") { string[range].foregroundColor = Color("primary0") }
        return string
    }
    
    private var bloodSugarTimeTitle: AttributedString {
        var string = AttributedString("혈당을 재는 시간을\n알려주세요")
        if let range = string.range(of: "혈당을 재는 시간") { string[range].foregroundColor = Color("primary0") }
        return string
    }
    
    private var insulinCountTitle: AttributedString {
        var string = AttributedString("하루에 몇 회\n인슐린을 투여하나요?")
        if let range = string.range(of: "인슐린") { string[range].foregroundColor = Color("primary0") }
        return string
    }
    
    private var insulintimeTitle: AttributedString {
        var string = AttributedString("인슐린 투여 시간을\n알려주세요")
        if let range = string.range(of: "인슐린 투여 시간") { string[range].foregroundColor = Color("primary0") }
        return string
    }
}
