//
//  UserSessionManager.swift
//  sugarcat
//
//  Created by 서세린 on 4/11/26.
//

import Foundation

// MARK: userid로 사용자 세션을 관리하는 클래스
final class UserSessionManager {
    static let shared = UserSessionManager()
    private init() {}

    private let userIdKey = "userId"

    var userId: String? {
        UserDefaults.standard.string(forKey: userIdKey)
    }
}
