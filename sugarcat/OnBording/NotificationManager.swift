//
//  NotificationManager.swift
//  sugarcat
//
//  Created by 野菜サンド on 6/10/26.
//

import UserNotifications
import UIKit
class NotificationManager {
    static func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
            
            
            if granted {
                await MainActor.run {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
            
            return granted
        } catch {
            return false
        }
    }
}
