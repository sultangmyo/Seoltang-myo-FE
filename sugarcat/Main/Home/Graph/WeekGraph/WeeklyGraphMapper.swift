//
//  WeeklyGraphMapper.swift
//  sugarcat
//
//  Created by 서세린 on 6/23/26.
//

import Foundation

enum WeeklyGraphMapper {
    
    static func map(
        from response: WeeklyGraphResponseDTO
    ) -> [WeeklyGraphPoint] {
        response.records
            .map { record in
                WeeklyGraphPoint(
                    dayOfWeek: record.dayOfWeek,
                    dayIndex: record.dayOfWeek.index,
                    dayLabel: record.dayOfWeek.koreanLabel,
                    avg: record.avg,
                    min: record.min,
                    max: record.max,
                    count: record.count
                )
            }
            .sorted { $0.dayIndex < $1.dayIndex }
    }
}
