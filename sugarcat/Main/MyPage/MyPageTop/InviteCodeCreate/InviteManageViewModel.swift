
//
//  InviteManageViewModel.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/10/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class InviteManageViewModel: ObservableObject {
    @Published var inviteCode: String = ""
    @Published var isLoading: Bool = false
    
    // 초대코드 조회
    func getInviteCode() async {
        guard inviteCode.isEmpty, !isLoading else { return }

        isLoading = true
        defer { isLoading = false }

        let endpoint = CatEndpoint.catInviteCheck

        do {
            let response: GetInviteCodeResponseDTO = try await APIClient.request(
                path: endpoint.path,
                method: endpoint.method
            )
            if response.inviteCode.isEmpty {
                inviteCode = try await requestNewInviteCode()
            } else {
                inviteCode = response.inviteCode
            }
        } catch {
            print("❌ 초대 코드 조회 실패: \(error)")
        }
    }
    
    // 초대코드 새로고침(생성)
    func generateNewInviteCode() async {
        guard !isLoading else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            inviteCode = try await requestNewInviteCode()
        } catch {
            print("❌ 초대 코드 생성 실패: \(error)")
        }
    }

    private func requestNewInviteCode() async throws -> String {
        let endpoint = CatEndpoint.catInviteCreate
        let response: GenerateInviteCodeResponseDTO = try await APIClient.request(
            path: endpoint.path,
            method: endpoint.method
        )

        return response.inviteCode
    }
}
