//
//  OnboardingDataStore.swift
//  sugarcat
//
//  Created by 野菜サンド on 6/5/26.
//


import Foundation
import Combine

class OnboardingDataStore: ObservableObject {
    
    @Published var isLoading: Bool = false
    
    // MARK: - 고양이 기본 정보
    @Published var name: String = ""
    @Published var birthDate: Date = Date()
    @Published var isBirthDateUnknown: Bool = false
    @Published var diagnosedDate: Date = Date()
    @Published var isDiagnosedDateUnknown: Bool = false
    
    // MARK: - 스케줄 설정 데이터
    @Published var mealCount: Int = 1
    @Published var mealTimes: [Date?] = Array(repeating: nil, count: 4)
    
    @Published var bloodSugarCount: Int = 1
    @Published var bloodSugarTimes: [Date?] = Array(repeating: nil, count: 8)
    
    @Published var insulinCount: Int = 1
    @Published var insulinTimes: [Date?] = Array(repeating: nil, count: 3)
    
    // MARK: - API 전송을 위한 데이터 변환 
    func buildRequestDTO() -> CreateCatRequestDTO {
        return CreateCatRequestDTO(
            cat: CatInfo(
                name: name,
                birthDate: isBirthDateUnknown ? nil : DateStringFormatter.dateString(from: birthDate),
                diagnosedDate: DateStringFormatter.dateString(from: diagnosedDate),
                mealCount: mealCount,
                bloodSugarCount: bloodSugarCount,
                insulinCount: insulinCount
            ),
            meal: scheduleGroup(from: mealTimes, count: mealCount),
            bloodSugar: scheduleGroup(from: bloodSugarTimes, count: bloodSugarCount),
            insulin: scheduleGroup(from: insulinTimes, count: insulinCount)
        )
    }
    
    /// Date 배열을 서버 규격의 ScheduleGroup으로 변환하는 헬퍼
    private func scheduleGroup(from times: [Date?], count: Int) -> ScheduleGroup {
        let schedules = (0..<count).map { i in
           
            let timeStr = (i < times.count && times[i] != nil)
                ? DateStringFormatter.timeString(from: times[i]!)
                : nil
            
            return Schedule(sequence: i + 1, time: timeStr)
        }
        return ScheduleGroup(schedules: schedules)
    }
}
