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
    case mainHome
}

struct OnBoardingContainerView: View {
    @State private var path = NavigationPath()
    
    @StateObject private var store = OnboardingDataStore()
    
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
                    CatInfoInputView(path: $path, store: store)
                case .catInvite:
                    CatInviteView(path: $path)
                case .healthSetup:
                    HealthSetupContainerView(path: $path, store: store)
                case .mainHome:
                    MainTabView(logoutAction: finishAction)
                }
            }
        }
        .environmentObject(store)
    }
}
