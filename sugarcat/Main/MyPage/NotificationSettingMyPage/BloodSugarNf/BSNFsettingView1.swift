//
//  BSNFsettingView1.swift
//  sugarcat
//
//  Created by 서세린 on 5/13/26.
//

import SwiftUI

struct BSNFsettingView1: View {
    // 백엔드에서 받아온 초기 데이터 세팅
    @State private var existingCount: Int = 3
    @State private var existingTimes: [Date] = [Date(), Date(), Date()]

    @State private var currentStep: Int = 1
    @State private var isSaving: Bool = false
    @Environment(\.dismiss) private var dismiss

    private var step1Title: AttributedString {
        var string = AttributedString("하루에 몇 번\n혈당을 재시나요?")
        if let range = string.range(of: "혈당") {
            string[range].foregroundColor = Color("primary0")
        }
        return string
    }

    private var step2Title: AttributedString {
        var string = AttributedString("혈당을 재는 시간을\n알려주세요")
        if let range = string.range(of: "혈당을 재는 시간") {
            string[range].foregroundColor = Color("primary0")
        }
        return string
    }

    var body: some View {
        VStack {
            NavigationIncludeBackView(title: "혈당 알림 설정")
                .onTapGesture {
                    // 화면 이동
                    if currentStep == 2 {
                        currentStep = 1
                    } else {
                        dismiss()
                    }
                }

            if currentStep == 1 {
                // 횟수 선택 화면
                CommonCountSelectionView(
                    title: step1Title,
                    countOptions: [1, 2, 3, 4, 5, 6, 7, 8],
                    selectedCount: $existingCount
                )

                Spacer()

                // 1단계 -> 2단계 이동
                Button(action: {
                    currentStep = 2
                }) {
                    Text("다음")
                }
                .buttonStyle(
                    OnboardingButtonStyle(isValid: true, isLoading: false)
                )
                .padding(.bottom, 10)

            } else {
                // 시간 설정 화면
                CommonTimePickerView(
                    title: step2Title,
                    category: "측정",
                    count: existingCount,
                    selectedTimes: $existingTimes
                )

                Spacer()

                // 백엔드에 최종 저장
                Button(action: {
                    saveDataToBackend()
                }) {
                    Text("완료")
                }
                .buttonStyle(
                    OnboardingButtonStyle(isValid: true, isLoading: isSaving)
                )
                .padding(.bottom, 10)
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    // 백엔드로 수정한 데이터를 다시 전송하는 함수
    private func saveDataToBackend() {
        isSaving = true

        // 최종 전송할 때는 선택한 횟수(count) 만큼만 잘라서 전송
        let finalTimes = Array(existingTimes.prefix(existingCount))

        print("--- 백엔드로 전송할 최종 데이터 ---")
        print("횟수: \(existingCount)회")
        print("시간 배열: \(finalTimes)")

        // 가상 API 통신 (1초 뒤 로딩 해제 및 화면 닫기)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isSaving = false
            dismiss()  // 저장 완료 후 재설정 화면 탈출
        }
    }
}

#Preview {
    // 미리보기 확인용 NavigationStack 래핑
    NavigationStack {
        BSNFsettingView1()
    }
}
