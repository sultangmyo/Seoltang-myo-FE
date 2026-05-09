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
    
    //didFinishLaunching: foreground알림과 앱 탭 처리를 위해 앱이 처음 시작할 때 함수를 호출하게 합니다."
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {

        UNUserNotificationCenter.current().delegate = self

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
    
    //알립 탭 처리함수 추가(지금은 print만 구현, 추후에 알림을 누르면 입력화면으로 넘어가게 구현합니다.)
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler:
        @escaping () -> Void
    ) {

        let userInfo = response.notification.request.content.userInfo

        print(userInfo)

        completionHandler()
    }

}

