//
//  MonthlyGraphMapper.swift
//  sugarcat
//
//  Created by 서세린 on 6/30/26.
//

import Foundation

enum MonthlyGraphMapper {
    
    static func map(
        from response: MonthlyGraphResponseDTO
    ) -> [MonthlyGraphPoint] {
        response.records
            .map { record in
                MonthlyGraphPoint(
                    date: record.date,
                    day: record.day,
                    dayIndex: Double(record.day),
                    avg: record.avg,
                    min: record.min,
                    max: record.max,
                    count: record.count
                )
            }
            .sorted { $0.dayIndex < $1.dayIndex }
    }
}
