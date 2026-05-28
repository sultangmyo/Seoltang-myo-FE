//
//  UserService.swift
//  sugarcat
//
//  Created by 野菜サンド on 4/22/26.
//

import Foundation

struct UserService {
    
    // MARK: - 닉네임 수정
    static func updateNickname(_ nickname: String) async throws {
        guard let url = URL(string: "http://172.19.28.40:8080/api/v1/users/me/nickname") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 🔑 토큰 가져와서 헤더에 넣어주기
        if let accessToken = TokenManager.shared.getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            print("❌ 닉네임 수정 실패: 인증 토큰이 없습니다.")
            throw URLError(.userAuthenticationRequired)
        }

        let body = ["nickname": nickname]
        request.httpBody = try JSONEncoder().encode(body)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
    
   
    // MARK: - 고양이 정보 등록
    static func registerCat(requestDTO: CreateCatRequestDTO) async throws {
        guard let url = URL(string: "http://172.19.28.40:8080/api/v1/cats") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let accessToken = TokenManager.shared.getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        } else {
            throw URLError(.userAuthenticationRequired)
        }
        
       
        request.httpBody = try JSONEncoder().encode(requestDTO)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // 📡 에러가 날 경우를 대비한 디버깅 로그 추가
        if let httpResponse = response as? HTTPURLResponse {
            print("📡 서버 응답 코드: \(httpResponse.statusCode)")
            if let serverMessage = String(data: data, encoding: .utf8) {
                print("📦 서버 메시지: \(serverMessage)")
            }
        }
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
