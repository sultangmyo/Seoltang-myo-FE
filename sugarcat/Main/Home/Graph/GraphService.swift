//
//  GraphService.swift
//  sugarcat
//
//  Created by 서세린 on 6/23/26.
//

import Foundation

protocol GraphServiceProtocol {
    
    // 주간 혈당 그래프 조회
    func fetchWeeklyGraph(
        date: String
    ) async throws -> WeeklyGraphResponseDTO
    
    // 월간 혈당 그래프 조회
    func fetchMonthlyGraph(
        date: String
    ) async throws -> MonthlyGraphResponseDTO
}

// MARK: - Real Service

final class RealGraphService: GraphServiceProtocol {
    
    func fetchWeeklyGraph(
        date: String
    ) async throws -> WeeklyGraphResponseDTO {
        let endpoint = GraphEP.weekly(date: date)
        
        return try await APIClient.request(
            path: endpoint.path,
            method: endpoint.method
        )
    }
    
    func fetchMonthlyGraph(
        date: String
    ) async throws -> MonthlyGraphResponseDTO {
        let endpoint = GraphEP.monthly(date: date)
        
        return try await APIClient.request(
            path: endpoint.path,
            method: endpoint.method
        )
    }
}

// MARK: - Mock Service

final class MockGraphService: GraphServiceProtocol {
    
    func fetchWeeklyGraph(
        date: String
    ) async throws -> WeeklyGraphResponseDTO {
        
        WeeklyGraphResponseDTO(
            period: .weekly,
            startDate: date,
            endDate: "2026-06-14",
            records: [
                WeeklyGraphRecordDTO(
                    dayOfWeek: .mon,
                    avg: 145,
                    min: 90,
                    max: 210,
                    count: 3
                ),
                WeeklyGraphRecordDTO(
                    dayOfWeek: .tue,
                    avg: 130,
                    min: 85,
                    max: 180,
                    count: 2
                ),
                WeeklyGraphRecordDTO(
                    dayOfWeek: .wed,
                    avg: nil,
                    min: nil,
                    max: nil,
                    count: 0
                ),
                WeeklyGraphRecordDTO(
                    dayOfWeek: .thu,
                    avg: 50,
                    min: 95,
                    max: 150,
                    count: 4
                ),
                WeeklyGraphRecordDTO(
                    dayOfWeek: .fri,
                    avg: 160,
                    min: 110,
                    max: 240,
                    count: 5
                ),
                WeeklyGraphRecordDTO(
                    dayOfWeek: .sat,
                    avg: nil,
                    min: nil,
                    max: nil,
                    count: 0
                ),
                WeeklyGraphRecordDTO(
                    dayOfWeek: .sun,
                    avg: 301,
                    min: 90,
                    max: 300,
                    count: 2
                )
            ]
        )
    }
    
    func fetchMonthlyGraph(
        date: String
    ) async throws -> MonthlyGraphResponseDTO {
        
        MonthlyGraphResponseDTO(
            period: .monthly,
            year: 2026,
            month: 6,
            startDate: "2026-06-01",
            endDate: "2026-06-30",
            records: [
                MonthlyGraphRecordDTO(
                    date: "2026-06-01",
                    day: 1,
                    avg: 145,
                    min: 90,
                    max: 210,
                    count: 3
                ),
                MonthlyGraphRecordDTO(
                    date: "2026-06-02",
                    day: 2,
                    avg: 130,
                    min: 85,
                    max: 180,
                    count: 2
                ),
                MonthlyGraphRecordDTO(
                    date: "2026-06-03",
                    day: 3,
                    avg: nil,
                    min: nil,
                    max: nil,
                    count: 0
                ),
                MonthlyGraphRecordDTO(
                    date: "2026-06-10",
                    day: 10,
                    avg: 301,
                    min: 85,
                    max: 180,
                    count: 2
                ),
                MonthlyGraphRecordDTO(
                    date: "2026-06-20",
                    day: 20,
                    avg: 50,
                    min: 50,
                    max: 50,
                    count: 2
                ),
                MonthlyGraphRecordDTO(
                    date: "2026-06-31",
                    day: 31,
                    avg: 100,
                    min: 50,
                    max: 50,
                    count: 2
                )
            ]
        )
    }
}
