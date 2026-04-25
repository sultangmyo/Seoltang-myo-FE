//
//  BloodSugarRecordItem.swift
//  sugarcat
//
//  Created by 서세린 on 4/25/26.
//

import Foundation


struct BloodSugarRecordItem: Identifiable {
    
    // sequence를 고유 식별자로 사용
    var id: Int { sequence }
    
    // 몇 번째 혈당 기록인지
    let sequence: Int
    
    // 혈당 기록 시간
    let recordTime: String?
    
    // 혈당 수치
    let sugarValue: Int?
    
    // 백엔드가 계산해서 내려주는 혈당 상태
    let sugarStatus: SugarStatus?
    
    // 해당 sequence에 혈당 기록이 있는지 여부
    var hasRecord: Bool {
        sugarValue != nil
    }
    
    // 기록이 없을 때 버튼에 보여줄 문구
    var emptyTitleText: String {
        "\(sequence)번째 기록을 시작하세요"
    }
}
