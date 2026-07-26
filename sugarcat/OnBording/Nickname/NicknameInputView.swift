//
//  NicknameInputView.swift
//  sugarcat
//
//  Created by 野菜サンド on 4/14/26.
// api 주소 넣기

import SwiftUI

struct NicknameInputView: View {
    // ViewModel 인스턴스 생성
    @StateObject private var viewModel = NicknameViewModel()
    @FocusState private var isFocused: Bool
    @Binding var path: NavigationPath
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 상단 타이틀
            VStack(alignment: .leading, spacing: 0) {
                headerView
            }
            
            Spacer()
            
            // 2. 닉네임 입력 필드
            VStack(alignment: .leading, spacing: 8) {
                            TextField("", text: $viewModel.nickname,
                                      prompt: Text("여기에 입력해주세요").foregroundColor(.gray.opacity(0.4)))
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
                                .onSubmit {
                                    if viewModel.isValidNickname { executeSubmit() }
                                }
                                .padding(.horizontal, 16)
                                .onChange(of: viewModel.nickname) { oldValue, newValue in
                                    // newValue를 사용해 유효성 검사 및 글자수 제한 실행
                                    viewModel.checkNickname(newValue)
                                }

                            if let error = viewModel.errorMessage {
                                Text(error)
                                    .font(.system(size: 13))
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 28)
                            }
                        }
            
            Spacer()
            
            // 3. 다음 버튼
            Button("다음") {
                executeSubmit()
            }
            .buttonStyle(OnboardingButtonStyle(
                isValid: viewModel.isValidNickname,
                isLoading: viewModel.isLoading
            ))
                        .disabled(!viewModel.isValidNickname || viewModel.isLoading)
                        .padding(.bottom, 40)
                        .padding(.horizontal, 16)
                    }
                    .background(Color.white)
                    .ignoresSafeArea(edges: .bottom)
                    .onTapGesture { isFocused = false }
                    .navigationBarBackButtonHidden(true)
                }
    
    
    // 제출 로직을 실행하는 헬퍼 함수
    private func executeSubmit() {
        Task {
            let success = await viewModel.submitNickname()
            if success {
                path.append(OnboardingPage.catSetup)
            }
        }
    }
    
    // 타이틀
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("환영합니다!").mainTitleB().foregroundColor(Color("textbg1"))
            (Text("당신의 닉네임")
                        .foregroundColor(Color("primary0")) +
                     Text("을")
                        .foregroundColor(Color("textbg1")))
                        .mainTitleB()
            Text("입력해주세요").mainTitleB().foregroundColor(Color("textbg1"))
        }
        .padding(.top, 70)
        .padding(.horizontal, 16)
    }
}



struct NicknameInputView_Previews: PreviewProvider {
    static var previews: some View {
        NicknameInputView(path: .constant(NavigationPath()))
    }
}

