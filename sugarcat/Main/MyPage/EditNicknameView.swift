//
//  editNickname.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/25/26.
//

import SwiftUI

struct EditNicknameView: View {
    @ObservedObject var viewModel: MyPageTopProfileSectionViewModel
    @Binding var path: NavigationPath
    
    @State private var inputNickname: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            NavigationHeaderView(title: "닉네임 변경") // 기존 뒤로가기 버튼이 포함된 헤더뷰라고 가정
            
            TextField("새로운 닉네임을 입력하세요", text: $inputNickname)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Button(action: {
                // 뷰모델의 수정 API 호출
                viewModel.updateNickname(newNickname: inputNickname) { success in
                    if success {
                        // 수정 성공 시 현재 페이지 탈출 (마이페이지로 리턴)
                        path.removeLast()
                    }
                }
            }) {
                Text("변경 완료")
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(inputNickname.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(inputNickname.isEmpty)
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            // 기존에 백엔드에서 받아왔던 현재 내 닉네임을 텍스트필드에 먼저 채워놓기
            self.inputNickname = viewModel.myNickname
        }
    }
}
