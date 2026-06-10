
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
    
    
    func submitAllData(path: Binding<NavigationPath>) async {
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
            
            path.wrappedValue.append(OnboardingPage.catInvite)
            
        } catch {
            print("❌ API 전송 실패: \(error)")
            isLoading = false
        }
    }
}

// MARK: - Private Helpers

private func scheduleGroup(from times: [Date?], count: Int) -> ScheduleGroup {
    let schedules = (0..<count).map { i in
        let timeStr = (i < times.count && times[i] != nil)
        ? DateStringFormatter.timeString(from: times[i]!)
        : nil
        
        return Schedule(sequence: i + 1, time: timeStr)
    }
    return ScheduleGroup(schedules: schedules)
}

