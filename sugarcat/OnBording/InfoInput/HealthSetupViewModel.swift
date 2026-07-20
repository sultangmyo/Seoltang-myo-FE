
//
//  HealthSetupViewModel.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/14/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class HealthSetupViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    private var store: OnboardingDataStore
    
    init(store: OnboardingDataStore) {
        self.store = store
    }
    
    // 1. 고양이 정보 생성
    func submitAllData() async -> Bool {
        isLoading = true
        let requestBody = store.buildRequestDTO()
        let endpoint = CatEndpoint.catInfoCreate
        
        do {
            let response: MessageResponseDTO = try await APIClient.requestWithBody(
                path: endpoint.path,
                method: endpoint.method,
                body: requestBody
            )
            print("✅ 고양이 정보 생성 완료: \(response.message)")
            isLoading = false
            return true
        } catch {
            print("❌ 고양이 정보 생성 실패: \(error)")
            isLoading = false
            return false
        }
    }
    
    // 2. 온보딩 완료 처리
    func completeOnboarding() async -> Bool {
        do {
            let requestBody = ["onboardingCompleted": true]
            let endpoint = AuthEndpoint.onBoardingCompleted
            
            let response: MessageResponseDTO = try await APIClient.requestWithBody(
                path: endpoint.path,
                method: endpoint.method,
                body: requestBody
            )
            
            print("✅ 온보딩 완료 상태 전송: \(response.message)")
            await RealWidgetUpdater.refresh()
            return true
        } catch {
            print("❌ 온보딩 완료 처리 실패: \(error)")
            return false
        }
    }
    
    // 3. 알림 설정 업데이트
    func updateNotificationSetting(isEnabled: Bool) async -> Bool {
        do {
            let requestBody = UpdateAllNotificationRequest(notificationEnabled: isEnabled)
            let endpoint = UserEndpoint.userNotificationAllEdit
            
            let _: MessageResponseDTO = try await APIClient.requestWithBody(
                path: endpoint.path,
                method: endpoint.method,
                body: requestBody
            )
            print("✅ 알림 설정 전체 업데이트 완료: \(isEnabled)")
            return true
        } catch {
            print("❌ 알림 설정 실패: \(error)")
            return false
        }
    }
}


// MARK: - Private Helpers

private func scheduleGroup(from times: [Date?], count: Int) -> ScheduleGroup {
    // nil인 시간은 아예 Schedule 객체로 만들지 않음
    let validSchedules = (0..<count).compactMap { i -> Schedule? in
        guard i < times.count, let time = times[i] else { return nil }
        let timeStr = DateStringFormatter.timeString(from: time)
        return Schedule(sequence: i + 1, time: timeStr)
    }
    return ScheduleGroup(schedules: validSchedules)
}

