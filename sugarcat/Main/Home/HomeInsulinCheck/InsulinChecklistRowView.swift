//
//  InsulinChecklistRowView.swift
//  sugarcat
//
//  Created by 서세린 on 4/15/26.
//

import SwiftUI

// 인슐린 체크리스트의 한 줄 UI를 담당하는 View
struct InsulinChecklistRowView: View {
    
    // MARK: - Properties
    
    // 화면에 표시할 한 줄 데이터
    let item: InsulinChecklistItem
    
    // 체크 버튼을 눌렀을 때 부모 뷰에 알려주는 액션. sequence를 넘겨서 어떤 회차가 눌렸는지 구분할 수 있게 함
    let onTapCheck: (Int) -> Void
    
    
    // MARK: - Body
    
    var body: some View {
        HStack (alignment: .top){

            checkButton

            textSection
            
            Spacer()
        }
        .padding(.bottom, 13)
    }
}


// MARK: - Subviews
private extension InsulinChecklistRowView {
    
    // 체크 버튼 영역
    var checkButton: some View {
        Button {
            // 버튼을 눌렀을 때 현재 row의 sequence를 부모에게 전달
            onTapCheck(item.sequence)
        } label: {
            Image(systemName: item.isInjected ? "checkmark.square.fill" : "square")
                .resizable()
                .frame(width: 16, height: 16)
                .foregroundColor(item.isInjected ? .textbg1 : .secondary)
        }
        // 이미 체크된 항목은 다시 누를 수 없게 비활성화
        // 수정 불가
        .disabled(item.isInjected)
    }
    
    
    // 제목 + 설명 문구 영역
    var textSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            // 예: "1번째 인슐린"
            Text(item.title)
                .caption2R()
                .foregroundColor(.textbg1)
            
            // 체크 여부에 따라 달라지는 문구
            // 체크 전: "인슐린을 투여하지 않았어요."
            // 체크 후: "OO님이 인슐린을 투여했어요."
            Text(item.descriptionText)
                .caption2R()
                .foregroundColor(.secondary)
        }
    }
}


// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        InsulinChecklistRowView(
            item: InsulinChecklistItem(
                sequence: 1,
                title: "1번째 인슐린",
                isInjected: false,
                injectedByNickname: nil
            ),
            onTapCheck: { _ in }
        )
        
        InsulinChecklistRowView(
            item: InsulinChecklistItem(
                sequence: 2,
                title: "2번째 인슐린",
                isInjected: true,
                injectedByNickname: "희재"
            ),
            onTapCheck: { _ in }
        )
    }
    .padding()
}
