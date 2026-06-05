//
//  CatInfoInputView.swift
//  sugarcat
//
//  Created by 野菜サンド on 4/14/26.
//
//고양이 정보 입력 뷰

import SwiftUI

struct CatInfoInputView: View {
    @Binding var path: NavigationPath
    @StateObject private var viewModel = CatInfoInputViewModel()
    @FocusState private var focusedField: Field?

    enum Field {
        case catName
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            NavigationHeaderView(title: "기본 정보 입력")
            
            VStack(alignment: .leading, spacing: 32) {
                

                // 고양이 이름
                inputSection(title: "고양이 이름") {
                    inputField(
                        text: $viewModel.catName,
                        placeholder: "여기에 이름을 입력해주세요",
                        isDisabled: false,
                        field: .catName
                    )
                }

                // 생년월일
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

                // 당뇨 진단 날짜
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
            }
            .padding(.horizontal, 16)
            .padding(.top, 24)

            
            Spacer()
            Button("다음") {
                    viewModel.saveCatInfoToStore()
                    
                    // 3. 다음 단계(식사 설정 시작 단계)로 이동합니다.
                    path.append(OnboardingPage.nextStep)
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
    }

    
    //메서드 목록
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

#Preview {
    NavigationStack {
        CatInfoInputView(path: .constant(NavigationPath()))
    }
}

