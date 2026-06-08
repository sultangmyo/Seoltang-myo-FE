//
//  LogoutDeleteService.swift
//  sugarcat
//
//  Created by 서세린 on 6/7/26.
//

protocol LogoutDeleteServiceProtocol {
    func logout() async throws
    func withdraw() async throws -> MessageResponseDTO
}

final class RealLogoutDeleteService: LogoutDeleteServiceProtocol {
    
    func logout() async throws {
        try await APIClient.requestWithoutResponse(
            path: AuthEndpoint.logout.path,
            method: AuthEndpoint.logout.method
        )
    }
    
    func withdraw() async throws -> MessageResponseDTO {
        try await APIClient.request(
            path: UserEndpoint.userDelete.path,
            method: UserEndpoint.userDelete.method
        )
    }
}

// MARK: - 목업 서비스
// 백엔드 연동 전 테스트용 서비스
final class MockLogoutDeleteService: LogoutDeleteServiceProtocol {
    
    // 로그아웃
    func logout() async throws {
        print("✅ Mock 로그아웃 성공")
    }
    
    // 회원 탈퇴
    func withdraw() async throws -> MessageResponseDTO {
        print("✅ Mock 회원 탈퇴 성공")
        
        return MessageResponseDTO(
            message: "사용자 정보가 삭제되었습니다."
        )
    }
}
