//
//  editNickname.swift
//  sugarcat
//
//  Created by 야채샌드 on 5/16/26.
//


import SwiftUI

struct EditNicknameView: View {
    @ObservedObject var viewModel: MyPageTopProfileSectionViewModel
    @Binding var path: NavigationPath
    
    // 온보딩과 동일한 상태 변수 및 포커스 선언
    @State private var inputNickname: String = ""
    @State private var errorMessage: String? = nil
    @FocusState private var isFocused: Bool
    
    // 입력된 닉네임이 비어있지 않고 에러 메시지가 없을 때만 유효함
    private var isValidNickname: Bool {
        return !inputNickname.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && errorMessage == nil
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 1. 네비게이션 헤더 바 (최상단)
            NavigationIncludeBackView(title: "닉네임 수정")
            
            // 2. 타이틀 영역 (상단에 고정 배치)
            VStack(alignment: .leading, spacing: 4) {
                (Text("새 닉네임")
                    .foregroundColor(Color("primary0")) +
                 Text("을"))
                    .mainTitleB()
                Text("입력해주세요").mainTitleB().foregroundColor(Color("textbg1"))
            }
            .padding(.top, 40)
            .padding(.horizontal, 16)
            
           
            Spacer()
            
            //닉네임 입력 필드
            VStack(alignment: .leading, spacing: 8) {
                TextField("", text: $inputNickname,
                          prompt: Text("여기에 입력해주세요").foregroundColor(.gray.opacity(0.4)))
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
                    .onSubmit {
                        if isValidNickname { executeSubmit() }
                    }
                    .padding(.horizontal, 16)
                    .onChange(of: inputNickname) { oldValue, newValue in
                        checkNicknameValidation(newValue)
                    }
                
                // 에러 메시지 출력 영역
                if let error = errorMessage {
                    Text(error)
                        .font(.system(size: 13))
                        .foregroundColor(.red)
                        .padding(.horizontal, 28)
                }
            }
            
            Spacer()
            
            // 4. 변경 완료
            Button("완료") {
                executeSubmit()
            }
            .buttonStyle(OnboardingButtonStyle(
                isValid: isValidNickname,
                isLoading: viewModel.isLoading
            ))
            .disabled(!isValidNickname || viewModel.isLoading)
            .padding(.bottom, 40)
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .bottom)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar) // 탭바 없애기
        .onTapGesture { isFocused = false }
        .onAppear {
            // 기존 마이페이지에 저장되어 있던 내 닉네임을 초기값으로 세팅
            self.inputNickname = viewModel.myNickname
        }
    }
    
    // 백엔드 PATCH 호출
    private func executeSubmit() {
        viewModel.isLoading = true
        
        viewModel.updateNickname(newNickname: inputNickname) { success in
            viewModel.isLoading = false
            if success {
                path.removeLast()
            } else {
                self.errorMessage = "닉네임 수정에 실패했습니다. 다시 시도해 주세요."
            }
        }
    }
    
    // 입력값 실시간 검사 함수
    private func checkNicknameValidation(_ value: String) {
        if value.count > 10 {
            errorMessage = "닉네임은 2~10자 이내로 입력해 주세요."
        } else if value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            errorMessage = "공백은 닉네임으로 사용할 수 없습니다."
        } else {
            errorMessage = nil
        }
    }
}

struct EditNicknameView_Previews: PreviewProvider {
    static var previews: some View {
        // 프리뷰용 더미 뷰모델 생성 및 초기화
        let mockViewModel = MyPageTopProfileSectionViewModel()
        
        // 초기화 시 화면에 미리 보여줄 기존 닉네임 세팅
        mockViewModel.myNickname = "기존고양이집사"
        
        return Group {
            // 1. 기본 라이트 모드 프리뷰
            EditNicknameView(
                viewModel: mockViewModel,
                path: .constant(NavigationPath())
            )
            .previewDisplayName("Light Mode")
            
            // 2. 다크 모드 프리뷰 (필요시 디자인 확인용)
            EditNicknameView(
                viewModel: mockViewModel,
                path: .constant(NavigationPath())
            )
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
}
