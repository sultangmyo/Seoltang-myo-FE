//
//  LoginViewModel.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/7/26.
//
import Foundation
import SwiftUI
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    
    // UI에 상태를 알려주는 변수들
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var showError: Bool = false

    // 앱 시작 시 자동 로그인 체크
    func checkAutoLogin() async -> (isLoggedIn: Bool, isOnboardingCompleted: Bool) {
        // C. 저장된 토큰이 있는지 확인
        guard let _ = TokenManager.shared.getAccessToken() else {
            // D. 토큰 없음 -> 로그인 화면으로
            return (false, false)
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            // E. 서버에 유저 상태 요청
            let response = try await AuthService.shared.checkOnboardingStatus()
            // G. 온보딩 완료 여부에 따라 결과 반환
            return (true, response.onboardingCompleted)
        } catch {
            // 토큰이 만료되었거나 에러 발생 시 로그인 화면으로
            return (false, false)
        }
    }

    // 애플 로그인 처리
    func handleAppleLogin(identityToken: String) async -> Bool? {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // J. 백엔드에 애플 토큰 전달
            let response = try await AuthService.shared.loginWithApple(token: identityToken)
            
            // K. 응답 받은 토큰 저장
            TokenManager.shared.saveTokens(access: response.accessToken, refresh: response.refreshToken)
            
            // L. 온보딩 여부 확인 (소셜 로그인 직후에 상태 체크)
            let statusResponse = try await AuthService.shared.checkOnboardingStatus()
            return statusResponse.onboardingCompleted
            
        } catch {
            self.errorMessage = "애플 로그인 중 오류가 발생했습니다."
            self.showError = true
            return nil
        }
    }

    // 카카오 로그인 처리
    func handleKakaoLogin(accessToken: String) async -> Bool? {
        isLoading = true
        defer { isLoading = false }
        
        do {
            // J. 백엔드에 카카오 토큰 전달
            let response = try await AuthService.shared.loginWithKakao(token: accessToken)
            
            // K. 응답 받은 토큰 저장
            TokenManager.shared.saveTokens(access: response.accessToken, refresh: response.refreshToken)
            
            // L. 온보딩 여부 확인
            let statusResponse = try await AuthService.shared.checkOnboardingStatus()
            return statusResponse.onboardingCompleted
            
        } catch {
            self.errorMessage = "카카오 로그인 중 오류가 발생했습니다."
            self.showError = true
            return nil
        }
    }
}
