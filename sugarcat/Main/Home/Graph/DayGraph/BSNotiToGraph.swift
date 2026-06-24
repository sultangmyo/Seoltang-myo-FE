//
//  BSNotiToGraph.swift
//  sugarcat
//
//  Created by 서세린 on 5/26/26.
//

import Foundation

extension Notification.Name {
    
    // 혈당 기록이 생성/수정/삭제 되었음을 알리는 notification
    static let bloodSugarRecordsDidUpdate =
    Notification.Name("bloodSugarRecordsDidUpdate")
}
