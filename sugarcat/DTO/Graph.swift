//
//  Graph.swift
//  sugarcat
//
//  Created by 서세린 on 4/8/26.
//

import Foundation

// MARK: - Period

enum GraphPeriod: String, Codable {
    case weekly = "WEEKLY"
    case monthly = "MONTHLY"
}

// MARK: - Day Of Week

enum GraphDayOfWeek: String, Codable {
    case mon = "MON"
    case tue = "TUE"
    case wed = "WED"
    case thu = "THU"
    case fri = "FRI"
    case sat = "SAT"
    case sun = "SUN"
}

// MARK: - Weekly Graph Response

struct WeeklyGraphResponseDTO: Codable {
    let period: GraphPeriod
    let startDate: String
    let endDate: String
    let records: [WeeklyGraphRecordDTO]
}

struct WeeklyGraphRecordDTO: Codable {
    let dayOfWeek: GraphDayOfWeek
    let avg: Double?
    let min: Double?
    let max: Double?
    let count: Int
}

// MARK: - Monthly Graph Response

struct MonthlyGraphResponseDTO: Codable {
    let period: GraphPeriod
    let year: Int
    let month: Int
    let startDate: String
    let endDate: String
    let records: [MonthlyGraphRecordDTO]
}

struct MonthlyGraphRecordDTO: Codable {
    let date: String
    let day: Int
    let avg: Double?
    let min: Double?
    let max: Double?
    let count: Int
}
