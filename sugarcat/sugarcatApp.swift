//
//  sugarcatApp.swift
//  sugarcat
//
//  Created by 서세린 on 4/6/26.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth

@main
struct sugarcatApp: App {
    private enum AppRoute {
        case launching
        case login
        case onboarding
        case main
    }

    @State private var appRoute: AppRoute = .launching
    @StateObject private var networkMonitor = NetworkMonitor()
    
    // 앱이 실행될 때 카카오 SDK 세팅
    init() {
        KakaoSDK.initSDK(appKey: "b15f47e370edea963f1e81be22a5dd96")
    }
    
    private func requestLocalNetworkPermission() {
            guard let url = URL(string: BaseURL.local) else { return }
            URLSession.shared.dataTask(with: url) { _, _, _ in }.resume()
        }

    // app delegate 로직 추가
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate

    var body: some Scene {
        WindowGroup {
            NetworkGateView(status: networkMonitor.status) {
                Group {
                    switch appRoute {
                    case .launching:
                        ProgressView()
                    case .main:
                        MainTabView(
                            logoutAction: {
                                // 로그아웃 시 토큰 정리 및 라우트 변경
                                TokenManager.shared.clearTokens()
                                appRoute = .login
                            }
                        )
                    case .login:
                        OnBoardingContainerView(
                            startsWithLogin: true,
                            nextAction: {
                                appRoute = .onboarding
                            },
                            finishAction: {
                                appRoute = .main
                            }
                        )
                    case .onboarding:
                        OnBoardingContainerView(
                            startsWithLogin: false,
                            nextAction: {},
                            finishAction: {
                                appRoute = .main
                            }
                        )
                    }
                }
                .onOpenURL { url in
                    if AuthApi.isKakaoTalkLoginUrl(url) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
                .onAppear {
                    requestLocalNetworkPermission()
                }
                .onReceive(
                    NotificationCenter.default.publisher(for: .authSessionExpired)
                ) { _ in
                    // APIClient나 토큰 매니저에서 세션 만료 알림을 보낼 때 자동 로그인 화면으로 이동
                    TokenManager.shared.clearTokens()
                    appRoute = .login
                }
                .task {
                    guard case .launching = appRoute else { return }
                    
                    // APIClient를 이용하는 LoginViewModel의 자동 로그인 체크 로직 수행
                    let result = await LoginViewModel().checkAutoLogin()
                    if result.isLoggedIn {
                        appRoute = result.isOnboardingCompleted ? .main : .onboarding
                    } else {
                        appRoute = .login
                    }
                }
            }
        }
    }
}
