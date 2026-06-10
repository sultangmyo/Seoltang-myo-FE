
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
        
        let endpoint = CatEndpoint.catInviteCheck
        
        do {
            let response: GetInviteCodeResponseDTO = try await APIClient.request(
                path: endpoint.path,
                method: endpoint.method
            )
            self.inviteCode = response.inviteCode
        } catch {
            print("❌ 초대 코드 조회 실패: \(error)")
        }
    }
    
    // 초대코드 새로고침(생성)
    func generateNewInviteCode() async {
        isLoading = true
        let endpoint = CatEndpoint.catInviteCreate
        
        do {
            let response: GenerateInviteCodeResponseDTO = try await APIClient.request(
                path: endpoint.path,
                method: endpoint.method
            )
            self.inviteCode = response.inviteCode
        } catch {
            print("❌ 초대 코드 생성 실패: \(error)")
        }
        isLoading = false
    }
}
