//
//  DividerBottomSection.swift
//  sugarcat
//
//  Created by 서세린 on 5/6/26.
//

import Foundation
import SwiftUI

//divider 하단 영역 뷰 구현
struct DividerBottomSection: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 내보내기 텍스트
            Text("내보내기")
                .caption2R()
                .foregroundColor(.gray1)
                .padding(.bottom, 8)
            
            
            //인쇄 및 저장 버튼 (네비게이션 링크로 구현 했습니다.)
            NavigationLink {
                PrintSaveView1()
            } label: {
                MyPageMenuRowView(
                    title: "인쇄 및 저장",
                    isButton: false,
                    action: nil
                )
            }
            .padding(.leading,16)
            .padding(.bottom, 13)
                    

            Divider()
                .padding(.bottom, 27)
            
            // 조회 관리 텍스트
            Text("조회 관리")
                .caption2R()
                .foregroundColor(.gray1)
                .padding(.bottom, 7)
            
            VStack(alignment: .leading, spacing: 0) {
                NavigationLink {
                    MyPageNotificationSettingView()
                } label: {
                    MyPageMenuRowView(
                        title: "알림설정",
                        isButton: false,
                        action: nil
                    )
                }
                
                Divider()
                
                MyPageMenuRowView(
                    title: "로그아웃",
                    isButton: true,
                    action: {
                        // 여기에 로그아웃 버튼 로직 구현하시면 됩니다.
                        print("로그아웃") // 추후에 없애고 여기에 action 구현하세요.
                    }
                )
                
                Divider()
                
                MyPageMenuRowView(
                    title: "탈퇴",
                    isButton: true,
                    action: {
                        // 여기에 탈퇴 버튼 로직 구현하시면 됩니다.
                        print("탈퇴") //추후에 없애고 여기에 action 구현하세요.
                    }
                )
                
                Divider()
                // 앱 버전
                HStack(spacing: 0){
                    MyPageMenuRowView(
                        title: "앱 버전",
                        isButton: false,
                        action: nil
                    )
                    Spacer()
                    // 버전 적어 놨습니다.
                    Text("v.1.0.0")
                        .caption2R()
                        .foregroundColor(.gray1)
                }

            }
            .padding(.leading, 16)
            
        }
        .padding(.horizontal, 16)
        .padding(.top, 22)
    }
}
