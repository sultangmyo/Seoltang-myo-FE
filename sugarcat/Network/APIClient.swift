//
//  APIClient.swift
//  sugarcat
//
//  Created by 서세린 on 5/13/26.
//

//final class APIClient {
//
//    private let baseURL = "https://your-api.com"
//
//    func request<T: Decodable>(
//        endpoint: Endpoint,
//        responseType: T.Type
//    ) async throws -> T {
//
//        guard let url = URL(
//            string: baseURL + endpoint.path
//        ) else {
//            throw URLError(.badURL)
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = endpoint.method.rawValue
//
//        let (data, response) =
//            try await URLSession.shared.data(for: request)
//
//        return try JSONDecoder().decode(T.self, from: data)
//    }
//}
