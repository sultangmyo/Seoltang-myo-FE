//
//  GraphPoint.swift
//  sugarcat
//
//  Created by 서세린 on 5/26/26.
//

import Foundation

// 일 단위 혈당 그래프에서 사용할 데이터 모델
struct GraphPoint: Identifiable {
    
    // SwiftUI Chart / ForEach에서 사용할 고유 id
    let id = UUID()
    
    // 원본 기록 시간
    // ex: "18:03:22"
    let recordTime: String
    
    // 그래프 x축에 사용할 시간 값(그래프 엔진입니다. 화면에 그릴 좌표값입니다.)
    // ex: 18:30 → 18.5
    let hour: Double
    
    // 실제 혈당 수치
    // ex: 180
    let sugarValue: Int
    
    // 혈당 상태
    // LOW / NORMAL / HIGH
    let sugarStatus: SugarStatus
    
    // 그래프에 실제로 찍을 y값
    // y축은 0~300으로 고정이므로 300 초과 값은 300 위치에 표시
    var chartValue: Int {
        min(sugarValue, 300)
    }
    
    // 실제 혈당 수치가 300을 초과했는지 여부
    // 초과한 경우 그래프 위에서 별도 UI 처리를 하기 위해 사용
    var isOverLimit: Bool {
        sugarValue > 300
    }
}
