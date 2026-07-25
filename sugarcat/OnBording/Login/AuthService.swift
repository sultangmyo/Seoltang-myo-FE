//
//  AuthService.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/7/26.
//
// MARK: 나중에 시간나면 제네릭 사용 해보기

import Foundation

class AuthService {
    static let shared = AuthService()
    private let baseURL = "http://172.19.20.219:8080/api/v1" // 서버 주소 수정 필요 ( 백엔드한테 받기)
    
    private init() {} // 외부에서 인스턴스 생성 방지
    
    // Apple 로그인 통신
    func loginWithApple(token: String) async throws -> AppleLoginResponseDTO {
        guard let url = URL(string: "\(baseURL)/auth/apple") else {
            throw URLError(.badURL)
        }
        
        // 토큰 확인
        let requestDTO = AppleLoginRequestDTO(identityToken: token)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(requestDTO)
        
        // 통신 시작
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 상태 코드 확인 (200번대인지)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        // AppleLoginResponseDTO로 변환
        return try JSONDecoder().decode(AppleLoginResponseDTO.self, from: data)
    }
    
    // Kakao 로그인 통신
        func loginWithKakao(token: String) async throws -> KakaoLoginResponseDTO {
            guard let url = URL(string: "\(baseURL)/auth/kakao") else {
                throw URLError(.badURL)
            }
            
            print("📡 요청 URL: \(url)") 
            
            // 토큰 확인
            let requestDTO = KakaoLoginRequestDTO(accessToken: token)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(requestDTO)
            
            // 통신 시작
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // 상태 코드 확인 (200번대인지)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                    print("📡 Status Code: \(httpResponse.statusCode)")
                }
                print("📦 Response Data: \(String(data: data, encoding: .utf8) ?? "nil")")
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
            
            // KakaoLoginResponseDTO로 변환
            return try JSONDecoder().decode(KakaoLoginResponseDTO.self, from: data)
        }
    // 온보딩 완료 여부 체크
    func checkOnboardingStatus() async throws -> OnboardingCheckResponseDTO {
        try await APIClient.request(
            path: AuthEndpoint.onBoardingCheck.path,
            method: AuthEndpoint.onBoardingCheck.method
        )
    }
}
