
//
//  InviteCreateView.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/10/26.
//


import SwiftUI

struct InviteCreateView: View {
    @StateObject private var viewModel = InviteManageViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var showToast: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            
            
            Text("집사 초대하기")
                .BodyEmphasized()
                .foregroundColor(Color("textbg1"))
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color("textbg1"))
                        Text("뒤로가기")
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
            
            
            VStack(alignment: .leading, spacing: 4) {
                (Text("새로운 집사")
                    .foregroundColor(Color("primary0")) +
                 Text("를"))
                .mainTitleB()
                Text("초대해보세요")
                    .mainTitleB()
                    .foregroundColor(Color("textbg1"))
            }
            .padding(.top, 20)
            .padding(.horizontal, 16)
            
            Spacer()
            
            // 초대코드 카드 영역
            VStack(spacing: 8) {
                    HStack {
                        Text("친구초대 코드  \(viewModel.inviteCode)")
                            .caption2R()
                            .foregroundColor(Color("textbg1"))
                        Spacer()
                        Button("복사") {
                            UIPasteboard.general.string = viewModel.inviteCode
                            withAnimation { showToast = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation { showToast = false }
                            }
                        }
                        .caption2R()
                        .foregroundColor(.gray)
                    }
                    .padding(16)
                    .background(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                    
                    
                    if showToast {
                        Text("복사되었습니다")
                            .caption2R()
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color("gray1").opacity(0.8))
                            .cornerRadius(20)
                            .transition(.opacity.animation(.easeInOut))
                    }
                }
                .padding(.horizontal, 16)
                
                Spacer()
            
            
            Button(action: {
                Task { await viewModel.generateNewInviteCode() }
            }) {
                Text("초대코드 새로고침")
                    .buttontitle1()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 68)
                    .background(viewModel.isLoading ? Color.gray : Color("primary0"))
                    .cornerRadius(15)
            }
            .disabled(viewModel.isLoading)
            .padding(.horizontal, 16)
            .padding(.bottom, 40)
            
            
        }
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            Task { await viewModel.getInviteCode() }
        }
    }
}

struct InviteCreateView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            InviteCreateView()
        }
    }
}
