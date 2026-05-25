//
//  MypageTopProfileSection.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/25/26.
//

import SwiftUI

// MARK: - 마이페이지 상단 프로필 섹션 전체
struct MyPageTopProfileSection: View {
    var body: some View {
        VStack(spacing: 24) {
            
            // 1. 고양이 정보
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    // 고양이 기본 프로필
                    Circle()
                        .stroke(Color("gray3"), lineWidth: 1)
                        .frame(width: 56, height: 56)
                        .overlay(
                            Image(systemName: "cat") 
                                .foregroundColor(.gray)
                        )
                        .padding(.trailing, 14)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("나비")
                            .body1M()
                            .foregroundColor(Color("textbg1"))
                        
                        Text("12살\n2014.05.22")
                            .caption2R()
                            .foregroundColor(Color("gray1"))
                            .lineSpacing(2)
                    }
                    
                    Spacer()
                    
                    // 정보 수정 버튼
                    Button(action: {
                        // 정보 수정 액션
                    }) {
                        Text("정보 수정")
                            .caption3R()
                            .foregroundColor(Color("gray1"))
                    }
                }
                .padding(20)
            }
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("gray3"),lineWidth: 1)
            )
            
            // 2. 본인 프로필 카드
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .center) {
                    Circle()
                        .stroke(Color("gray3"), lineWidth: 1)
                        .frame(width: 56, height: 56)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(Color("gray3"))
                        )
                        .padding(.trailing, 14)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("고대모")
                            .body1M()
                            .foregroundColor(Color("textbg1"))
                        
                        Text("나")
                            .caption2R()
                            .foregroundColor(Color("gray1"))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // 닉네임 변경 액션
                    }) {
                        Text("닉네임 변경")
                            .caption3R()
                            .foregroundColor(Color("gray1"))
                    }
                }
                .padding(20)
            }
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("gray3"), lineWidth: 1)
            )
            
            // 3. 동료 집사 목록 영역
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("동료집사")
                        .caption2R()
                        .foregroundColor(Color("textbg1"))
                    
                    Spacer()
                    
                    Button(action: {
                        // 집사 초대하기 네비게이션 혹은 링크 액션
                    }) {
                        HStack(spacing: 4) {
                            Text("집사 초대하기")
                            Image(systemName: "chevron.right")
                        }
                        .caption2R()
                        .foregroundColor(Color("gray1"))
                    }
                }
                
                // 집사 원형 아이콘 가로 스크롤/배열
                HStack(spacing: 16) {
                    MateProfileCell(name: "엄마")
                    MateProfileCell(name: "아빠")
                    // 추가 동료 집사가 있다면 늘어남
                }
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24) // 위아래 적당한 패딩감 부여
    }
}

// 동료 집사 원형 셀 컴포넌트
struct MateProfileCell: View {
    let name: String
    
    var body: some View {
        VStack(spacing: 8) {
            Circle()
                .stroke(Color("gray3"), lineWidth: 1)
                .frame(width: 56, height: 56)
                .overlay(
                    Image(systemName: "person.fill")
                        .foregroundColor(Color("gray3"))
                )
            
            Text(name)
                .caption2R()
                .foregroundColor(Color("textbg1"))
        }
    }
}
