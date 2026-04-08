//
//  Auth.swift
//  sugarcat
//
//  Created by 서세린 on 4/8/26.
//

import Foundation

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

