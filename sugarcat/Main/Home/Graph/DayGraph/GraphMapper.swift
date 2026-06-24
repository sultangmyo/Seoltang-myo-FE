//
//  GraphMapper.swift
//  sugarcat
//
//  Created by 서세린 on 5/26/26.
//

import Foundation

// API로 받은 혈당 기록 DTO를 홈 그래프에서 사용할 GraphPoint로 변환하는 Mapper
enum GraphMapper {
    
    // BloodSugarRecordDTO 배열 → GraphPoint 배열 변환
    static func map(_ records: [BloodSugarRecordDTO]) -> [GraphPoint] {
        records
            .compactMap { record in
                makeGraphPoint(from: record)
            }
            // 시간 순서대로 정렬
            .sorted { $0.hour < $1.hour }
    }
    
    // BloodSugarRecordDTO 1개를 GraphPoint 1개로 변환
    private static func makeGraphPoint(
        from record: BloodSugarRecordDTO
    ) -> GraphPoint? {
        
        // recordTime 예시:
        // "18:03:22" 또는 "18:03"
        let parts = record.recordTime.split(separator: ":")
        
        // 최소 hour, minute은 있어야 그래프 x축 위치 계산 가능
        guard
            parts.count >= 2,
            let hour = Double(parts[0]),
            let minute = Double(parts[1])
        else {
            return nil
        }
        
        // Chart x축 계산용 시간값
        // ex: 18:30 → 18.5
        let hourValue = hour + minute / 60
        
        return GraphPoint(
            recordTime: record.recordTime,
            hour: hourValue,
            sugarValue: record.sugarValue,
            sugarStatus: record.sugarStatus
        )
    }
}
