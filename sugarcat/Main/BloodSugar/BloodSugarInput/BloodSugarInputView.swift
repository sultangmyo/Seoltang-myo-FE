//
//  BloodSugarInputView.swift
//  sugarcat
//
//  Created by 서세린 on 4/25/26.
//

import SwiftUI

struct BloodSugarInputView: View {
    
    let item: BloodSugarRecordItem
    let selectedDate: Date
    @ObservedObject var viewModel: BloodSugarViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var sugarText: String
    @State private var selectedTime: Date = Date()
    
    init(
        item: BloodSugarRecordItem,
        selectedDate: Date,
        viewModel: BloodSugarViewModel
    ) {
        self.item = item
        self.selectedDate = selectedDate
        self.viewModel = viewModel
        _sugarText = State(initialValue: item.sugarValue.map { String($0) } ?? "")
    }
    
    var body: some View {
        VStack(spacing: 0) {
            BSNavigationHeader
            
            VStack (alignment: .leading, spacing: 10) {
                dateText
                timePicker
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.top,10)
            
            Spacer()
            
            sugarValueView
            
            Spacer()
            
            completeButton
            
            customNumberPad
        }
        .navigationBarBackButtonHidden(true) // 자동 생성 네비게이션 없애기
        .toolbar(.hidden, for: .tabBar) // 탭바 없애기
    }
}

//익스텐션

private extension BloodSugarInputView {
    //네비게이션 헤더
    var BSNavigationHeader: some View {
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
            
            Text("\(item.sequence)번째 기록")
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
    
    // 수치표시
    var sugarValueView: some View {
        ZStack {
            // 숫자 + 밑줄 (완전 중앙)
            VStack(spacing: 0) {
                Text(sugarText.isEmpty ? "0" : sugarText)
                    .numberCaption1()
                    .foregroundColor(.textbg1)
                    .monospacedDigit()
                
                Rectangle()
                    .fill(Color.black.opacity(0.1))
                    .frame(width: 150, height: 1)
                    .padding(.horizontal, 60)
            }
            
            // mg/dL (숫자 기준 오른쪽)
            HStack {
                Spacer()
                
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("999")
                        .numberCaption1()
                        .opacity(0) // 자리만 차지
                    
                    Text("mg/dL")
                        .graphBarTitle()
                        .foregroundColor(.textbg1)
                }
            }
            .padding(.horizontal, 60)
        }
        .frame(maxWidth: .infinity)
    }
    
    // 입력 완료 버튼
    var completeButton: some View {
        Button("입력 완료") {
            let trimmed = sugarText.trimmingCharacters(in: .whitespacesAndNewlines)
            let value = Int(trimmed)
            let time = selectedTime
            
            Task {
                if let value {
                    if item.hasRecord {
                        await viewModel.updateRecord(
                            sequence: item.sequence,
                            sugarValue: value,
                            recordedTime: time
                        )
                    } else {
                        await viewModel.createRecord(
                            sequence: item.sequence,
                            sugarValue: value,
                            recordedTime: time
                        )
                    }
                } else if item.hasRecord {
                    await viewModel.deleteRecord(sequence: item.sequence)
                }
                
                dismiss()
            }
        }
        .buttontitle2()
        .foregroundColor(.gray0)
        .padding(.bottom, 10)
    }
    
    //커스텀 키보드
    var customNumberPad: some View {
        VStack(spacing: 0) {
            numberPadRow(["1", "2", "3"])
            numberPadRow(["4", "5", "6"])
            numberPadRow(["7", "8", "9"])
            
            HStack(spacing: 0) {
                Button {
                    clearSugarText()
                } label: {
                    Text("재배열")
                        .subTitle2B()
                        .foregroundColor(.textbg2)
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                }
                
                numberButton("0")
                
                Button {
                    removeLastDigit()
                } label: {
                    Image(systemName: "arrow.left")
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                }
                .foregroundColor(.textbg2)
                .subTitle2B()
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 40)
        .background(.primary0)
    }
    
    func numberPadRow(_ numbers: [String]) -> some View {
        HStack(spacing: 0) {
            ForEach(numbers, id: \.self) { number in
                numberButton(number)
            }
        }
    }
    // 숫자 버튼 스타일
    func numberButton(_ number: String) -> some View {
        Button {
            appendDigit(number)
        } label: {
            Text(number)
                .numberCaption2()
                .foregroundColor(.textbg2)
                .frame(maxWidth: .infinity)
                .frame(height: 70)
        }
    }
    
    // 숫자 버튼 험수
    func appendDigit(_ digit: String) {
        guard sugarText.count < 3 else { return }
        
        if sugarText == "0" {
            sugarText = digit
        } else {
            sugarText += digit
        }
    }
    
    // 왼쪽 상단 재배열 버튼 함수
    func clearSugarText() {
        sugarText = ""
    }
    
    // 오른쪽 하단 <- 버튼 함수
    func removeLastDigit() {
        guard !sugarText.isEmpty else { return }
        sugarText.removeLast()
    }
    
}


#Preview {
    BloodSugarInputView(
        item: BloodSugarRecordItem(
            sequence: 1,
            recordTime: nil,
            sugarValue: nil,
            sugarStatus: nil
        ),
        selectedDate: Date(),
        viewModel: BloodSugarViewModel(
            bloodSugarService: MockBloodSugarService()
        )
    )
}
