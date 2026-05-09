//
//  LoginView.swift
//  sugarcat
//
//  Created by 野菜サンド on 4/14/26.
//

import SwiftUI
import AuthenticationServices
import KakaoSDKUser
import KakaoSDKAuth

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
        //오류 메세지
        .alert("로그인 실패", isPresented: $viewModel.showError) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage ?? "네트워크 오류가 발생했습니다.")
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
        // 카카오톡 앱이 있으면 앱으로, 없으면 웹 브라우저로 로그인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
                handleKakaoResponse(oauthToken: oauthToken, error: error)
            }
        } else {
            UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
                handleKakaoResponse(oauthToken: oauthToken, error: error)
            }
        }
    }
    
    // 카카오 응답 결과 처리
    private func handleKakaoResponse(oauthToken: OAuthToken?, error: Error?) {
        if let error = error {
            print("Kakao Login Error: \(error.localizedDescription)")
            return
        }
        
        if let token = oauthToken?.accessToken {
            Task {
                // ViewModel을 통해 서버에 카카오 토큰 전달
                let isOnboardingCompleted = await viewModel.handleKakaoLogin(accessToken: token)
                processLoginNavigation(isOnboardingCompleted)
            }
        }
    }
        
        private func processLoginNavigation(_ isOnboardingCompleted: Bool?) {
            guard let completed = isOnboardingCompleted else { return } // 에러 시 처리 안함
            
            if completed {
                finishAction() // 이미 온보딩 했으면 메인으로
            } else {
                nextAction()   // 처음이면 온보딩으로
            }
        }
    }

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(nextAction: {})
//    }
//}
