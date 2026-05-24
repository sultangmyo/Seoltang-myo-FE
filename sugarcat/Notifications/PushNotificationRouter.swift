//
//  PushNotificationRouter.swift
//  sugarcat
//
//  Created by 서세린 on 5/24/26.
//

import Foundation
import Combine

// APNs 알림을 눌렀을 때 이동해야 할 화면 정보를
// SwiftUI 화면 쪽으로 전달하기 위한 Router
@MainActor
final class PushNotificationRouter: ObservableObject {
    
    // 앱 전체에서 하나만 사용하는 공유 인스턴스
    static let shared = PushNotificationRouter()
    
    // 알림을 눌렀을 때 이동해야 할 목적지
    // RootView 또는 MainTabView가 이 값을 감지해서 실제 화면 이동을 처리함
    @Published var pendingRoute: PushNotificationRoute?
    
    // 외부에서 새 인스턴스를 만들지 못하게 막음
    private init() {}
    
    // AppDelegate에서 알림 route를 전달할 때 호출
    func handle(_ route: PushNotificationRoute) {
        pendingRoute = route
    }
    
    // 화면 이동 처리가 끝난 뒤 route를 비움
    // 같은 알림 이동이 반복 실행되지 않도록 하기 위해 필요
    func clear() {
        pendingRoute = nil
    }
}
