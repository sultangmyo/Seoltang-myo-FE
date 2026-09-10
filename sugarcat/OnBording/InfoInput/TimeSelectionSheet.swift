//
//  TimeSelectionSheet.swift
//  sugarcat
//

import SwiftUI

/// 온보딩과 알림 설정에서 공통으로 사용하는 시간 선택 시트입니다.
/// 완료할 때만 선택값을 반영하고, 취소하면 기존 값을 유지합니다.
struct TimeSelectionSheet: View {
    let title: String
    @Binding var selectedTime: Date?

    @Environment(\.dismiss) private var dismiss
    @State private var draftTime: Date

    init(title: String, selectedTime: Binding<Date?>) {
        self.title = title
        self._selectedTime = selectedTime
        self._draftTime = State(initialValue: selectedTime.wrappedValue ?? Date())
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottomTrailing) {
                DatePicker(
                    "시간",
                    selection: $draftTime,
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.wheel)
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "en_US"))
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Button {
                    selectedTime = nil
                    dismiss()
                } label: {
                    Text("지우기")
                        .body2R()
                        .foregroundStyle(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 7)
                        .background(Color("primary0"), in: Capsule())
                }
                .buttonStyle(.plain)
                .padding(.trailing, 16)
                .padding(.bottom, 12)
                .accessibilityHint("선택된 시간을 삭제합니다")
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("완료") {
                        selectedTime = draftTime
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }
}
