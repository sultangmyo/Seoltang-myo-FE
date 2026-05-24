//
//  TestNetwork.swift
//  sugarcat
//
//  Created by 서세린 on 5/18/26.
//

import Foundation

// MARK: - BaseURL 분기 처리
enum BaseURL {
    
    // 로컬 테스트용
    static let local = "http://localhost:8080"
    
    // 실제 서버 붙을 때 교체
    static let production = ""
    
    // 현재 사용할 URL
    static let current = local
}

// MARK: - APIClient 임시로 생성 -> 추후에 합의후 파일 분리 예정.
enum APIClient {
    
    static func request<T: Decodable>(
        path: String,
        method: HTTPMethod
    ) async throws -> T {
        
        // endpoint path + baseURL 합치기
        let urlString = BaseURL.current + path
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        // URLRequest 생성
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // 네트워크 요청
        let (data, response) = try await URLSession.shared.data(
            for: request
        )
        
        // HTTP 응답 확인
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // 상태 코드 검증
        guard 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        // JSON → DTO decode
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    // 응답 body가 필요 없는 요청용 함수
    // 예: deviceToken 등록, 로그아웃 등 성공 status code만 확인하면 되는 API
    static func requestWithoutResponse<T: Encodable>(
        path: String,
        method: HTTPMethod,
        body: T
    ) async throws {
        
        // endpoint path + baseURL 합치기
        let urlString = BaseURL.current + path
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        // URLRequest 생성
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        // JSON 요청 헤더
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        
        // TODO: 로그인 토큰 연결 완료된 팀원 코드에 맞게 교체
        // request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        // request body encoding
        request.httpBody = try JSONEncoder().encode(body)
        
        // 네트워크 요청
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // HTTP 응답 확인
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // 상태 코드 검증
        guard 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
    }
}
