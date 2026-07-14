//
//  NoticeService.swift
//  sugarcat
//
//  Created by 서세린 on 7/11/26.
//

import Foundation

// MARK: - Notice Service Protocol

protocol NoticeServiceProtocol {
    
    // 현재 활성화된 공지 조회
    func fetchActiveNotice() async throws -> NoticeActiveResponseDTO
}

// MARK: - Real Service

final class RealNoticeService: NoticeServiceProtocol {
    
    func fetchActiveNotice() async throws -> NoticeActiveResponseDTO {
        let endpoint = NoticeEndpoint.active
        
        return try await APIClient.request(
            path: endpoint.path,
            method: endpoint.method
        )
    }
}

// MARK: - Mock Service

final class MockNoticeService: NoticeServiceProtocol {
    
    func fetchActiveNotice() async throws -> NoticeActiveResponseDTO {
        NoticeActiveResponseDTO(
            enabled: true,
            noticeId: "service-end-2026-12",
            title: "서비스 종료 예정 안내",
            message: "본 앱은 2026년 12월 30일부로 서비스 운영을 종료할 예정입니다. 종료 전까지 필요한 기록을 확인하거나 백업해 주세요."
        )
    }
}
