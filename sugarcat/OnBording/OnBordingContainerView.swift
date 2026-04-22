//
//  OnBordingContainerView.swift
//  sugarcat
//
//  Created by 野菜サンド on 4/14/26.
//
import SwiftUI

// 온보딩 페이지 열거형
enum OnboardingPage: Hashable {
    //닉네임 입력 뷰
    case nickname
    //고양이 분기 선택 뷰
    case catSetup
    // 고양이 기본 정보 입력 뷰
    case catProfile
    // 고양이 초대 입력 뷰
    case catInvite
}

struct OnBoardingContainerView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            NicknameInputView(path: $path)
                .navigationDestination(for: OnboardingPage.self) { page in
                    switch page {
                    case .nickname:
                        NicknameInputView(path: $path)
                    case .catSetup:
                        CatSetupView(path: $path)
                    case .catProfile:
                        CatInfoInputView()
                    case .catInvite:
                        CatInviteView()
                    }
                    }
                }
        }
    }

