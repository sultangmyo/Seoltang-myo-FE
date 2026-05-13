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
    
    //앱이 실행될때 카카오 SDK 세팅
    init() {
        KakaoSDK.initSDK(appKey: "b15f47e370edea963f1e81be22a5dd96")
    }
    
    private func requestLocalNetworkPermission() {
           let url = URL(string: "http://172.19.30.146:8080")!
           URLSession.shared.dataTask(with: url) { _, _, _ in }.resume()
       }
        
    var body: some Scene {
        WindowGroup {
            OnBoardingContainerView(nextAction: {
                            print("로그인 성공 -> 온보딩")
                        }, finishAction: {
                            print("이미 가입된 유저 -> 메인 화면")
                        })
                .onOpenURL { url in
                    if (AuthApi.isKakaoTalkLoginUrl(url)) {
                        _ = AuthController.handleOpenUrl(url: url)
                    }
                }
                .onAppear(){
                    requestLocalNetworkPermission()
                }
        }
    }
}

