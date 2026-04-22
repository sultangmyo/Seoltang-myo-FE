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
        guard let url = URL(string: "https://yourapi.com/api/v1/users/me/nickname") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let body = ["nickname": nickname]
        request.httpBody = try JSONEncoder().encode(body)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
