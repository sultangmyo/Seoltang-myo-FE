//
//  NextCareCalculator.swift
//  sugarcat
//
//  Created by 서세린 on 5/17/26.
//

import Foundation

// 위젯 계산에 사용할 스케줄 항목
// API DTO를 직접 쓰지 않고, 위젯 계산용 모델로 한 번 변환해서 사용
struct CareScheduleItem {
    let type: WidgetCareType   // 인슐린 / 혈당 / 식사
    let sequence: Int          // 몇 번째 케어인지
    let time: String           // 케어 시간, 예: "08:00"
}

// 다음 케어 일정을 계산하는 객체
enum NextCareCalculator {
    
    // MARK: - Main Calculate Function
    
    static func calculate(
        schedules: [CareScheduleItem],
        completedToday: [WidgetCareType: Set<Int>],
        now: Date = Date(),
        calendar: Calendar = Calendar(identifier: .gregorian)
    ) -> NextCareWidgetData {
        
        // 등록된 스케줄이 하나도 없으면
        // 위젯에서 "등록된 일정 없음" 상태를 보여줌
        guard !schedules.isEmpty else {
            return .noSchedule
        }
        
        // 오늘 날짜 기준으로 후보 일정 생성
        // 이미 완료한 sequence는 제외
        let todayCandidates = makeCandidates(
            schedules: schedules,
            completedToday: completedToday,
            baseDate: now,
            calendar: calendar
        )
        // 현재 시간 이후의 일정만 남김
        .filter { $0.targetDate >= now }
        
        // 오늘 남은 일정이 있으면
        // 가장 가까운 일정 반환
        if let nextToday = sorted(todayCandidates).first {
            return nextToday.widgetData
        }
        
        // 오늘 남은 일정이 없으면 내일 일정 계산
        guard let tomorrow = calendar.date(
            byAdding: .day,
            value: 1,
            to: now
        ) else {
            return .noSchedule
        }
        
        // 내일은 아직 완료 기록이 없으므로 completedToday는 빈 값으로 전달
        let tomorrowCandidates = makeCandidates(
            schedules: schedules,
            completedToday: [:],
            baseDate: tomorrow,
            calendar: calendar
        )
        
        // 내일 가장 빠른 일정 반환
        return sorted(tomorrowCandidates).first?.widgetData ?? .noSchedule
    }
}

// MARK: - Private Helpers

private extension NextCareCalculator {
    
    // 계산 과정에서만 사용하는 후보 모델
    struct Candidate {
        let type: WidgetCareType
        let sequence: Int
        let targetDate: Date
        
        // 후보를 위젯 저장 데이터 형태로 변환
        var widgetData: NextCareWidgetData {
            NextCareWidgetData(
                state: .nextCare,
                careType: type,
                sequence: sequence,
                targetDate: targetDate
            )
        }
    }
    
    // 스케줄 배열을 실제 Date를 가진 후보 배열로 변환
    static func makeCandidates(
        schedules: [CareScheduleItem],
        completedToday: [WidgetCareType: Set<Int>],
        baseDate: Date,
        calendar: Calendar
    ) -> [Candidate] {
        
        schedules.compactMap { schedule in
            
            // 오늘 이미 완료한 케어라면 후보에서 제외
            if completedToday[schedule.type]?.contains(schedule.sequence) == true {
                return nil
            }
            
            // "08:00" 같은 문자열을 baseDate 기준 Date로 변환
            guard let date = makeDate(
                from: schedule.time,
                baseDate: baseDate,
                calendar: calendar
            ) else {
                return nil
            }
            
            return Candidate(
                type: schedule.type,
                sequence: schedule.sequence,
                targetDate: date
            )
        }
    }
    
    // "HH:mm" 문자열을 Date로 변환
    static func makeDate(
        from timeString: String,
        baseDate: Date,
        calendar: Calendar
    ) -> Date? {
        
        let parts = timeString.split(separator: ":")
        
        guard
            parts.count >= 2,
            let hour = Int(parts[0]),
            let minute = Int(parts[1])
        else {
            return nil
        }
        
        return calendar.date(
            bySettingHour: hour,
            minute: minute,
            second: 0,
            of: baseDate
        )
    }
    
    // 후보들을 정렬
    // 1순위: 시간이 빠른 순
    // 2순위: 시간이 같으면 인슐린 > 혈당 > 식사
    static func sorted(_ candidates: [Candidate]) -> [Candidate] {
        candidates.sorted {
            if $0.targetDate != $1.targetDate {
                return $0.targetDate < $1.targetDate
            }
            
            return priority(of: $0.type) < priority(of: $1.type)
        }
    }
    
    // 같은 시간에 여러 케어가 겹칠 때 우선순위
    static func priority(of type: WidgetCareType) -> Int {
        switch type {
        case .insulin:
            return 0
        case .bloodSugar:
            return 1
        case .meal:
            return 2
        }
    }
}
