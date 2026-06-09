
//
//  InviteManageViewModel.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/10/26.
//

import Foundation
import SwiftUI

@MainActor
class InviteManageViewModel: ObservableObject {
    @Published var inviteCode: String = ""
    @Published var isLoading: Bool = false

    // 초대코드 조회
    func getInviteCode() async {
        do {
            let response: GetInviteCodeResponseDTO = try await APIClient.request(
                path: "/api/v1/cats/me/invite-code/",
                method: .get
            )
            self.inviteCode = response.inviteCode
        } catch {
            print("❌ 초대 코드 조회 실패: \(error)")
        }
    }
    
    // 초대코드 새로고침
    func generateNewInviteCode() async {
        isLoading = true
        do {
            let response: GenerateInviteCodeResponseDTO = try await APIClient.request(
                path: "/api/v1/cats/me/invite-code/",
                method: .patch
            )
            self.inviteCode = response.inviteCode
        } catch {
            print("❌ 초대 코드 생성 실패: \(error)")
        }
        isLoading = false
    }
}
