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
   
    
    // 현재 스텝이 시간 설정 단계인지 확인하는 헬퍼 프로퍼티
    var isTimeStep: Bool {
        return self == .mealTime || self == .bloodSugarTime || self == .insulinTime
    }
}

struct HealthSetupContainerView: View {
    @Binding var path: NavigationPath // 메인 온보딩 네비게이션용
    
    @State private var currentStep: HealthStep = .mealCount
    
    // 0회 없이 최소 1회부터 시작하므로 기본값은 1로 설정
    @State private var insulinCount: Int = 1
    @State private var insulinTimes: [Date] = []
    
    @State private var bloodSugarCount: Int = 1
    @State private var bloodSugarTimes: [Date] = []
    
    @State private var mealCount: Int = 1
    @State private var mealTimes: [Date] = []
    
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
                    title: "하루에 몇 회\n식사를 급여하시나요?",
                    countOptions: [1, 2, 3, 4],
                    selectedCount: $mealCount
                )
                
            case .mealTime:
                CommonTimePickerView(
                    title: "정기 식사 시간을\n알려주세요",
                    count: mealCount,
                    selectedTimes: $mealTimes
                )
                
                
            // --- 혈당 단계 ---
            case .bloodSugarCount:
                CommonCountSelectionView(
                    title: "하루에 몇 회\n혈당을 재시나요?",
                    countOptions: [1, 2, 3, 4, 5, 6, 7, 8],
                    selectedCount: $bloodSugarCount
                )
                
            case .bloodSugarTime:
                CommonTimePickerView(
                    title: "혈당을 재는 시간을\n알려주세요 ",
                    count: bloodSugarCount,
                    selectedTimes: $bloodSugarTimes
                )
           
            // --- 인슐린 단계 ---
            case .insulinCount:
                CommonCountSelectionView(
                    title: "하루에 몇 회\n인슐린을 투여하나요?",
                    countOptions: [1, 2, 3],
                    selectedCount: $insulinCount
                )
                
            case .insulinTime:
                CommonTimePickerView(
                    title: "인슐린 투여 시간을\n알려주세요",
                    count: insulinCount,
                    selectedTimes: $insulinTimes
                )
                
        
            }
            
            Spacer()
            
            // 3. 하단 공통 버튼 영역
            HStack(spacing: 12) {
                // 시간 설정 단계일 때만 [이전] 버튼을 왼쪽에 노출
                if currentStep.isTimeStep {
                    Button(action: {
                        moveToPreviousStep()
                    }) {
                        Text("이전")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(Color("gray3"))
                            .frame(maxWidth: .infinity)
                            .frame(height: 68)
                            .background(Color(.systemBackground))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color("gray1"), lineWidth: 1)
                            )
                    }
                    .frame(maxWidth: .infinity)
                }
                
                
                Button(action: {
                    moveToNextStep()
                }) {
                    Text(getMainButtonTitle())
                }
                .buttonStyle(OnboardingButtonStyle(
                    isValid: checkCurrentStepValid(), // 항상 true 반환하여 언제든 넘어갈 수 있음
                    isLoading: false
                ))
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    
    // 현재 단계에 맞는 메인 버튼 텍스트 분기
    private func getMainButtonTitle() -> String {
        switch currentStep {
        case .insulinCount, .bloodSugarCount, .mealCount:
            return "다음"
        case .insulinTime, .bloodSugarTime:
            return "건너뛰기"
        case .mealTime:
            return "완료"
        }
    }
    
    // 다음 단계 이동 (순차적 이동)
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
        print("인슐린 횟수: \(insulinCount), 시간: \(insulinTimes)")
        print("혈당 횟수: \(bloodSugarCount), 시간: \(bloodSugarTimes)")
        print("식사 횟수: \(mealCount), 시간: \(mealTimes)")
    }
    
    // 단계별 유효성 검사 함수 (시간 단계는 건너뛰기가 가능하므로 무조건 true로 활성화)
    private func checkCurrentStepValid() -> Bool {
        return true
    }
}
#Preview {
    NavigationStack {
        HealthSetupContainerView(path: .constant(NavigationPath()))
    }
}
