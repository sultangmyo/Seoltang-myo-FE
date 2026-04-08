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
    let isNewUser: Bool
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
    let isNewUser: Bool
}

// MARK: - JWT Refresh

// 1.3 jwt 재발급
struct RefreshTokenResponseDTO: Codable {
    let accessToken: String
    let userId: String
}
