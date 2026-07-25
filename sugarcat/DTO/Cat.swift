//
//  Cat.swift
//  sugarcat
//
//  Created by 서세린 on 4/8/26.
//

import Foundation

// MARK: - 2.2 고양이 생성
// requestdto
struct CreateCatRequestDTO: Codable {
    let cat: CatInfo
    let meal: ScheduleGroup
    let bloodSugar: ScheduleGroup
    let insulin: ScheduleGroup
}

struct CatInfo: Codable {
    let name: String
    let birthDate: String?
    let diagnosedDate: String
    let mealCount: Int
    let bloodSugarCount: Int
    let insulinCount: Int
}

struct ScheduleGroup: Codable {
    let schedules: [Schedule]
}

struct Schedule: Codable {
    let sequence: Int?
    let time: String?
}
// response dto
// MessageResponseDTO를 재활용 합니다


// MARK: - 7.2 고양이 기본정보 조회

//response dto - birthdate는 null 가능성이 있어 optional 처리
struct CatInfoResponseDTO: Codable {
    let name: String
    let birthDate: String?
    let diagnosedDate: String
}

// MARK: - 7.3 고양이 기본정보 수정
// request dto
struct UpdateCatRequestDTO: Codable {
    let name: String
    let birthDate: String?
    let diagnosedDate: String
}
// response dto
// MessageResponseDTO를 재활용 합니다

// MARK: - 고양이 삭제
// MessageResponseDTO를 재활용 합니다


// MARK: - 7.3 초대코드 생성
// response dto
struct GenerateInviteCodeResponseDTO: Codable {
    let inviteCode: String
}

// MARK: - 7.3 초대코드 조회
// response dto
struct GetInviteCodeResponseDTO: Codable {
    let inviteCode: String?
}

// MARK: - 2.4 초대코드 유효성 검증
// response 200
struct ValidateInviteCodeResponseDTO: Codable {
    let catId: String
    let catName: String
}
// reponse 401 - 추후에 error 파일로 리팩토링 될수 있습니다.
struct ErrorResponseDTO: Codable {
    let status: Int
    let code: String
    let message: String
}

// MARK: - 7.4 pdf 데이터 조회
struct CatPDFResponseDTO: Codable {
    let rows: [CatRecordRow]?
}

struct CatRecordRow: Hashable,Codable{
    let recordDate: String?
    let bloodSugars: [BloodSugarRecord]?
    let meals: [MealRecord]?
    let insulin: InsulinRecord?
}

// 혈당 기록 세부 데이터
struct BloodSugarRecord: Hashable,Codable {
    let recordTime: String?
    let sugarValue: Int?
    let sugarStatus: String?
}

// 식사 기록 세부 데이터
struct MealRecord: Hashable,Codable {
    let recordTime: String?
    let mealStatus: String?
}

// 인슐린 기록 세부 데이터
struct InsulinRecord: Hashable,Codable {
    let missedIndexes: [Int]?
}
