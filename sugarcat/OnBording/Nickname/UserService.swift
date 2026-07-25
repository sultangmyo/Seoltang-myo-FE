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
        let body = ["nickname": nickname]
        try await APIClient.requestWithoutResponse(
            path: UserEndpoint.userNicknameEdit.path,
            method: UserEndpoint.userNicknameEdit.method,
            body: body
        )
    }
    
   
    // MARK: - 고양이 정보 등록
    static func registerCat(requestDTO: CreateCatRequestDTO) async throws {
        try await APIClient.requestWithoutResponse(
            path: CatEndpoint.catInfoCreate.path,
            method: CatEndpoint.catInfoCreate.method,
            body: requestDTO
        )
    }
}
