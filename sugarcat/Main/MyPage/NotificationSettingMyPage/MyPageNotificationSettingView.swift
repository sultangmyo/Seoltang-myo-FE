//
//  MyPageNotificationSettingView.swift
//  sugarcat
//
//  Created by 서세린 on 5/6/26.
//

import SwiftUI
import Combine
import UIKit
import UserNotifications

struct MyPageNotificationSettingView: View {
    
    @Binding var path: NavigationPath
    @StateObject private var viewModel = MyPageNotificationSettingViewModel()
    @Environment(\.scenePhase) private var scenePhase
    
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
                        isOn: notificationBinding(
                            for: \.insulinAlarm,
                            type: .insulin
                        ),
                        isDisabled: viewModel.isUpdating(.insulin)
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
                        isOn: notificationBinding(
                            for: \.bloodSugarAlarm,
                            type: .blood
                        ),
                        isDisabled: viewModel.isUpdating(.blood)
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
                        isOn: notificationBinding(
                            for: \.mealAlarm,
                            type: .meal
                        ),
                        isDisabled: viewModel.isUpdating(.meal)
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
                    isOn: notificationBinding(
                        for: \.weeklyReportAlarm,
                        type: .weekly
                    ),
                    isDisabled: viewModel.isUpdating(.weekly)
                )

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .caption2R()
                        .foregroundStyle(.red)
                        .padding(.top, 12)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true) // 자동으로 만들어지는 back navigation 없애고 커스텀 네비게이션을 사용하는 코드
        .toolbar(.hidden, for: .tabBar)
        .task {
            await viewModel.loadSettings()
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active else { return }
            Task {
                await viewModel.loadSettings()
            }
        }
        .alert(
            "시스템 알림을 먼저 활성화해 주세요",
            isPresented: $viewModel.showsSystemPermissionAlert
        ) {
            Button("설정으로 이동") {
                guard let settingsURL = URL(
                    string: UIApplication.openSettingsURLString
                ) else {
                    return
                }
                UIApplication.shared.open(settingsURL)
            }
            Button("취소", role: .cancel) {}
        } message: {
            Text("앱 내부 알림을 켜려면 iPhone 설정에서 설탕묘의 알림 권한을 허용해야 합니다.")
        }
    }

    private func notificationBinding(
        for keyPath: ReferenceWritableKeyPath<MyPageNotificationSettingViewModel, Bool>,
        type: NotificationSettingType
    ) -> Binding<Bool> {
        Binding(
            get: {
                viewModel[keyPath: keyPath]
            },
            set: { newValue in
                guard viewModel.isSystemNotificationAuthorized else {
                    if newValue {
                        viewModel.showsSystemPermissionAlert = true
                    }
                    return
                }

                let previousValue = viewModel[keyPath: keyPath]
                guard previousValue != newValue else { return }

                viewModel[keyPath: keyPath] = newValue

                Task {
                    await viewModel.updateSetting(
                        type: type,
                        isEnabled: newValue,
                        previousValue: previousValue,
                        keyPath: keyPath
                    )
                }
            }
        )
    }
}

// MARK: - 토글 ui 스타일
struct AlarmToggleRow: View {
    
    let title: String
    @Binding var isOn: Bool
    var isDisabled = false
    
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
                            .disabled(isDisabled)
                    }
                }
                .frame(height: 43)
                .padding(.top, 32)
                .padding(.bottom,10)
            }
        }
    }
}

@MainActor
final class MyPageNotificationSettingViewModel: ObservableObject {
    @Published var insulinAlarm = false
    @Published var bloodSugarAlarm = false
    @Published var mealAlarm = false
    @Published var weeklyReportAlarm = false
    @Published var isSystemNotificationAuthorized = false
    @Published var showsSystemPermissionAlert = false
    @Published var errorMessage: String?
    @Published private var updatingTypes: Set<NotificationSettingType> = []

    func loadSettings() async {
        errorMessage = nil

        let settings = await UNUserNotificationCenter.current().notificationSettings()
        isSystemNotificationAuthorized = Self.isAuthorized(
            settings.authorizationStatus
        )

        guard isSystemNotificationAuthorized else {
            turnOffAllToggles()
            await synchronizeSystemDisabledState()
            return
        }

        do {
            let response: NotificationSettingsResponse = try await APIClient.request(
                path: UserEndpoint.userNotificationCheck.path,
                method: UserEndpoint.userNotificationCheck.method
            )

            insulinAlarm = response.insulinNotificationEnabled
            bloodSugarAlarm = response.bloodSugarNotificationEnabled
            mealAlarm = response.mealNotificationEnabled
            weeklyReportAlarm = response.weeklyReportNotificationEnabled
        } catch {
            errorMessage = "알림 설정을 불러오지 못했어요."
            print("❌ 알림 설정 조회 실패:", error)
        }
    }

    func isUpdating(_ type: NotificationSettingType) -> Bool {
        updatingTypes.contains(type)
    }

    func updateSetting(
        type: NotificationSettingType,
        isEnabled: Bool,
        previousValue: Bool,
        keyPath: ReferenceWritableKeyPath<MyPageNotificationSettingViewModel, Bool>
    ) async {
        guard !updatingTypes.contains(type) else { return }

        errorMessage = nil
        updatingTypes.insert(type)
        defer {
            updatingTypes.remove(type)
        }

        do {
            let response: MessageResponseDTO = try await APIClient.requestWithBody(
                path: UserEndpoint.userNotificationEdit(type: type).path,
                method: UserEndpoint.userNotificationEdit(type: type).method,
                body: UpdateNotificationRequest(isEnabled: isEnabled)
            )
            print("✅ \(type.rawValue) 알림 설정 변경 완료:", response.message)
        } catch {
            self[keyPath: keyPath] = previousValue
            errorMessage = "알림 설정을 변경하지 못했어요."
            print("❌ \(type.rawValue) 알림 설정 변경 실패:", error)
        }
    }

    private func synchronizeSystemDisabledState() async {
        do {
            try await APIClient.requestWithoutResponse(
                path: UserEndpoint.userNotificationAllEdit.path,
                method: UserEndpoint.userNotificationAllEdit.method,
                body: UpdateAllNotificationRequest(notificationEnabled: false)
            )
            print("✅ 시스템 권한 비활성 상태를 서버에 반영했습니다.")
        } catch {
            errorMessage = "시스템 알림 상태를 서버에 반영하지 못했어요."
            print("❌ 시스템 알림 상태 동기화 실패:", error)
        }
    }

    private func turnOffAllToggles() {
        insulinAlarm = false
        bloodSugarAlarm = false
        mealAlarm = false
        weeklyReportAlarm = false
    }

    private static func isAuthorized(_ status: UNAuthorizationStatus) -> Bool {
        switch status {
        case .authorized, .provisional, .ephemeral:
            return true
        case .denied, .notDetermined:
            return false
        @unknown default:
            return false
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

//#Preview {
//    @State var previewPath = NavigationPath()
//    MyPageNotificationSettingView(path: .constant(previewPath))
//}
