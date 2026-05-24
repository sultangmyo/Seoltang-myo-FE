//
//  NotificationDeviceTokenService.swift
//  sugarcat
//
//  Created by 서세린 on 5/24/26.
//

import Foundation

// MARK: - APNs DeviceToken 등록 서비스
// 앱 실행 후 APNs에서 deviceToken을 발급받으면
// 서버에 해당 토큰을 등록/갱신하는 역할
enum NotificationDeviceTokenService {
    
    // deviceToken 서버 등록 함수
    static func registerDeviceToken(
        _ deviceToken: String
    ) async {
        
        do {
            
            // request body 생성
            let requestDTO = APNsDeviceTokenRequestDTO(
                deviceToken: deviceToken,
                platform: "IOS"
            )
            
            // 공통 APIClient 사용
            try await APIClient.requestWithoutResponse(
                path: AuthEndpoint.apnsDeviceToken.path,
                method: AuthEndpoint.apnsDeviceToken.method,
                body: requestDTO
            )
            
            print("✅ deviceToken 서버 등록 성공")
            
        } catch {
            
            print("❌ deviceToken 서버 등록 실패:", error)
        }
    }
}
