//
//  MealServiceProtocol.swift
//  sugarcat
//
//  Created by 서세린 on 5/2/26.
//

import Foundation

protocol MealServiceProtocol {
    
    // 온보딩에서 설정한 하루 식사 횟수 조회
    func fetchMealSetting() async throws -> CatCareMealFetchResponseDTO
    
    // 선택한 날짜 기준 식사 기록 조회, date 형식: "yyyy-MM-dd"
    func fetchMealRecords(date: String) async throws -> MealFetchResponseDTO
    
    // 식사 정보 생성
    func createMealRecord(_ request: MealCreateRequestDTO) async throws -> MessageResponseDTO
    
    // 식사 정보 수정
    func updateMealRecord(_ request: MealUpdateRequestDTO) async throws -> MessageResponseDTO
}

// MARK: - 목업 서비스 프로토콜 백엔드 생성후 삭제 됩니다.
final class MockMealService: MealServiceProtocol {

    // 온보딩에서 하루 식사 횟수를 3회로 설정했다고 가정
    private var mockSetting = CatCareMealFetchResponseDTO(
        count: 3,
        schedules: []
    )

    // 날짜별 식사 기록 저장소
    // key: "yyyy-MM-dd"
    // value: 해당 날짜의 식사 기록 배열
    private var mockRecordsByDate: [String: [MealRecordDTO]] = [:]

    func fetchMealSetting() async throws -> CatCareMealFetchResponseDTO {
        return mockSetting
    }

    func fetchMealRecords(date: String) async throws -> MealFetchResponseDTO {
        let records = mockRecordsByDate[date] ?? []
        return MealFetchResponseDTO(records: records)

    }

    func createMealRecord(_ request: MealCreateRequestDTO) async throws -> MessageResponseDTO {

        let newRecord = MealRecordDTO(
            sequence: request.sequence,
            recordTime: request.recordTime,
            mealStatus: request.mealStatus,
            nickname: "희재"
        )

        var records = mockRecordsByDate[request.date] ?? []

        // 같은 sequence가 있으면 중복 방지
        records.removeAll { $0.sequence == request.sequence }
        records.append(newRecord)
        records.sort { $0.sequence < $1.sequence }

        mockRecordsByDate[request.date] = records
        return MessageResponseDTO(message: "식사 기록이 저장되었습니다.")

    }

    func updateMealRecord(_ request: MealUpdateRequestDTO) async throws -> MessageResponseDTO {

        let updatedRecord = MealRecordDTO(
            sequence: request.sequence,
            recordTime: request.recordTime,
            mealStatus: request.mealStatus,
            nickname: "희재"
        )

        var records = mockRecordsByDate[request.date] ?? []

        records.removeAll { $0.sequence == request.sequence }
        records.append(updatedRecord)
        records.sort { $0.sequence < $1.sequence }

        mockRecordsByDate[request.date] = records
        return MessageResponseDTO(message: "식사 기록이 수정되었습니다.")
    }
}
