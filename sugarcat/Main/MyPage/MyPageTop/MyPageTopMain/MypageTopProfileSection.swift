//
//  MypageTopProfileSection.swift
//  sugarcat
//
//  Created by 조수현 on 5/16/26.
//

import SwiftUI

// MARK: - 마이페이지 상단 프로필 섹션
struct MyPageTopProfileSection: View {
    
    @Binding var path: NavigationPath
    @ObservedObject var viewModel: MyPageTopProfileSectionViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            
            // 1. 고양이 정보
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    Circle()
                        .stroke(Color("gray3"), lineWidth: 1)
                        .frame(width: 56, height: 56)
                        .overlay(
                            Image(systemName: "cat")
                                .foregroundColor(.gray)
                        )
                        .padding(.trailing, 14)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        // 고양이 이름
                        Text(viewModel.catName.isEmpty ? "고양이 이름 없음" : viewModel.catName)
                            .body1M()
                            .foregroundColor(Color("textbg1"))
                        
                        // 나이 , 당뇨 진단 일자
                        Text("\(viewModel.catAgeInfo)\n\(viewModel.catDiagnosedDate)")
                            .caption2R()
                            .foregroundColor(Color("gray1"))
                            .lineSpacing(4)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // 고양이 정보 수정 페이지 이동
                        path.append(MyPageRoute.editCatInfo)
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
                    .stroke(Color("gray3"), lineWidth: 1)
            )
            
            // 2. 본인 프로필 카드
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    Circle()
                        .stroke(Color("gray3"), lineWidth: 1)
                        .frame(width: 56, height: 56)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(Color("gray3"))
                        )
                        .padding(.trailing, 14)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.myNickname.isEmpty ? "미등록 유저" : viewModel.myNickname)
                            .body1M()
                            .foregroundColor(Color("textbg1"))
                        
                        Text("나")
                            .caption2R()
                            .foregroundColor(Color("gray1"))
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // 닉네임 변경 페이지로 이동 액션
                        path.append(MyPageRoute.editNickname)
                    }) {
                        Text("닉네임 변경")
                            .caption3R()
                            .foregroundColor(Color("gray1"))
                            .padding(.top, 2)
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
                        print("집사 초대하기 버튼 탭")
                    }) {
                        HStack(spacing: 4) {
                            Text("집사 초대하기")
                            Image(systemName: "chevron.right")
                        }
                        .caption2R()
                        .foregroundColor(Color("gray1"))
                    }
                }
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        if !viewModel.mates.isEmpty {
                            ForEach(viewModel.mates, id: \.self) { mateNickname in
                                FamilyProfileCell(name: mateNickname)
                            }
                        } else {
                            Text("등록된 동료 집사가 없습니다.")
                                .caption2R()
                                .foregroundColor(.gray)
                                .padding(.vertical, 8)
                        }
                    }
                }
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
    }
}

// 동료 집사 원형 셀 컴포넌트
struct FamilyProfileCell: View {
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
