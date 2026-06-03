//
//  CatService.swift
//  sugarcat
//
//  Created by 서세린 on 4/11/26.
//

import Foundation

// 실제 cat serviceprotocol
protocol HomeHeaderServiceProtocol {
    func fetchCatInfo() async throws -> CatInfoResponseDTO
}

// 해당 목업서비스 클래스는 백엔드 통신 이후 주석 처리 될 예정.
final class MockHomeHeaderprotocol: HomeHeaderServiceProtocol {
    func fetchCatInfo() async throws -> CatInfoResponseDTO {
        // 서버 대신 임시 데이터 반환
        return CatInfoResponseDTO(
            name: "나비",
            birthDate: nil,
            diagnosedDate: "2025-01-01"
        )
    }
}

// MARK: - Real Cat Service
// 실제 서버 API를 호출해서 고양이 정보를 가져오는 서비스
final class RealHomeHeaderprotocol: HomeHeaderServiceProtocol {
    
    // 고양이 기본 정보 조회
    // GET /api/v1/cats/me
    func fetchCatInfo() async throws -> CatInfoResponseDTO {
        try await APIClient.request(
            path: CatEndpoint.catInfoCheck.path,
            method: CatEndpoint.catInfoCheck.method
        )
    }
}
