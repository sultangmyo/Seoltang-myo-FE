//
//  Catcareinfo.swift
//  sugarcat
//
//  Created by 서세린 on 4/8/26.
//
import Foundation

// MARK: - 공통 (스케줄 항목, 설정 항목)
struct CareScheduleDTO: Codable {
    let sequence: Int    // 회차
    let time: String     // 시간 (ex: 08:00)
}

struct CareSettingDTO: Codable {
    let count: Int                      // 횟수
    let schedules: [CareScheduleDTO]    // 시간 목록 (빈 배열 가능)
}

// MARK: - ONBOARDING CREATE (POST 요청)
struct CatCareSettingOnboardingRequestDTO: Codable {
    let meal: CareSettingDTO         // 식사 설정
    let bloodSugar: CareSettingDTO   // 혈당 체크 설정
    let insulin: CareSettingDTO      // 인슐린 투약 설정
}

struct CatCareSettingOnboardingResponseDTO: Codable {
    let message: String // "고양이 관리 정보가 저장되었습니다."
}

// MARK: - FETCH (GET 요청)
// 식사 / 혈당 / 인슐린 조회 응답 구조가 동일해서 공통 DTO 사용
typealias CatCareMealFetchResponseDTO       = CareSettingDTO  // 식사 정보 조회
typealias CatCareBloodSugarFetchResponseDTO = CareSettingDTO  // 혈당 체크 정보 조회
typealias CatCareInsulinFetchResponseDTO    = CareSettingDTO  // 인슐린 정보 조회

// MARK: - UPDATE (PATCH 요청)
// 식사 / 혈당 / 인슐린 수정 요청 구조도 동일해서 공통 DTO 사용
typealias CatCareMealUpdateRequestDTO       = CareSettingDTO  // 식사 수정
typealias CatCareBloodSugarUpdateRequestDTO = CareSettingDTO  // 혈당 체크 수정
typealias CatCareInsulinUpdateRequestDTO    = CareSettingDTO  // 인슐린 수정

struct CatCareMealUpdateResponseDTO: Codable {
    let message: String // "식사 관리 설정이 수정되었습니다."
}

struct CatCareBloodSugarUpdateResponseDTO: Codable {
    let message: String // "혈당 체크 설정이 수정되었습니다."
}

struct CatCareInsulinUpdateResponseDTO: Codable {
    let message: String // "인슐린 관리 설정이 수정되었습니다."
}
