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
    static let local = "http://172.29.33.93:8080"
    
    // 운영 서버
    static let production = "https://api.sugarcat.site"
    
    // 현재 사용할 URL
    static let current = production
}

enum APIError: Error {
    case invalidRefreshToken
    case server(status: Int, code: String?, message: String?)
    case invalidResponse
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

    private static let tokenRefreshCoordinator = TokenRefreshCoordinator()
    
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
        
        let (data, response) = try await send(request)
        
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
        
        let (data, response) = try await send(request)
        
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
        
        let (_, response) = try await send(request)
        
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
        
        let (_, response) = try await send(request)
        
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

    // Access Token 만료(401) 시 토큰을 재발급한 뒤 원래 요청을 한 번만 재시도
    private static func send(
        _ request: URLRequest
    ) async throws -> (Data, URLResponse) {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 401,
              let errorResponse = try? decoder.decode(
                ErrorResponseDTO.self,
                from: data
              ),
              errorResponse.code == "UNAUTHORIZED" else {
            return (data, response)
        }

        let failedAccessToken = request.value(
            forHTTPHeaderField: "Authorization"
        )?.replacingOccurrences(of: "Bearer ", with: "")
        let accessToken = try await tokenRefreshCoordinator.validAccessToken(
            failedAccessToken: failedAccessToken
        )
        var retryRequest = request
        retryRequest.setValue(
            "Bearer \(accessToken)",
            forHTTPHeaderField: "Authorization"
        )

        // 재시도에서도 401이면 다시 refresh하지 않고 호출부에 실패를 전달
        return try await URLSession.shared.data(for: retryRequest)
    }
}

// 여러 API 요청이 동시에 401을 받아도 같은 refresh 작업을 공유한다.
@MainActor
private final class TokenRefreshCoordinator {
    private var refreshTask: Task<String, Error>?

    func validAccessToken(failedAccessToken: String?) async throws -> String {
        // 대기하는 동안 다른 요청이 이미 갱신했다면 현재 토큰을 그대로 사용
        if let currentAccessToken = TokenManager.shared.getAccessToken(),
           currentAccessToken != failedAccessToken {
            return currentAccessToken
        }

        if let refreshTask {
            return try await refreshTask.value
        }

        let task = Task<String, Error> {
            try await refreshAccessToken()
        }
        refreshTask = task

        do {
            let accessToken = try await task.value
            refreshTask = nil
            return accessToken
        } catch {
            refreshTask = nil
            throw error
        }
    }

    private func refreshAccessToken() async throws -> String {
        guard let refreshToken = TokenManager.shared.getRefreshToken(),
              !refreshToken.isEmpty else {
            TokenManager.shared.expireSession()
            throw APIError.invalidRefreshToken
        }

        guard let url = URL(
            string: BaseURL.current + AuthEndpoint.jwtRefresh.path
        ) else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = AuthEndpoint.jwtRefresh.method.rawValue
        request.setValue(
            refreshToken,
            forHTTPHeaderField: "Refresh-Token"
        )

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        let errorResponse = try? JSONDecoder().decode(
            ErrorResponseDTO.self,
            from: data
        )

        if httpResponse.statusCode == 401,
           errorResponse?.code == "INVALID_REFRESH_TOKEN" {
            TokenManager.shared.expireSession()
            throw APIError.invalidRefreshToken
        }

        guard 200...299 ~= httpResponse.statusCode else {
            throw APIError.server(
                status: httpResponse.statusCode,
                code: errorResponse?.code,
                message: errorResponse?.message
            )
        }

        let refreshResponse = try JSONDecoder().decode(
            RefreshTokenResponseDTO.self,
            from: data
        )
        TokenManager.shared.saveTokens(
            access: refreshResponse.accessToken,
            refresh: refreshResponse.refreshToken
        )
        return refreshResponse.accessToken
    }
}
