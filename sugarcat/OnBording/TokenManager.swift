//
//  TokenManager.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/7/26.
//
import Foundation

class TokenManager {
    static let shared = TokenManager()
    private let accessTokenKey = "accessToken"
    private let refreshTokenKey = "refreshToken"
    
    private init() {}

    // 토큰 저장하기
    func saveTokens(access: String, refresh: String) {
        UserDefaults.standard.set(access, forKey: accessTokenKey)
        UserDefaults.standard.set(refresh, forKey: refreshTokenKey)
        UserDefaults.standard.synchronize()
    }
    

    // Access Token 꺼내기
    func getAccessToken() -> String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }

    // Refresh Token 꺼내기
    func getRefreshToken() -> String? {
        return UserDefaults.standard.string(forKey: refreshTokenKey)
    }

    // 로그아웃 시 토큰 삭제하기
    func clearTokens() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: refreshTokenKey)
    }
}
