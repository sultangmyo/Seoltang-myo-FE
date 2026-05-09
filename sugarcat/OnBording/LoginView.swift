//
//  LoginView.swift
//  sugarcat
//
//  Created by 野菜サンド on 4/14/26.
//

import SwiftUI
import AuthenticationServices


struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    // 부모 뷰에서 온보딩 다음 단계로 넘기기 위한 액션
    var nextAction: () -> Void
    // 메인으로 바로 보내는 액션
    var finishAction: () ->Void
    
    var body: some View {
        ZStack {
            //배경이미지
            Image("login_background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .overlay(Color.black.opacity(0.7))
            
            VStack(spacing: 0) {
                Spacer()
                
                HStack(spacing: 12) {
                    Image("appiconimage")
                        .resizable()
                        .frame(width: 42, height: 42)
                        .cornerRadius(10)
                    
                    Image("appicontx")
                            .resizable()
                            .frame(width: 92.42, height: 33)
                            .cornerRadius(10)
                    
                    
                }
                
                .padding(.horizontal, 125)
                .padding(.bottom, 240)
                
                Spacer()
                
                //소셜 로그인 버튼 영역
                VStack(spacing: 16) {
                    
                    // Apple 로그인 버튼
                    SignInWithAppleButton(.signIn) { request in
                        // request.requestedScopes = [.email, .fullName]
                    } onCompletion: { result in
                        handleAppleLogin(result)
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 64)
                    .cornerRadius(12)
                    
                    // Kakao 로그인 버튼
                    Button(action: {
                        handleKakaoLogin()
                    }) {
                        HStack {
                            Image(systemName: "message.fill")
                                .foregroundColor(.black)
                            Text("Kakao 계정으로 로그인")
                                .buttontitle1()
                                .foregroundColor(Color("textbg1"))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 64)
                        .background(Color("kakao"))
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 18) //양 옆 여백
                .padding(.bottom, 100) // 하단 여백
            }
        }
    }
    
    
    // MARK: - 로그인 핸들러
    
    private func handleAppleLogin(_ result: Result<ASAuthorization, Error>) {
        switch result {
        //로그인 성공시
        case .success(let auth):
            print("Apple Login Success: \(auth)")
            // TODO: 백엔드에 애플 토큰 보내기
            // 성공 시 nextAction()호출
            nextAction()
            
        // 로그인실패시
        case .failure(let error):
            print("Apple Login Error: \(error.localizedDescription)")
        }
    }
    
    private func handleKakaoLogin() {
        print("Kakao Login Clicked")
        // TODO: Kakao SDK 호출 로직 작성
        // 성공 시 nextAction() 호출
        nextAction()
    }
}
//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(nextAction: {})
//    }
//}
