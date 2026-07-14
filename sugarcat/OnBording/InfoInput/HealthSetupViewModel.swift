
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
    
    
    func submitAllData() async -> Bool { 
        isLoading = true
        let requestBody = store.buildRequestDTO()
        
        do {
            let response: MessageResponseDTO = try await APIClient.requestWithBody(
                path: "/api/v1/cats",
                method: .post,
                body: requestBody
            )
            print("✅ 성공 메시지: \(response.message)")
            isLoading = false
            return true // 성공 시 true 반환
        } catch {
            print("❌ API 전송 실패: \(error)")
            isLoading = false
            return false // 실패 시 false 반환
        }
    }
    
    //온보딩 완료
    // HealthSetupViewModel.swift 수정
    func completeOnboarding() async -> Bool {
        do {
            let requestBody = ["onboardingCompleted": true]
            
            let response: MessageResponseDTO = try await APIClient.requestWithBody(
                path: AuthEndpoint.onBoardingCompleted.path,
                method: .post,
                body: requestBody
            )
            
            print("✅ 온보딩 완료: \(response.message)")
            
            //위젯 업데이트 함수
            Task {
                await RealWidgetUpdater.refresh()
            }
            
            return true
        } catch {
            print("❌ 온보딩 완료 실패: \(error)")
            return false
        }
    }
    
   
    func updateNotificationSetting(isEnabled: Bool) async -> Bool {
        do {
           
            let requestBody = UpdateAllNotificationRequest(notificationEnabled: isEnabled)
                    
                    
                    let _: MessageResponseDTO = try await APIClient.requestWithBody(
                        path: UserEndpoint.userNotificationAllEdit.path,
                        method: .patch, 
                        body: requestBody
                    )
            print("✅ 알림 설정 업데이트 완료: \(isEnabled)")
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

