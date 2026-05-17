//
//  NextCareMapper.swift
//  sugarcat
//
//  Created by 서세린 on 5/17/26.
//

import Foundation

// API 응답 DTO를 위젯 계산용 데이터로 바꿔주는 Mapper
enum NextCareMapper {
    
    // MARK: - 스케줄 DTO → CareScheduleItem 변환
    
    static func makeSchedules(
        insulin: CatCareInsulinFetchResponseDTO,
        bloodSugar: CatCareBloodSugarFetchResponseDTO,
        meal: CatCareMealFetchResponseDTO
    ) -> [CareScheduleItem] {
        
        let insulinItems = insulin.schedules.map {
            CareScheduleItem(
                type: .insulin,
                sequence: $0.sequence,
                time: $0.time
            )
        }
        
        let bloodSugarItems = bloodSugar.schedules.map {
            CareScheduleItem(
                type: .bloodSugar,
                sequence: $0.sequence,
                time: $0.time
            )
        }
        
        let mealItems = meal.schedules.map {
            CareScheduleItem(
                type: .meal,
                sequence: $0.sequence,
                time: $0.time
            )
        }
        
        return insulinItems + bloodSugarItems + mealItems
    }
    
    // MARK: - 기록 DTO → 완료된 sequence 변환
    
    static func makeCompletedToday(
        insulin: InsulinFetchResponseDTO,
        bloodSugar: BloodSugarFetchResponseDTO,
        meal: MealFetchResponseDTO
    ) -> [WidgetCareType: Set<Int>] {
        
        let completedInsulin = Set(
            insulin.records
                .filter { $0.isInjected }
                .map { $0.sequence }
        )
        
        let completedBloodSugar = Set(
            bloodSugar.records
                .map { $0.sequence }
        )
        
        let completedMeal = Set(
            meal.records
                .map { $0.sequence }
        )
        
        return [
            .insulin: completedInsulin,
            .bloodSugar: completedBloodSugar,
            .meal: completedMeal
        ]
    }
}
