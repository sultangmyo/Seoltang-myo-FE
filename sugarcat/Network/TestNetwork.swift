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
    static let local = "http://172.19.59.103:8080"
    
    // 실제 서버 붙을 때 교체
    static let production = ""
    
    // 현재 사용할 URL
    static let current = local
}

// MARK: - APIClient 임시로 생성 -> 추후에 합의후 파일 분리 예정.
enum APIClient {
    
    // 공통 Decoder
    private static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        return decoder
    }
    
    // 공통 Encoder
    private static var encoder: JSONEncoder {
        let encoder = JSONEncoder()
        return encoder
    }
    
    static func request<T: Decodable>(
        path: String,
        method: HTTPMethod
    ) async throws -> T {
        
        let urlString = BaseURL.current + path
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        //추가
        if let accessToken = TokenManager.shared.getAccessToken() {
            request.setValue(
                "Bearer \(accessToken)",
                forHTTPHeaderField: "Authorization"
            )
        }
        
        let (data, response) = try await URLSession.shared.data(
            for: request
        )
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // MARK: 디버깅 로그
        print("🌐 URL:", urlString)
        print("📡 Status Code:", httpResponse.statusCode)
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try decoder.decode(T.self, from: data)
    }
    
    // body가 있고 response body도 있는 요청
    // 예: POST 혈당 생성 → 201 + BloodSugarCreateResponseDTO
    static func requestWithBody<T: Decodable, U: Encodable>(
        path: String,
        method: HTTPMethod,
        body: U
    ) async throws -> T {
        
        let urlString = BaseURL.current + path
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        request.httpBody = try encoder.encode(body)
        
        //추가
        if let accessToken = TokenManager.shared.getAccessToken() {
            request.setValue(
                "Bearer \(accessToken)",
                forHTTPHeaderField: "Authorization"
            )
        }
        
        let (data, response) = try await URLSession.shared.data(
            for: request
        )
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // MARK: 디버깅 로그
        print("🌐 URL:", urlString)
        print("📡 Status Code:", httpResponse.statusCode)
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try decoder.decode(T.self, from: data)
    }
    
    // body가 있고 response body는 없는 요청
    // 예: deviceToken 등록
    static func requestWithoutResponse<U: Encodable>(
        path: String,
        method: HTTPMethod,
        body: U
    ) async throws {
        
        let urlString = BaseURL.current + path
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        request.httpBody = try encoder.encode(body)
        
        //추가
        if let accessToken = TokenManager.shared.getAccessToken() {
            request.setValue(
                "Bearer \(accessToken)",
                forHTTPHeaderField: "Authorization"
            )
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // MARK: 디버깅 로그
        print("🌐 URL:", urlString)
        print("📡 Status Code:", httpResponse.statusCode)
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
    }
    
    // body도 없고 response body도 없는 요청
    // 예: DELETE 혈당 기록 → 204 No Content
    static func requestWithoutResponse(
        path: String,
        method: HTTPMethod
    ) async throws {
        
        let urlString = BaseURL.current + path
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        //추가
        if let accessToken = TokenManager.shared.getAccessToken() {
            request.setValue(
                "Bearer \(accessToken)",
                forHTTPHeaderField: "Authorization"
            )
        }
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        // MARK: 디버깅 로그
        print("🌐 URL:", urlString)
        print("📡 Status Code:", httpResponse.statusCode)
        
        guard 200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
    }
}
