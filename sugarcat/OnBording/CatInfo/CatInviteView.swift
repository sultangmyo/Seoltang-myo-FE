//
//  CatInviteView.swift
//  sugarcat
//
//  Created by 野菜サンド on 4/22/26.
//
//고양이 초대 코드 입력 뷰
import SwiftUI

struct CatInviteView: View {
    @StateObject private var viewModel = InviteViewModel()
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            Text("초대 코드를 알려주세요")
                .font(.title)
                .bold()
            
            TextField("여기에 초대코드를 입력해주세요", text: $viewModel.inviteCode)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding()
            
            Button("다음") {
                Task { await viewModel.verifyInviteCode() }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.inviteCode.isEmpty || viewModel.isLoading)
        }
       
        .alert("알림을 허용하시겠습니까?", isPresented: $viewModel.showAlarmModal) {
            Button("허용", role: .none) {
                proceedToMain(isAllowed: true)
            }
            Button("허용 안 함", role: .cancel) {
                proceedToMain(isAllowed: false)
            }
        }
    }
    
    private func proceedToMain(isAllowed: Bool) {
        //  메인 이동 로직 추가 
        print("알림 허용 여부: \(isAllowed)")
       
    }
}
#Preview {
    NavigationStack {
    //일단 더미 넘김
        CatInviteView(path: .constant(NavigationPath()))
    }
}
