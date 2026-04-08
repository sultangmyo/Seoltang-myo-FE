
//
//  Meal.swift
//  sugarcat
//
//  Created by 수현 on 4/8/26.
//
import Foundation

// MARK: - Enums
enum MealStatus: String, Codable {
    case full = "FULL" //식사 완전히 함
    case partial = "PARTIAL" //식사를 일부만 함
}

// MARK: - CREATE (POST 요청)
struct MealCreateRequestDTO: Codable {
    let date: String //날짜 (ex : 2026-04-08 )  ✅string->DATE 인코더 추가해야함
    let sequence: Int // 몇번째 식사인지 시퀀스
    let recordTime: String //기록 시각 ✅인코더 추가해야함
    let mealStatus: MealStatus //식사 상태 (full / partial)

    enum CodingKeys: String, CodingKey {
        case date, sequence, recordTime, mealStatus
    }
}

struct MealCreateResponseDTO: Codable {
    let message: String // "식사 기록이 저장되었습니다"
}

// MARK: - FETCH (GET 요청)
struct MealFetchResponseDTO: Codable {
    let records: [MealRecordDTO] //식사 기록 배열 MealRecordDTO를 배열로 감쌈
}

struct MealRecordDTO: Codable {
    let sequence: Int
    let recordTime: String //✅string->DATE 인코더 추가해야함
    let mealStatus: MealStatus
    let nickname: String // 기록한 사람 닉네임
}

// MARK: - UPDATE (PATCH 요청)

//나중에 다른 필드 추가를 위해서 분리해둠 (MealCreateRequestDTO와 구조 동일함.)
struct MealUpdateRequestDTO: Codable {
    let date: String //✅string->DATE 인코더 추가해야함
    let sequence: Int
    let recordTime: String //✅string->DATE 인코더 추가해야함
    let mealStatus: MealStatus // String 대신 Enum 사용

    enum CodingKeys: String, CodingKey {
        case date, sequence, recordTime, mealStatus
    }
}

struct MealUpdateResponseDTO: Codable {
    let message: String // "식사 기록이 수정되었습니다"
}
