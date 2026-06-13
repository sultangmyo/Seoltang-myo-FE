//
//  NotificationSettingViewModel.swift
//  sugarcat
//
//  Created by 野菜サンド on 5/20/26.
//


import Foundation
import Combine

@MainActor
class NotificationSettingViewModel: ObservableObject {
    
    enum NotificationCategory: String {
        case bloodSugar = "blood"
        case insulin = "insulin"
        case meal = "meal"
    }
    
    @Published var existingCount: Int = 3
    @Published var existingTimes: [Date?] = Array(repeating: nil, count: 8)
    @Published var isLoading: Bool = true
    @Published var isSaving: Bool = false
    
    let category: NotificationCategory
    
    init(category: NotificationCategory) {
        self.category = category
    }
    
    // 엔드포인트 매핑
    private var endpoint: CatCareEndpoint {
        switch category {
        case .meal: return .mealRecordCheck
        case .bloodSugar: return .bloodsugarRecordsCheck
        case .insulin: return .insulinRecordCheck
        }
    }
    
    private var editEndpoint: CatCareEndpoint {
        switch category {
        case .meal: return .mealRecordEdit
        case .bloodSugar: return .bloodsugarRecordEdit
        case .insulin: return .insulinRecordEdit
        }
    }
    
    func loadSettingsFromServer() async {
        isLoading = true
        do {
            // CareSettingDTO를 공통으로 사용
            let fetchedData: CareSettingDTO = try await APIClient.request(
                path: endpoint.path,
                method: .get
            )
            
            self.existingCount = fetchedData.count
            let sortedSchedules = fetchedData.schedules.sorted { $0.sequence < $1.sequence }
            
            for i in 0..<min(sortedSchedules.count, existingTimes.count) {
                self.existingTimes[i] = DateParser.parseTime(sortedSchedules[i].time)
            }
        } catch {
            print("❌ 조회 실패: \(error)")
        }
        isLoading = false
    }
    
    func saveDataToBackend(onSuccess: @escaping () -> Void) async {
        isSaving = true
        
        
        let schedules = existingTimes.prefix(existingCount).enumerated().compactMap { (index, date) -> CareScheduleDTO? in
            guard let date = date else { return nil }
            return CareScheduleDTO(sequence: index + 1, time: DateStringFormatter.timeString(from: date))
        }
        
        let requestBody = CareSettingDTO(count: existingCount, schedules: Array(schedules))
        
        do {
           
            let response: MessageResponseDTO = try await APIClient.requestWithBody(
                path: editEndpoint.path,
                method: .patch,
                body: requestBody
            )
            
            print("✅ 서버 응답: \(response.message)")
            
            await MainActor.run {
                onSuccess()
            }
        } catch {
            print("❌ 저장 실패: \(error)")
        }
        isSaving = false
    }
}
