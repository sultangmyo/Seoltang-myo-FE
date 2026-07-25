//
//  WidgetUpdater.swift
//  sugarcat
//
//  Created by 서세린 on 5/17/26.
//

import Foundation
import WidgetKit

// MARK: - 공통 WidgetUpdater
// Mock / Real 모두 최종적으로 이 함수를 호출해서
// DTO → Mapper → Calculator → 저장 → Widget Reload 흐름을 처리함
enum WidgetUpdater {
    
    static func updateNextCareWidget(
        insulinSchedule: CatCareInsulinFetchResponseDTO,
        bloodSugarSchedule: CatCareBloodSugarFetchResponseDTO,
        mealSchedule: CatCareMealFetchResponseDTO,
        insulinRecords: InsulinFetchResponseDTO,
        bloodSugarRecords: BloodSugarFetchResponseDTO,
        mealRecords: MealFetchResponseDTO
    ) {
        
        let schedules = NextCareMapper.makeSchedules(
            insulin: insulinSchedule,
            bloodSugar: bloodSugarSchedule,
            meal: mealSchedule
        )
        
        let completedToday = NextCareMapper.makeCompletedToday(
            insulin: insulinRecords,
            bloodSugar: bloodSugarRecords,
            meal: mealRecords
        )
        
//        let widgetData = NextCareCalculator.calculate(
//            schedules: schedules,
//            completedToday: completedToday
//        )
//        
//        NextCareWidgetStore.save(widgetData)
//        
//        WidgetCenter.shared.reloadTimelines(ofKind: "widget")
        
        let rawData = NextCareWidgetRawData(
            schedules: schedules,
            completedToday: completedToday,
            savedDateString: DateStringFormatter.dateString(from: Date())
        )

        NextCareWidgetStore.save(rawData)

        WidgetCenter.shared.reloadTimelines(ofKind: "widget")
    }
}

// MARK: - 목업 위젯 업데이터 : 추후에 endpoint 있는 로직으로 변경 예정
enum MockWidgetUpdater {
    
    static func updateNextCareWidget() {
        
        let insulinSchedule = CatCareInsulinFetchResponseDTO(
            count: 2,
            schedules: [
                CareScheduleDTO(sequence: 1, time: "08:00"),
                CareScheduleDTO(sequence: 2, time: "23:00")
            ]
        )
        
        let bloodSugarSchedule = CatCareBloodSugarFetchResponseDTO(
            count: 3,
            schedules: [
                CareScheduleDTO(sequence: 1, time: "08:00"),
                CareScheduleDTO(sequence: 2, time: "23:00")
            ]
        )
        
        let mealSchedule = CatCareMealFetchResponseDTO(
            count: 3,
            schedules: [
                CareScheduleDTO(sequence: 1, time: "08:00"),
                CareScheduleDTO(sequence: 2, time: "23:00")
            ]
        )
        
        let insulinRecords = InsulinFetchResponseDTO(
            records: [
                InsulinRecordDTO(sequence: 1, isInjected: true, nickname: "희재"),
                InsulinRecordDTO(sequence: 2, isInjected: true, nickname: "희재")
            ]
        )
        
        // 혈당 1, 2회차 모두 완료
        let bloodSugarRecords = BloodSugarFetchResponseDTO(
            records: [
                BloodSugarRecordDTO(
                    nickname: "희재",
                    recordTime: "08:03:22",
                    sequence: 1,
                    sugarValue: 180,
                    sugarStatus: .high
                ),
                
                BloodSugarRecordDTO(
                    nickname: "희재",
                    recordTime: "23:03:22",
                    sequence: 2,
                    sugarValue: 100,
                    sugarStatus: .normal
                )
            ]
        )
        
        // 식사 1, 2회차 모두 완료
        let mealRecords = MealFetchResponseDTO(
            records: [
                MealRecordDTO(
                    sequence: 1,
                    recordTime: "08:10",
                    mealStatus: .full,
                    nickname: "희재"
                ),
                
                MealRecordDTO(
                    sequence: 2,
                    recordTime: "23:10",
                    mealStatus: .partial,
                    nickname: "희재"
                )
            ]
        )
        
        WidgetUpdater.updateNextCareWidget(
            insulinSchedule: insulinSchedule,
            bloodSugarSchedule: bloodSugarSchedule,
            mealSchedule: mealSchedule,
            insulinRecords: insulinRecords,
            bloodSugarRecords: bloodSugarRecords,
            mealRecords: mealRecords
        )
    }
}

// MARK: - 실제로 사용할 widgetupdater


// 실제 서버 데이터를 가져와 위젯 데이터를 갱신하는 객체
enum RealWidgetUpdater {
    
    // MARK: - 위젯 갱신 시작 함수
    
    static func refresh() async {
        
        do {
            
            // 오늘 날짜 문자열 생성
            // ex: "2026-05-16"
            let today = DateStringFormatter.dateString(
                from: Date()
            )
            
            // MARK: 스케줄 조회
            
            // 인슐린 스케줄 조회
            let insulinSchedule: CatCareInsulinFetchResponseDTO =
            try await request(
                path: CatCareEndpoint.insulinRecordCheck.path,
                method: CatCareEndpoint.insulinRecordCheck.method
            )
            
            // 혈당 체크 스케줄 조회
            let bloodSugarSchedule: CatCareBloodSugarFetchResponseDTO =
            try await request(
                path: CatCareEndpoint.bloodsugarRecordsCheck.path,
                method: CatCareEndpoint.bloodsugarRecordsCheck.method
            )
            
            // 식사 스케줄 조회
            let mealSchedule: CatCareMealFetchResponseDTO =
            try await request(
                path: CatCareEndpoint.mealRecordCheck.path,
                method: CatCareEndpoint.mealRecordCheck.method
            )
            
            // MARK: 오늘 기록 조회
            
            // 오늘 인슐린 기록 조회
            let insulinRecords: InsulinFetchResponseDTO =
            try await request(
                path: InsulinEndpoint.fetchInsulinRecords(
                    date: today
                ).path,
                method: InsulinEndpoint.fetchInsulinRecords(
                    date: today
                ).method
            )
            
            // 오늘 혈당 기록 조회
            let bloodSugarRecords: BloodSugarFetchResponseDTO =
            try await request(
                path: BloodSugarEndpoint.fetchBloodSugarRecords(
                    date: today
                ).path,
                method: BloodSugarEndpoint.fetchBloodSugarRecords(
                    date: today
                ).method
            )
            
            // 오늘 식사 기록 조회
            let mealRecords: MealFetchResponseDTO =
            try await request(
                path: MealEndpoint.fetchMealRecords(
                    date: today
                ).path,
                method: MealEndpoint.fetchMealRecords(
                    date: today
                ).method
            )
            
            // MARK: 위젯 데이터 갱신
            
            // DTO → Mapper → Calculator → 저장 → Widget Reload
            WidgetUpdater.updateNextCareWidget(
                insulinSchedule: insulinSchedule,
                bloodSugarSchedule: bloodSugarSchedule,
                mealSchedule: mealSchedule,
                insulinRecords: insulinRecords,
                bloodSugarRecords: bloodSugarRecords,
                mealRecords: mealRecords
            )
            
        } catch {
            
            // 네트워크 또는 decode 실패
            print("❌ 위젯 갱신 실패:", error)
        }
    }
}

// MARK: - Network

private extension RealWidgetUpdater {
    
    // 공통 GET 요청 함수
    static func request<T: Decodable>(
        path: String,
        method: HTTPMethod
    ) async throws -> T {
        try await APIClient.request(
            path: path,
            method: method
        )
    }
}

// 추후에는 이코드를 활용해서 진짜 위젯업데이터를 사용합니다.
// Task {
//await RealWidgetUpdater.refresh()
//}
