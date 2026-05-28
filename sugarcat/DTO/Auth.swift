//
//  Auth.swift
//  sugarcat
//
//  Created by 서세린 on 4/8/26.
//

import Foundation

// MARK: - apple 소셜로그인
// 1.1 apple 소셜로그인 request dto
struct AppleLoginRequestDTO: Codable {
    let identityToken: String
}

// 1.1 apple 소셜로그인 response dto
struct AppleLoginResponseDTO: Codable {
    let accessToken: String
    let refreshToken: String
}

// MARK: -kakao 소셜로그인

// 1.2 kakao 소셜로그인 request dto
struct KakaoLoginRequestDTO: Codable {
    let accessToken: String
}

// 1.2 kakao 소셜로그인 response dto
struct KakaoLoginResponseDTO: Codable {
    let accessToken: String
    let refreshToken: String
}

// MARK: - JWT Refresh

// 1.3 jwt 재발급
struct RefreshTokenResponseDTO: Codable {
    let accessToken: String
    let userId: UUID
}

// MARK: -온보딩 완료

// 1.4.1 온보딩 완료 여부 검사
struct OnboardingCheckResponseDTO: Codable {
    let onboardingCompleted: Bool
}
// 1.4.2 온보딩 완료 여부 저장
struct OnboardingSaveResponseDTO: Codable {
    let onboardingCompleted: Bool
    let message: String
}

// MARK: - APNs Device Token

// 1.0 APNs deviceToken 등록/갱신 request DTO
struct APNsDeviceTokenRequestDTO: Codable {
    
    // APNs에서 발급한 디바이스 토큰
    let deviceToken: String
    
    // 플랫폼 정보
    // 현재 iOS만 사용
    let platform: String
}
