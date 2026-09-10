//
//  CommonTimePickerView.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/14/26.
//

import SwiftUI

struct CommonTimePickerView: View {
    let title: AttributedString
    let category: String
    let count: Int

    @Binding var selectedTimes: [Date?]
    @State private var activeSelection: TimePickerSelection?

    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            
            // 타이틀
            Text(title)
                .mainTitleB()
                .multilineTextAlignment(.leading)
                .lineSpacing(6)
                .padding(.top, 20)
            
            // 시간 선택 영역 리스트
            VStack(spacing: 16) {
                ForEach(0..<count, id: \.self) { index in
                    HStack {
                        Text("\(index + 1)번째 \(category)")
                            .body1M()
                            .foregroundColor(Color("textbg1"))
                        
                        Spacer()
                        
                        Button {
                            activeSelection = TimePickerSelection(index: index)
                        } label: {
                            Group {
                                if selectedTimes.indices.contains(index), let targetDate = selectedTimes[index] {
                                    Text(DateStringFormatter.displayTime12Hour(from: targetDate))
                                        .body2R()
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color("prisub1").opacity(0.6))
                                        .cornerRadius(20)
                                } else {
                                   
                                    Text("시간 입력")
                                        .body2R()
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .background(Color("primary0"))
                                        .cornerRadius(20)
                                }
                            }
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("\(index + 1)번째 \(category) 시간")
                        .accessibilityHint("시간 선택 창을 엽니다")
                    }
                    .frame(height: 44)
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .onAppear {
            // 서버에서 불러온 기존 시간은 유지하고, 바인딩 배열이 부족한 경우에만
            // DatePicker가 갱신할 수 있도록 필요한 크기만큼 확장한다.
            if selectedTimes.count < count {
                selectedTimes.append(
                    contentsOf: Array(repeating: nil, count: count - selectedTimes.count)
                )
            }
        }
        .sheet(item: $activeSelection) { selection in
            TimeSelectionSheet(
                title: "\(selection.index + 1)번째 \(category)",
                selectedTime: selectedTimeBinding(for: selection.index)
            )
            .presentationDetents([.height(333)])
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(32)
        }
    }

    private func selectedTimeBinding(for index: Int) -> Binding<Date?> {
        Binding(
            get: {
                guard selectedTimes.indices.contains(index) else { return nil }
                return selectedTimes[index]
            },
            set: { newValue in
                guard selectedTimes.indices.contains(index) else { return }
                selectedTimes[index] = newValue
            }
        )
    }
}

private struct TimePickerSelection: Identifiable {
    let index: Int

    var id: Int { index }
}

#Preview {
    CommonTimePickerView(
        title: "정기 식사 시간을\n알려주세요",
        category: "식사",
        count: 3,
        selectedTimes: .constant([nil, Date(), nil])
    )
}
