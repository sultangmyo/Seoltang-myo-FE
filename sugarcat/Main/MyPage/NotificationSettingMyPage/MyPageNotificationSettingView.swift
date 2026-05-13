//
//  MyPageNotificationSettingView.swift
//  sugarcat
//
//  Created by 서세린 on 5/6/26.
//

import SwiftUI

struct MyPageNotificationSettingView: View {
    
    @Binding var path: NavigationPath
    
    @State private var insulinAlarm = true
    @State private var bloodSugarAlarm = true
    @State private var mealAlarm = true
    @State private var weeklyReportAlarm = true
    
    var body: some View {
        VStack(spacing: 0) {
            //네비게이션
            VStack(spacing: 0) {
                NavigationIncludeBackView(title: "")
                Divider()
            }
            
            VStack(alignment: .leading, spacing: 0) {
                // 알림설정 텍스트
                Text("알림설정")
                    .mainTitleB()
                    .foregroundColor(.textbg1)
                
                // 토글 행
                
                // 인슐린 설정
                VStack (spacing: 0) {
                    AlarmToggleRow(
                        title: "인슐린 알림 받기",
                        isOn: $insulinAlarm,
                        onToggleChanged: { print("인슐린 알림 토글: \($0)") }
                    )
                    
                    AlarmNavigationRow(
                        title: "인슐린 알림 설정",
                        onTapped: {
                            path.append(MyPageRoute.insulinNFsetting1)
                        }
                    )
                    Divider()
                        .padding(.leading, 16)
                }
                
                // 혈당 설정
                VStack (spacing: 0) {
                    AlarmToggleRow(
                        title: "혈당 알림 받기",
                        isOn: $bloodSugarAlarm,
                        onToggleChanged: { print("혈당 알림 토글: \($0)") }
                    )
                    
                    AlarmNavigationRow(
                        title: "혈당 알림 설정",
                        onTapped: {
                            path.append(MyPageRoute.bsNFsetting1)
                        }
                    )
                    Divider()
                        .padding(.leading, 16)
                }
                
                // 식사 설정
                VStack (spacing: 0) {
                    AlarmToggleRow(
                        title: "식사 알림 받기",
                        isOn: $mealAlarm,
                        onToggleChanged: { print("식사 알림 토글: \($0)") }
                    )
                    
                    AlarmNavigationRow(
                        title: "식사 알림 설정",
                        onTapped: {
                            path.append(MyPageRoute.mealNFsetting1)
                        }
                    )
                    Divider()
                        .padding(.leading, 16)
                }
                
                //주간 리포트 알림 받기
                AlarmToggleRow(
                    title: "주간 리포트 알림 받기",
                    isOn: $weeklyReportAlarm,
                    onToggleChanged: { print("주간 리포트 알림 토글: \($0)") }
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true) // 자동으로 만들어지는 back navigation 없애고 커스텀 네비게이션을 사용하는 코드
    }
}

// MARK: - 토글 ui 스타일
struct AlarmToggleRow: View {
    
    let title: String
    @Binding var isOn: Bool
    let onToggleChanged: (Bool) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 0) {
                    //알림 받기 행
                    HStack {
                        Text(title)
                            .body2R()
                            .foregroundStyle(.gray1)
                        
                        Spacer()
                        
                        Toggle("", isOn: $isOn)
                            .labelsHidden()
                            .onChange(of: isOn) { oldValue, newValue in
                                onToggleChanged(newValue)
                            }
                    }
                }
                .frame(height: 43)
                .padding(.top, 32)
                .padding(.bottom,10)
            }
        }
    }
}

// MARK: - 네비게이션 행 스타일 (top-level so it’s visible to AlarmSection)
struct AlarmNavigationRow: View {
    
    let title: String
    let onTapped: () -> Void
    
    var body: some View {
        Button {
            onTapped()
        } label: {
            HStack {
                Text(title)
                    .subTitle2B()
                    .foregroundStyle(.textbg1)
                
                Spacer()
                
                Image(systemName: "arrow.right")
                    .font(.system(size: 24))
                    .foregroundStyle(.gray1)
            }
            .padding(.leading, 16)
            .padding(.trailing, 9)
            .padding(.bottom, 8)
        }
        .buttonStyle(.plain)
        .frame(height: 44)
    }
    
}

#Preview {
    @State var previewPath = NavigationPath()
    MyPageNotificationSettingView(path: .constant(previewPath))
}
