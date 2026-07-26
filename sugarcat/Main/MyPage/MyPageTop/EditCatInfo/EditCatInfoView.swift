//
//  EditCatInfoView.swift
//  sugarcat
//
//  Created by 야채샌드 on 5/28/26.
//

import SwiftUI

struct EditCatInfoView: View {
    @ObservedObject var parentViewModel: MyPageTopProfileSectionViewModel
    @Binding var path: NavigationPath
    
    @StateObject private var viewModel = EditCatInfoViewModel()
    @FocusState private var focusedField: Field?
    
    
    @State private var showBirthPicker = false
    @State private var showDiagnosedPicker = false
    
    enum Field {
        case catName
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: 0){
                NavigationIncludeBackView(title: "고양이 정보 수정")
            }
            VStack(alignment: .leading, spacing: 32) {
                inputSection(title: "고양이 이름") {
                    inputField(text: $viewModel.catName, placeholder: "여기에 이름을 입력해주세요", isDisabled: false, field: .catName)
                }
                
                inputSection(title: "생년월일") {
                  
                    dateDisplayBox(date: $viewModel.birthDate, isDisabled: viewModel.isBirthDateUnknown)
                        .onTapGesture { if !viewModel.isBirthDateUnknown { showBirthPicker = true } }
                    
                    checkboxRow(label: "생년월일을 모르겠어요.", isChecked: $viewModel.isBirthDateUnknown)
                }
                
                inputSection(title: "당뇨 진단 날짜") {
                   
                    dateDisplayBox(date: $viewModel.diagnosedDate, isDisabled: viewModel.isDiagnosedDateUnknown)
                        .onTapGesture { if !viewModel.isDiagnosedDateUnknown { showDiagnosedPicker = true } }
                    
                    checkboxRow(label: "진단 일자를 모르겠어요.", isChecked: $viewModel.isDiagnosedDateUnknown)
                }
                
                if let error = viewModel.errorMessage {
                    Text(error).caption2R().foregroundColor(.red).padding(.horizontal, 4)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            
            Spacer()
            
            Button("변경 완료") { executeSubmit() }
                .buttonStyle(OnboardingButtonStyle(isValid: viewModel.isValid, isLoading: viewModel.isLoading))
                .disabled(!viewModel.isValid || viewModel.isLoading)
                .padding(.horizontal, 16)
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar) // 탭바 없애기
        .background(Color.white)
        .onTapGesture { focusedField = nil }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            viewModel.loadCurrentCatRawData(
                name: parentViewModel.catName,
                rawBirthStr: parentViewModel.rawBirthDate,
                rawDiagnosedStr: parentViewModel.rawDiagnosedDate
            )
        }
        // 캘린더 시트
        .sheet(isPresented: $showBirthPicker) { datePickerSheet(date: $viewModel.birthDate) }
        .sheet(isPresented: $showDiagnosedPicker) { datePickerSheet(date: $viewModel.diagnosedDate) }
    }
    
    // 수정 완료 버튼 실행 로직
    private func executeSubmit() {
        viewModel.updateCatInfo { success in
            if success {
                parentViewModel.refreshData()
                path.removeLast()
            }
        }
    }
    @ViewBuilder
    private func dateDisplayBox(date: Binding<Date>, isDisabled: Bool) -> some View {
        HStack {
            Text(isDisabled ? "0000.00.00" : DateStringFormatter.displayDotDate(from: date.wrappedValue))
                .caption2R()
                .foregroundColor(isDisabled ? Color.gray.opacity(0.4) : Color("textbg1"))
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(isDisabled ? Color("gray2").opacity(0.3) : Color.white)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("gray2"), lineWidth: 1))
    }
    // MARK: - 온보딩 UI와 통일된 뷰빌더 메서드 목록
    @ViewBuilder
    private func datePickerSheet(date: Binding<Date>) -> some View {
        VStack {
            DatePicker("", selection: date, in: ...Date(), displayedComponents: .date)
                .datePickerStyle(.graphical)
                .padding()
            Button("확인") { showBirthPicker = false; showDiagnosedPicker = false }
                .padding(.bottom, 20)
        }
        .presentationDetents([.medium])
    }
    
    
    @ViewBuilder
    private func inputSection(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).subTitle2B().foregroundColor(Color("textbg1"))
            content()
        }
    }
    
    @ViewBuilder
    private func inputField(text: Binding<String>, placeholder: String, isDisabled: Bool, field: Field) -> some View {
        TextField("", text: text, prompt: Text(placeholder).foregroundColor(Color("gray2")))
            .caption2R()
            .foregroundColor(isDisabled ? Color.gray.opacity(0.4) : Color("textbg1"))
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(isDisabled ? Color("gray2").opacity(0.3) : Color.white)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color("gray2"), lineWidth: 1))
            .focused($focusedField, equals: field)
    }
    
    @ViewBuilder
    private func checkboxRow(label: String, isChecked: Binding<Bool>) -> some View {
        HStack(spacing: 8) {
            Image(systemName: isChecked.wrappedValue ? "checkmark.square.fill" : "checkmark.square")
                .foregroundColor(isChecked.wrappedValue ? Color("primary0") : Color.gray.opacity(0.4))
                .onTapGesture { isChecked.wrappedValue.toggle() }
            Text(label).caption2R().foregroundColor(Color("textbg1"))
        }
    }
}


#Preview {
   
    let mockViewModel: MyPageTopProfileSectionViewModel = {
        let vm = MyPageTopProfileSectionViewModel()
        vm.catName = "설탕이"
        
        vm.rawBirthDate = "2024-03-15"
        vm.rawDiagnosedDate = "2026-01-10"
        return vm
    }()
    
    NavigationStack {
        EditCatInfoView(
            parentViewModel: mockViewModel,
            path: .constant(NavigationPath())
        )
    }
}
