//
//  NicknameViewModel.swift
//  sugarcat
//
//  Created by 野菜サンド on 4/22/26.
//

import Foundation
import Combine


@MainActor
class NicknameViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isValidNickname: Bool = false
    
    // View에서 onChange 시 호출할 함수
    func checkNickname(_ value: String) {
        // 글자수 제한 및 유효성 검사 로직
        if value.count > 6 {
            nickname = String(value.prefix(6))
        }
        
        let trimmed = nickname.trimmingCharacters(in: .whitespaces)
        
        if trimmed.isEmpty {
            errorMessage = nil
            isValidNickname = false
            return
        }
        
        let regex = "^[가-힣a-zA-Z0-9]+$"
        let isValidFormat = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: trimmed)
        let isValidLength = trimmed.count >= 2 && trimmed.count <= 6
        
        if !isValidFormat {
            errorMessage = "한글, 영문, 숫자만 사용할 수 있어요"
            isValidNickname = false
        } else if !isValidLength {
            errorMessage = "2~6글자 사이로 입력해주세요"
            isValidNickname = false
        } else {
            errorMessage = nil
            isValidNickname = true
        }
    }
    
    //닉네임 제출 - UserService를 호출해 서버에 데이터 보냄
    func submitNickname() async -> Bool {
        isLoading = true
        errorMessage = nil
        
        do {
            try await UserService.updateNickname(nickname)
            isLoading = false
            return true
        } catch {
            isLoading = false
            errorMessage = "닉네임 설정에 실패했습니다. 다시 시도해주세요."
            return false
        }
    }
}
