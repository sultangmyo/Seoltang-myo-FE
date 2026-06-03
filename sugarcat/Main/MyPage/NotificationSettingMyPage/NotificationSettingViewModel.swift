//
//  NotificationSettingViewModel.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/20/26.
//


import SwiftUI

@MainActor
class NotificationSettingViewModel: ObservableObject {
    
    @Published var existingCount: Int = 3
    @Published var existingTimes: [Date] = Array(repeating: Date(), count: 8)
    @Published var isLoading: Bool = true
    @Published var isSaving: Bool = false
    
    
    enum NotificationCategory: String {
        case bloodSugar = "blood"
        case insulin = "insulin"
        case meal = "meal"
    }
    
    let category: NotificationCategory
    
    init(category: NotificationCategory) {
        self.category = category
    }
    
    
    func loadSettingsFromServer() async {
        isLoading = true
        do {
            // 임시 주소이므로 수정해야함
            let fetchedData: CreateCatRequestDTO = try await APIClient.request(
                path: "/api/v1/cats/schedules",
                method: .get
            )
            
            // 카테고리에 따라 어떤 카운트와 스케줄을 가져올지 동적 분기
            let schedules: [Schedule]
            switch category {
            case .bloodSugar:
                self.existingCount = fetchedData.cat.bloodSugarCount
                schedules = fetchedData.bloodSugar.schedules
            case .insulin:
                self.existingCount = fetchedData.cat.insulinCount
                schedules = fetchedData.insulin.schedules
            case .meal:
                self.existingCount = fetchedData.cat.mealCount
                schedules = fetchedData.meal.schedules
            }
            
            let sortedSchedules = schedules.sorted { ($0.sequence ?? 0) < ($1.sequence ?? 0) }
            
            for i in 0..<min(sortedSchedules.count, existingTimes.count) {
                if let timeStr = sortedSchedules[i].time {
                    self.existingTimes[i] = DateStringFormatter.date(from: timeStr)
                }
            }
        } catch {
            print("❌ [\(category.rawValue)] 알림 조회 실패:", error)
        }
        isLoading = false
    }
    
    // PATCH 유저 알림 재설정
    func saveDataToBackend(onSuccess: @escaping () -> Void) async {
        isSaving = true
        
        let selectedDates = existingTimes.prefix(existingCount)
        var scheduleList: [Schedule] = []
        
        for (index, date) in selectedDates.enumerated() {
            let timeStr = DateStringFormatter.timeString(from: date)
            let schedule = Schedule(sequence: index + 1, time: timeStr)
            scheduleList.append(schedule)
        }
        
        let requestBody = ScheduleGroup(schedules: scheduleList)
        
        do {
            
            let _: MessageResponseDTO = try await APIClient.requestWithBody(
                path: "/api/v1/users/me/notification?type=\(category.rawValue)",
                method: .patch,
                body: requestBody
            )
            
            print("✅ [\(category.rawValue)] 알림 스케줄 수정 성공")
            onSuccess()
        } catch {
            print("❌ [\(category.rawValue)] 알림 스케줄 수정 실패:", error)
        }
        isSaving = false
    }
}
