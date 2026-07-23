//
//  CatInviteView.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/10/26.
//

import SwiftUI

struct CatInviteView: View {
    @StateObject private var viewModel = InviteViewModel()
    @Binding var path: NavigationPath
    var finishAction: () -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            Text("초대코드")
                .BodyEmphasized()
                .foregroundColor(Color("textbg1"))
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                .padding(.bottom, 20)
            
            headerView
            
            Spacer()
            
            // 초대코드 입력 필드
            VStack(alignment: .leading, spacing: 8) {
                TextField("", text: $viewModel.inviteCode,
                          prompt: Text("여기에 초대코드를 입력해주세요").foregroundColor(.gray.opacity(0.4)))
                    .caption2R()
                    .foregroundColor(Color("textbg1"))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(isFocused ? Color("primary0") : Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .focused($isFocused)
                    .submitLabel(.done)
                    .padding(.horizontal, 16)
            }
            
            Spacer()
            
            HStack(spacing: 6) {
                Button(action: {
                    path.removeLast()
                }) {
                    Text("이전")
                        .buttontitle1()
                        .foregroundColor(Color("gray1"))
                        .frame(maxWidth: .infinity)
                        .frame(height: 68)
                        .background(Color(.systemBackground))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color("gray1"), lineWidth: 1)
                        )
                }
                .frame(width: 110)
                
                Button(action: {
                    Task { await viewModel.verifyInviteCode() }
                }) {
                    Text("다음")
                }
                .buttonStyle(OnboardingButtonStyle(
                    isValid: !viewModel.inviteCode.isEmpty,
                    isLoading: viewModel.isLoading
                ))
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(edges: .bottom)
        .onTapGesture { isFocused = false }
        .navigationBarBackButtonHidden(true)
        
       
        .alert("알림을 허용하시겠습니까?", isPresented: $viewModel.showAlarmModal) {
            Button("허용") {
                Task {
                    
                    let granted = await NotificationManager.requestPermission()
                    if await viewModel.finalizeOnboarding(isAllowed: granted) {
                        finishAction()
                    }
                }
            }
            Button("허용 안 함", role: .cancel) {
                Task {
                    
                    if await viewModel.finalizeOnboarding(isAllowed: false) {
                        finishAction()
                    }
                }
            }
        }
    }
    
    // 헤더 뷰
    private var headerView: some View {
        VStack(alignment: .leading, spacing: 4) {
            (Text("초대 코드")
                .foregroundColor(Color("primary0")) +
             Text("를"))
            .mainTitleB()
            Text("알려주세요")
                .mainTitleB()
                .foregroundColor(Color("textbg1"))
        }
        .padding(.top, 20)
        .padding(.horizontal, 16)
    }
}

// MARK: - 프리뷰
struct CatInviteView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            CatInviteView(path: .constant(NavigationPath()), finishAction: {})
        }
    }
}
