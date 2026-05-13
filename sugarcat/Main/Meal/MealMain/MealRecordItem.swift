//
//  MealRecordItem.swift
//  sugarcat
//
//  Created by 서세린 on 5/2/26.
//

import Foundation

struct MealRecordItem: Identifiable, Hashable {
    var id: Int { sequence }
    
    let sequence: Int
    let recordTime: String?
    let mealStatus: MealStatus?
    
    var hasRecord: Bool {
        mealStatus != nil
    }
    
    var emptyTitleText: String {
        "\(sequence)번째 식사를 기록하세요"
    }
    
    var statusText: String {
        switch mealStatus {
        case .full:
            return "다 먹음"
        case .partial:
            return "덜 먹음"
        case .none:
            return ""
        }
    }
    
    var displayTime: String {
        guard let recordTime else { return "" }
        return DateStringFormatter.displayTime(from: recordTime)
    }
}
