//
//  OnBordingContainer.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/7/26.
//

import SwiftUI


enum OnboardingPage: Hashable {
    case login
    case nickname
    case catSetup
    case catProfile
    case catInvite
    case healthSetup
}

struct OnBoardingContainerView: View {
    @State private var path = NavigationPath()
    
   
    var nextAction: () -> Void
    var finishAction: () -> Void

    var body: some View {
        NavigationStack(path: $path) {
           
            LoginView(nextAction: {
                path.append(OnboardingPage.nickname)
            }, finishAction: {
                finishAction()
            })
            .navigationDestination(for: OnboardingPage.self) { page in
                switch page {
                case .login:
                    LoginView(nextAction: { path.append(OnboardingPage.nickname) }, finishAction: finishAction)
                case .nickname:
                    NicknameInputView(path: $path)
                case .catSetup:
                    CatSetupView(path: $path)
                case .catProfile:
                    CatInfoInputView(path: $path)
                case .catInvite:
                    CatInviteView()
                case .healthSetup:
                    HealthSetupContainerView(path: $path)
                }
            }
        }
    }
}
