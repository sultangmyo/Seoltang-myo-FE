//
//  Bloodsugar.swift
//  sugarcat
//
//  Created by 서세린 on 4/8/26.
//
//코딩키 안써서 api 호출부에 convertFromSnakeCase 명시 해야합니다
import Foundation

// MARK: - Enums
enum SugarStatus: String, Codable {
    case low = "LOW"
    case normal = "NORMAL"
    case high = "HIGH"
}

// MARK: - CREATE (POST 요청)
struct BloodSugarCreateRequestDTO: Codable {
    let recordedDate: String   // 혈당 저장 날짜 (ex: 2026-04-08)
    let recordedTime: String   // 혈당 저장 시간 (ex: 18:03:22)
    let sequence: Int          // 혈당 저장 순서
    let sugarValue: Int        // 혈당 수치
}

// Response 201
struct BloodSugarCreateResponseDTO: Codable {
    let id: String                 // 생성된 혈당 ID(UUID)
    let sugarStatus: SugarStatus   // LOW / NORMAL / HIGH
}

// MARK: - FETCH (GET 요청)
struct BloodSugarFetchResponseDTO: Codable {
    let records: [BloodSugarRecordDTO] // 혈당 기록 배열
}

struct BloodSugarRecordDTO: Codable {
    let nickName: String         // 기록한 사람 닉네임
    let recordTime: String       // 혈당 저장 시간
    let sequence: Int            // 혈당 저장 순서
    let sugarValue: Int          // 혈당 수치
    let sugarStatus: SugarStatus // 혈당 상태 (LOW / NORMAL / HIGH)
}

// MARK: - UPDATE (PATCH 요청)

// 나중에 다른 필드 추가를 위해 분리해둠 (BloodSugarCreateRequestDTO와 구조 동일함.)
struct BloodSugarUpdateRequestDTO: Codable {
    let recordedDate: String   // 혈당 저장 날짜
    let recordedTime: String   // 혈당 저장 시간
    let sequence: Int          // 혈당 저장 순서
    let sugarValue: Int        // 혈당 수치
}

// MARK: - DELETE (DELETE 요청)

// DELETE는 query parameter로 sequence/date를 보내고,
// Response 204 no content라 별도 DTO 없음
