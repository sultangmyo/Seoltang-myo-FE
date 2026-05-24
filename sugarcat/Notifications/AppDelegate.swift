//
//  AppDelegate.swift
//  sugarcat
//
//  Created by 서세린 on 5/9/26.
//

import UIKit
import UserNotifications


//해당 파일은 APNs관련 함수를 swiftui에서 사용하기 위해서 사용합니다.
// APNs 콜백을 받을 수 있게 합니다.
// APNs 관련함수: didRegisterForRemoteNotificationsWithDeviceToken,didFailToRegisterForRemoteNotificationsWithError
final class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
// MARK: - 알림 탭 처리 및 foreground 알림 표시 영역
    
    //didFinishLaunching: foreground알림과 앱 탭 처리를 위해 앱이 처음 시작할 때 함수를 호출하게 합니다."
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        UNUserNotificationCenter.current().delegate = self
        
        // 이미 알림 권한이 허용된 사용자라면 앱 실행 시 deviceToken을 다시 받아 서버에 upsert하도록 함
        refreshDeviceTokenIfAuthorized()

        return true
    }
    
    //foreground 알림표시 함수 추가(앱이 켜져 있는 상태에서도 알림이 오게 함.)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {

        completionHandler([.banner, .sound, .badge])
    }
    
    //알립 탭 처리함수(알림 탭 시 payload 파싱 후 route 전달)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler:
        @escaping () -> Void
    ) {

        // APNs payload 꺼내기
        let userInfo = response.notification
            .request
            .content
            .userInfo

        // payload 모델로 변환

        if let payload = PushNotificationPayload(userInfo: userInfo) {

            // 디버깅용 로그
            print("알림 타입:", payload.notificationType)
            print("날짜:", payload.targetDate ?? "없음")
            print("sequence:", payload.sequence ?? -1)

            // payload를 앱 내부 이동 경로로 변환
            let route = payload.route
            // 디버깅용 로그
            print("알림 이동 경로:", route)

            // SwiftUI 화면 쪽으로 route 전달
            Task { @MainActor in
                PushNotificationRouter.shared.handle(route)
            }
        }

        //알림처리 완료.
        completionHandler()
    }

// MARK: - APNs deviceToken 받는 영역
    // APNs 등록 요청 함수
    // 알림 권한 허용 후 호출하면 APNs deviceToken을 받을 수 있음
    func registerForRemoteNotifications() {
        DispatchQueue.main.async {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    // APNs 등록 성공 시 deviceToken 받아지고, 해당 토큰을 문자열로 변경하는 함수(백엔드로 보내기 위해 필요)
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {

        // Data 타입 token → 문자열 변환
        let token = deviceToken.map {
            String(format: "%02.2hhx", $0)
        }.joined()

        print("✅ APNs deviceToken:")
        print(token)
        
        // 서버에 deviceToken 등록/갱신 요청
        Task {
            await NotificationDeviceTokenService.registerDeviceToken(token)
        }
    }
    
    // APNs 등록 실패 시 호출되는 함수
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {

        print("❌ APNs 등록 실패")
        print(error.localizedDescription)
    }
    
    // 앱 실행 시 알림 권한 상태를 확인하고,
    // 이미 알림 권한이 허용된 사용자라면 APNs deviceToken을 다시 요청하는 함수
    func refreshDeviceTokenIfAuthorized() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            
            // 알림 권한이 허용된 상태일 때만 token 재요청
            guard settings.authorizationStatus == .authorized ||
                  settings.authorizationStatus == .provisional ||
                  settings.authorizationStatus == .ephemeral
            else {
                return
            }
            
            // APNs deviceToken 재요청
            // 성공하면 didRegisterForRemoteNotificationsWithDeviceToken이 다시 호출됨
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

