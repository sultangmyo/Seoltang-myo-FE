//
//  sugarcatApp.swift
//  sugarcat
//
//  Created by 서세린 on 4/6/26.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import Network

@main
struct sugarcatApp: App {
    
    //로그인 상태 변수
    @State private var isLoggedIn = false
    
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
            Group {
                if isLoggedIn {
                    MainTabView(
                        logoutAction: {
                            isLoggedIn = false
                        }
                    )
                } else {
                    OnBoardingContainerView(
                        nextAction: {
                            print("로그인 성공 -> 온보딩")
                        },
                        finishAction: {
                            isLoggedIn = true
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
        }
    }
}
