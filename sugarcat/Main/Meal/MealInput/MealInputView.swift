//
//  MealInputView.swift
//  sugarcat
//
//  Created by 서세린 on 5/2/26.
//

import SwiftUI

struct MealInputView: View {
    
    // 어떤 회차(몇 번째 식사)인지에 대한 정보
    let item: MealRecordItem
    
    // 현재 선택된 날짜 (서버에 보낼 때 사용)
    let selectedDate: Date
    
    // 식사 데이터 생성/수정을 담당하는 ViewModel
    @ObservedObject var viewModel: MealViewModel
    
    // 화면 닫기 (뒤로가기)
    @Environment(\.dismiss) private var dismiss
    
    // 사용자가 선택한 시간 (기본값: 현재 시간)
    @State private var selectedTime: Date
    
    // 사용자가 선택한 식사 상태 (다 먹음 / 덜 먹음)
    @State private var selectedStatus: MealStatus?
    
    init(
            item: MealRecordItem,
            selectedDate: Date,
            viewModel: MealViewModel
        ) {
            self.item = item
            self.selectedDate = selectedDate
            self.viewModel = viewModel

            // 기존 식사 기록 시간이 있으면 DatePicker 초기값으로 사용
            // 기록이 없으면 현재 시간 사용
            _selectedTime = State(
                initialValue: DateParser.parseTime(item.recordTime ?? "") ?? Date()
            )
            // 기존 식사 기록 상태가 있으면 버튼 선택 상태로 사용
            // 기록이 없으면 아무 버튼도 선택하지 않음
            _selectedStatus = State(
                initialValue: item.mealStatus
            )
        }
    
    var body: some View {
        VStack(spacing: 0) {

            MealNavigationHeader
            
            VStack (alignment: .leading, spacing: 10) {
                dateText
                timePicker
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top,10)
                
            Spacer()
                
            recordButton.padding(.horizontal, 16)
                
            Spacer()
        }
        completeButton
        .padding(.horizontal, 16)
        .navigationBarBackButtonHidden(true) // 자동 생성 네비게이션 없애기
        .toolbar(.hidden, for: .tabBar) // 탭바 없애기
    }
}

private extension MealInputView {
    //네비게이션 헤더
    var MealNavigationHeader: some View {
        ZStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "chevron.left")
                        Text("뒤로가기")
                    }
                }
                Spacer()
            }
            .padding(.leading, 8)
            
            Text("\(item.sequence)번째 식사")
                .frame(maxWidth: .infinity)
                .BodyEmphasized() //폰트 모디파이어 사용.
        }
        .padding(.vertical, 11)
        .background(Color.white)
    }
    // 날짜 표시
    var dateText: some View {
        Text(DateStringFormatter.displayKoreanDate(from: selectedDate))
            .mainTitleB()
            .foregroundColor(.textbg1)
    }
    // 시간 피커
    var timePicker: some View {
        DatePicker(
            "",
            selection: $selectedTime,
            displayedComponents: .hourAndMinute
        )
        .labelsHidden()
    }
    
    var recordButton : some View {
        HStack(spacing: 15) {
            mealButton(title: "다 먹었어요", icon: "full_meal", status: .full)

            mealButton(title: "조금 남겼어요", icon: "partial_meal", status: .partial)
        }
    }
    
    // 완료 버튼
    var completeButton: some View {
        Button {
            guard let selectedStatus else { return }

            Task {
                if item.hasRecord {
                    await viewModel.updateRecord(
                        sequence: item.sequence,
                        mealStatus: selectedStatus,
                        recordedTime: selectedTime
                    )
                } else {
                    await viewModel.createRecord(
                        sequence: item.sequence,
                        mealStatus: selectedStatus,
                        recordedTime: selectedTime
                    )
                }
                dismiss()
            }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(selectedStatus != nil ? Color.primary0 : Color.gray1)
                Text("완료")
                    .buttontitle1()
                    .foregroundColor(.textbg2)
            }
            .frame(height: 68)
        }
        .disabled(selectedStatus == nil)
    }
    
    // MARK: - 버튼 함수
    func mealButton(
        title: String,
        icon: String,
        status: MealStatus) -> some View {
            
            let isSelected = selectedStatus == status
            
            return Button {
                selectedStatus = status
            } label: {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text(title)
                        .body1SB()
                        .foregroundColor(isSelected ? .textbg2 : .textbg1)
                    
                    Spacer()
                    
                    HStack{
                        Spacer()
                        
                        Image(icon)
                            .foregroundColor(isSelected ? .textbg2 : .gray3)
                        
                    }
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .frame(height: 109)
            .background(
                isSelected ? Color.primary0 : Color.white
            )
            
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        selectedStatus == status
                        ? Color.clear
                        : Color.black.opacity(0.1),
                        lineWidth: 1
                        )
                )
        }
    
}

#Preview {
    NavigationStack {
        MealInputView(
            item: MealRecordItem(
                sequence: 1,
                recordTime: nil,
                mealStatus: nil
            ),
            selectedDate: Date(),
            viewModel: MealViewModel(
                mealService: MockMealService()
            )
        )
    }
}
