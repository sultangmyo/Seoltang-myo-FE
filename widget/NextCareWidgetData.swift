//
//  NextCareWidgetData.swift
//  sugarcat
//
//  Created by 서세린 on 5/17/26.
//

//위젯이 사용하는 데이터 모델
import Foundation

//고양이의 관리 일정에 시간이 있는지 없는지 유무에 따라 분기
enum WidgetCareState: String, Codable {
    case nextCare
    case noSchedule
}

//관리 타입인 인슐린, 혈당, 식사 정의
enum WidgetCareType: String, Codable {
    case insulin
    case bloodSugar
    case meal
    
    var titleText: String {
        switch self {
        case .insulin:
            return "다음 인슐린\n투여까지"
        case .bloodSugar:
            return "다음 혈당\n측정까지"
        case .meal:
            return "다음 식사\n기록까지"
        }
    }
}

//다음 시퀀스가 완료되었는지 아닌지 처리하는 모델
struct NextCareWidgetData: Codable {
    let state: WidgetCareState
    let careType: WidgetCareType?
    let sequence: Int?
    let targetDate: Date?
    
    static let noSchedule = NextCareWidgetData(
        state: .noSchedule,
        careType: nil,
        sequence: nil,
        targetDate: nil
    )
}

// 앱이 위젯에 저장하는 원본 데이터.
// 날짜가 바뀌어도 위젯 Provider가 이 데이터로 다시 calculate()를 실행한다.
struct NextCareWidgetRawData: Codable {
    let schedules: [CareScheduleItem]
    let completedToday: [WidgetCareType: Set<Int>]
    let savedDateString: String

    func completedRecordsForCalculation(
        now: Date = Date()
    ) -> [WidgetCareType: Set<Int>] {
        let todayString = DateStringFormatter.dateString(from: now)

        // 저장 날짜가 오늘이 아니면 어제 완료 기록을 버린다.
        // 그래야 다음 날 00:00 이후에도 어제 완료한 sequence 때문에
        // 오늘의 첫 스케줄이 제외되지 않는다.
        guard savedDateString == todayString else {
            return [:]
        }

        return completedToday
    }
}
