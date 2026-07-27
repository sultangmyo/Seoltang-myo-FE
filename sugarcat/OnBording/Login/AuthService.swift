//
//  AuthService.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/7/26.
//

import Foundation

class AuthService {
    static let shared = AuthService()
    
    private init() {} // 외부에서 인스턴스 생성 방지
    
    // Apple 로그인 통신 (APIClient.requestWithBody 사용)
    func loginWithApple(token: String) async throws -> AppleLoginResponseDTO {
        let requestDTO = AppleLoginRequestDTO(identityToken: token)
        
        return try await APIClient.requestWithBody(
            path: "/api/v1/auth/apple",
            method: .post,
            body: requestDTO
        )
    }
    
    // Kakao 로그인 통신 (APIClient.requestWithBody 사용)
    func loginWithKakao(token: String) async throws -> KakaoLoginResponseDTO {
        let requestDTO = KakaoLoginRequestDTO(accessToken: token)
        
        return try await APIClient.requestWithBody(
            path: "/api/v1/auth/kakao",
            method: .post,
            body: requestDTO
        )
    }
    
    // 온보딩 완료 여부 체크
    func checkOnboardingStatus() async throws -> OnboardingCheckResponseDTO {
        try await APIClient.request(
            path: AuthEndpoint.onBoardingCheck.path,
            method: AuthEndpoint.onBoardingCheck.method
        )
    }
}
