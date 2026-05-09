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
    
    //앱이 실행될때 카카오 SDK 세팅
    init() {
        KakaoSDK.initSDK(appKey: "36c5625f91b1e18acd05b5d9abe41cbc")
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
        }
    }
}

