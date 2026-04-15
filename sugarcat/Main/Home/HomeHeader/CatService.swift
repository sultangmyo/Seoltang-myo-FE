//
//  CatService.swift
//  sugarcat
//
//  Created by 서세린 on 4/11/26.
//

import Foundation

// 실제 cat serviceprotocol
protocol CatServiceProtocol {
    func fetchCatInfo(userId: String) async throws -> CatInfoResponseDTO
}

// 해당 목업서비스 클래스는 백엔드 통신 이후 주석 처리 될 예정.
final class MockCatService: CatServiceProtocol {
    func fetchCatInfo(userId: String) async throws -> CatInfoResponseDTO {
        // 서버 대신 임시 데이터 반환
        return CatInfoResponseDTO(
            name: "나비",
            birthDate: nil,
            diagnosedDate: "2025-01-01"
        )
    }
}
