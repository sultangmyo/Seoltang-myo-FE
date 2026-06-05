
//
//  HealthSetupViewModel.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/14/26.
//

import Foundation
import Combine

@MainActor
class HealthSetupViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    
    private var store: OnboardingDataStore
    
    init(store: OnboardingDataStore) {
        self.store = store
    }
    
    /// 모든 온보딩 데이터를 취합하여 서버로 전송
    func submitAllData(catInfo: CatInfo) async -> Bool {
        isLoading = true
        
        let requestBody = CreateCatRequestDTO(
            cat: catInfo,
            meal: scheduleGroup(from: store.mealTimes, count: store.mealCount),
            bloodSugar: scheduleGroup(from: store.bloodSugarTimes, count: store.bloodSugarCount),
            insulin: scheduleGroup(from: store.insulinTimes, count: store.insulinCount)
        )
        
        do {
            
            let response: MessageResponseDTO = try await APIClient.requestWithBody(
                path: "/api/v1/cats/create",
                method: .post,
                body: requestBody
            )
            
            print("✅ 성공 메시지: \(response.message)")
            isLoading = false
            return true
        } catch {
            print("❌ API 전송 실패: \(error)")
            isLoading = false
            return false
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

