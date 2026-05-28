//
//  EditCatInfoView.swift
//  sugarcat
//
//  Created by 야채샌드 on 5/28/26.
//

import SwiftUI

struct EditCatInfoView: View {
    @ObservedObject var parentViewModel: MyPageTopProfileSectionViewModel // 마이페이지 메인 데이터 동기화용
    @Binding var path: NavigationPath
    
    @StateObject private var viewModel = EditCatInfoViewModel()
    @FocusState private var focusedField: Field?

    enum Field {
        case catName
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 1. 헤더 바 (뒤로가기 포함)
            NavigationHeaderView(title: "고양이 정보 수정")
            
            VStack(alignment: .leading, spacing: 32) {
                // 고양이 이름 입력 영역
                inputSection(title: "고양이 이름") {
                    inputField(
                        text: $viewModel.catName,
                        placeholder: "여기에 이름을 입력해주세요",
                        isDisabled: false,
                        field: .catName
                    )
                }

                // 생년월일 입력 영역
                inputSection(title: "생년월일") {
                    dateInputField(
                        date: $viewModel.birthDate,
                        placeholder: "0000.00.00",
                        isDisabled: viewModel.isBirthDateUnknown
                    )
                    checkboxRow(
                        label: "생년월일을 모르겠어요.",
                        isChecked: $viewModel.isBirthDateUnknown
                    )
                }

                // 당뇨 진단 날짜 입력 영역
                inputSection(title: "당뇨 진단 날짜") {
                    dateInputField(
                        date: $viewModel.diagnosedDate,
                        placeholder: "0000.00.00",
                        isDisabled: viewModel.isDiagnosedDateUnknown
                    )
                    checkboxRow(
                        label: "진단 일자를 모르겠어요.",
                        isChecked: $viewModel.isDiagnosedDateUnknown
                    )
                }
                
                // 에러 메시지 출력
                if let error = viewModel.errorMessage {
                    Text(error)
                        .caption2R()
                        .foregroundColor(.red)
                        .padding(.horizontal, 4)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)
            
            Spacer()
            
            // 2. 변경 완료 버튼 (온보딩 버튼 스타일 계승)
            Button("변경 완료") {
                executeSubmit()
            }
            .buttonStyle(OnboardingButtonStyle(
                isValid: viewModel.isValid,
                isLoading: viewModel.isLoading
            ))
            .disabled(!viewModel.isValid || viewModel.isLoading)
            .padding(.bottom, 40)
        }
        .navigationBarHidden(true)
        .background(Color.white)
        .onTapGesture { focusedField = nil }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            // 🔑 화면이 켜지면 마이페이지 메인에 로드되어 있던 기존 고양이 정보를 컴포넌트에 바인딩합니다.
            viewModel.loadCurrentCatData(
                name: parentViewModel.catName,
                ageInfo: parentViewModel.catAgeInfo,
                diagnosedDateStr: parentViewModel.catDiagnosedDate
            )
        }
    }

    // 수정 완료 버튼 실행 로직
    private func executeSubmit() {
        viewModel.updateCatInfo { success in
            if success {
                // 🔑 서버 수정 성공 시, 마이페이지 메인의 고양이 데이터도 최신화를 위해 새로고침 동작 수행
                parentViewModel.fetchMypageData()
                path.removeLast() // 마이페이지 화면으로 뒤로가기 탈출
            }
        }
    }
    
    // MARK: - 온보딩 UI와 통일된 뷰빌더 메서드 목록
    @ViewBuilder
    private func dateInputField(date: Binding<Date>, placeholder: String, isDisabled: Bool) -> some View {
        HStack {
            Text(isDisabled ? placeholder : DateStringFormatter.displayDotDate(from: date.wrappedValue))
                .caption2R()
                .foregroundColor(isDisabled ? Color.gray.opacity(0.4) : Color("textbg1"))
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(isDisabled ? Color("gray2").opacity(0.3) : Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color("gray2"), lineWidth: 1)
        )
        .overlay {
            if !isDisabled {
                DatePicker("", selection: date, in: ...Date(), displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .opacity(0.011)
            }
        }
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
