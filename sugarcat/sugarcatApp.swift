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
    
    //앱이 실행될때 카카오 SDK 세팅
    init() {
        KakaoSDK.initSDK(appKey: "b15f47e370edea963f1e81be22a5dd96")
    }
    
    private func requestLocalNetworkPermission() {
           let url = URL(string: "http://172.19.30.146:8080")!
           URLSession.shared.dataTask(with: url) { _, _, _ in }.resume()
       }

    //app delegate 로직 추가
    @UIApplicationDelegateAdaptor(AppDelegate.self)
    var appDelegate

        
    var body: some Scene {
        WindowGroup {
            //            // 1. 기존 테스트 코드
            //            OnBoardingContainerView(nextAction: {
            //                            print("로그인 성공 -> 온보딩")
            //                        }, finishAction: {
            //                            print("이미 가입된 유저 -> 메인 화면")
            //                        })
            //                .onOpenURL { url in
            //                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
            //                        _ = AuthController.handleOpenUrl(url: url)
            //                    }
            //                }
            //                .onAppear(){
            //                    requestLocalNetworkPermission()
            //                }
            //            //2. 매인 화면 테스트 코드
            // MainTabView(logoutAction: { isLoggedIn = false})
            //                .onOpenURL { url in
            //                   if (AuthApi.isKakaoTalkLoginUrl(url)) {
            //                        _ = AuthController.handleOpenUrl(url: url)
            //                    }
            //                }
            //                .onAppear(){
            //                   requestLocalNetworkPermission()
            //                }
            //        }
            
            //새롭게 제안하는 로직 (로그인이 되어있는 상태일 때,
            NetworkGateView(status: networkMonitor.status) {
                Group {
                    switch appRoute {
                    case .launching:
                        ProgressView()
                    case .main:
                        MainTabView(
                            logoutAction: {
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
                    appRoute = .login
                }
                .task {
                    guard case .launching = appRoute else { return }
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
