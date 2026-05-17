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
}
