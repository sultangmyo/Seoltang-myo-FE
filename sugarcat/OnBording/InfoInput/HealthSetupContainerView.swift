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
    
    @State private var currentStep: HealthStep = .mealCount
    
    @State private var insulinCount: Int = 1
    
    @State private var insulinTimes: [Date?] = []
    
    @State private var bloodSugarCount: Int = 1
    @State private var bloodSugarTimes: [Date?] = []
    
    @State private var mealCount: Int = 1
    @State private var mealTimes: [Date?] = []
    
    var body: some View {
        VStack(spacing: 10) {
            // 1. 상단 프로그래스바
            HStack(spacing: 6) {
                ForEach(HealthStep.allCases, id: \.self) { step in
                    Capsule()
                        .fill(step.rawValue <= currentStep.rawValue ? Color.blue : Color.gray.opacity(0.3))
                        .frame(height: 4)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // 2. 화면 분기
            switch currentStep {
                
            // --- 식사 단계 ---
            case .mealCount:
                CommonCountSelectionView(
                    title: mealCountTitle,
                    countOptions: [1, 2, 3, 4],
                    selectedCount: $mealCount
                )
                
            case .mealTime:
                CommonTimePickerView(
                    title: mealTimeTitle,
                    category: "식사",
                    count: mealCount,
                    selectedTimes: $mealTimes
                )
                
            // --- 혈당 단계 ---
            case .bloodSugarCount:
                CommonCountSelectionView(
                    title: bloodSugarCountTitle,
                    countOptions: [1, 2, 3, 4, 5, 6, 7, 8],
                    selectedCount: $bloodSugarCount
                )
                
            case .bloodSugarTime:
                CommonTimePickerView(
                    title: bloodSugarTimeTitle,
                    category: "혈당",
                    count: bloodSugarCount,
                    selectedTimes: $bloodSugarTimes
                )
           
            // --- 인슐린 단계 ---
            case .insulinCount:
                CommonCountSelectionView(
                    title: insulinCountTitle,
                    countOptions: [1, 2, 3],
                    selectedCount: $insulinCount
                )
                
            case .insulinTime:
                CommonTimePickerView(
                    title: insulintimeTitle,
                    category: "인슐린",
                    count: insulinCount,
                    selectedTimes: $insulinTimes
                )
            }
            
            Spacer()
            
            // 3. 하단 공통 버튼 영역
            HStack(spacing: 6) {
              
                if currentStep.isTimeStep {
                    Button(action: {
                        moveToPreviousStep()
                    }) {
                        Text("이전")
                            .buttontitle1()
                            .foregroundColor(Color("gray1"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 68)
                            .background(Color(.systemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color("gray1"), lineWidth: 1)
                            )
                    }
                    .frame(width: 110)
                }
                
                Button(action: {
                    moveToNextStep()
                }) {
                    
                    Text(getMainButtonTitle())
                }
                .buttonStyle(OnboardingButtonStyle(
                    isValid: checkCurrentStepValid(),
                    isLoading: false
                ))
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
        .navigationBarBackButtonHidden(true)
    }
    
   
    private func getMainButtonTitle() -> String {
        switch currentStep {
        case .mealCount, .bloodSugarCount, .insulinCount:
            return "다음"
            
        case .mealTime:
            
            let isAllFilled = mealTimes.prefix(mealCount).allSatisfy { $0 != nil }
            return isAllFilled ? "다음" : "건너뛰기"
            
        case .bloodSugarTime:
            let isAllFilled = bloodSugarTimes.prefix(bloodSugarCount).allSatisfy { $0 != nil }
            return isAllFilled ? "다음" : "건너뛰기"
            
        case .insulinTime:
            let isAllFilled = insulinTimes.prefix(insulinCount).allSatisfy { $0 != nil }
            return isAllFilled ? "완료" : "건너뛰기"
        }
    }
    
    // 다음 단계 이동
    private func moveToNextStep() {
        if let next = HealthStep(rawValue: currentStep.rawValue + 1) {
            withAnimation {
                currentStep = next
            }
        } else {
            saveHealthData()
            path.append(OnboardingPage.catInvite)
        }
    }
    
    // 이전 단계 이동
    private func moveToPreviousStep() {
        if let previous = HealthStep(rawValue: currentStep.rawValue - 1) {
            withAnimation {
                currentStep = previous
            }
        }
    }
    
    // 데이터 저장 로직
    private func saveHealthData() {
       
        print("식사 횟수: \(mealCount), 시간: \(mealTimes.prefix(mealCount))")
        print("혈당 횟수: \(bloodSugarCount), 시간: \(bloodSugarTimes.prefix(bloodSugarCount))")
        print("인슐린 횟수: \(insulinCount), 시간: \(insulinTimes.prefix(insulinCount))")
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

#Preview {
    NavigationStack {
        HealthSetupContainerView(path: .constant(NavigationPath()))
    }
}
