//
//  NicknameInputView.swift
//  sugarcat
//
//  Created by 野菜サンド on 4/14/26.
// api 주소 넣기

import SwiftUI

struct NicknameInputView: View {
    @State private var nickname: String = ""
    //API 호출 중 여부
    @State private var isLoading: Bool = false
    // 에러 메세지
    @State private var errorMessage: String? = nil
    //닉네임 유효성 여부
    @State private var isValidNickname: Bool = false
    //키보드 포커스 여부
    @FocusState private var isFocused: Bool
   

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 상단 타이틀
            VStack(alignment: .leading, spacing: 4) {
                Text("환영합니다!")
                    .mainTitleB()
                    .foregroundColor(Color("textbg1"))

                Text("당신의 닉네임을")
                        .mainTitleB()
                        .foregroundColor(Color("primary0"))
                
                Text("입력해주세요")
                    .mainTitleB()
                    .foregroundColor(Color("textbg1"))
            }
            .padding(.top, 70)
            .padding(.horizontal, 16)

            Spacer()

            // 닉네임 입력 필드
            VStack(alignment: .leading, spacing: 8) {
                TextField("", text: $nickname,
                          prompt: Text("여기에 입력해주세요")
                    .foregroundColor(.gray.opacity(0.4))
                )
                .caption2R()
                .foregroundColor(Color("textbg1"))
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isFocused ? Color("primary0"): Color.gray.opacity(0.3), lineWidth: 1)
                )
                .focused($isFocused)
                .submitLabel(.done)
                .onSubmit { submitNickname() }
                .padding(.horizontal, 16)
                .onChange(of: nickname) {
                    if nickname.count > 6 {
                        nickname = String(nickname.prefix(6))
                    }
                    errorMessage = validateNickname(nickname)
                    isValidNickname = errorMessage == nil && nickname.count >= 2
                }
                if let error = errorMessage {
                    Text(error)
                        .font(.system(size: 13))
                        .foregroundColor(.red)
                        .padding(.horizontal, 28)
                }
            }

            Spacer()

            // 다음 버튼
            Button(action: submitNickname) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isValidNickname ? Color("primary0") : Color("gray1"))

                    if isLoading {
                        ProgressView()
                            .tint(Color("textbg2"))
                    } else {
                        Text("다음")
                            .buttontitle1()
                            .foregroundColor(Color("textbg2"))
                    }
                }
                .frame(height: 68)
                .padding(.horizontal, 16)
            }
            .disabled(!isValidNickname || isLoading)
            .padding(.bottom, 40)
        }
        .background(Color(.white))
        .ignoresSafeArea(edges: .bottom)
        .onTapGesture { isFocused = false }
    }
    
    
// MARK: 닉네임 제출
    private func submitNickname() {
        let trimmed = nickname.trimmingCharacters(in: .whitespaces)
        isLoading = true
        errorMessage = nil

        Task {
            do {
                try await updateNickname(trimmed)
            // 성공 시 다음 화면으로 이동
            } catch {
                errorMessage = "닉네임 설정이 되지 않았습니다. 다시 시도해주세요"
            }
            isLoading = false
        }
    }
    
// MARK: API 호출부
    private func updateNickname(_ nickname: String) async throws {
        guard let url = URL(string: "https://yourapi.com/api/v1/users/me/nickname") else { throw URLError(.badURL) }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        let body = ["nickname": nickname]
        request.httpBody = try JSONEncoder().encode(body)

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
// MARK: 닉네임 유효성 검사 (한/영 2~6글자)
    private func validateNickname(_ value: String) -> String? {
        let trimmed = value.trimmingCharacters(in: .whitespaces)
        
        if trimmed.isEmpty { return nil }
        
        let regex = "^[가-힣a-zA-Z0-9]+$"
        let isValidFormat = NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: trimmed)
        let isValidLength = trimmed.count >= 2 && trimmed.count <= 6
        
        return (isValidFormat && isValidLength) ? nil : "닉네임은 한/영 2~6글자만 사용할 수 있어요"
    }
}



struct NicknameInputView_Previews: PreviewProvider {
    static var previews: some View {
        NicknameInputView()
    }
}

