//
//  widget.swift
//  widget
//
//  Created by 서세린 on 5/17/26.
//

import WidgetKit
import SwiftUI

// MARK: - Timeline Provider
// 위젯이 어떤 데이터를 언제 보여줄지 결정하는 객체
struct Provider: TimelineProvider {
    
    // 위젯 갤러리나 로딩 중에 보여줄 임시 데이터
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(
            date: Date(),
            widgetData: .noSchedule
        )
    }
    
    // 위젯 미리보기용 데이터
    func getSnapshot(
        in context: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        let entry = SimpleEntry(
            date: Date(),
            widgetData: NextCareWidgetStore.load()
        )
        
        completion(entry)
    }
    
    // 실제 위젯 타임라인 데이터
    func getTimeline(
        in context: Context,
        completion: @escaping (Timeline<SimpleEntry>) -> Void
    ) {
        let entry = SimpleEntry(
            date: Date(),
            widgetData: NextCareWidgetStore.load()
        )
        
        let timeline = Timeline(
            entries: [entry],
            policy: .after(Date().addingTimeInterval(60 * 15))
        )
        
        completion(timeline)
    }
}

// MARK: - Timeline Entry
// 위젯이 화면을 그릴 때 사용하는 데이터 단위
struct SimpleEntry: TimelineEntry {
    let date: Date
    let widgetData: NextCareWidgetData
}

// MARK: - Widget View
// 실제 위젯 UI
struct widgetEntryView: View {
    
    // Provider에서 전달받은 데이터
    var entry: SimpleEntry
    
    var body: some View {
        //        ZStack {
        //            Color.primary0
        //
        //            // 상태에 따라 다른 화면 표시
        //            switch entry.widgetData.state {
        //            case .noSchedule:
        //                noScheduleView
        //
        //            case .nextCare:
        //                nextCareView
        //            }
        //        }
        //        .containerBackground(Color.primary0, for: .widget)
        
        
        Group {
            switch entry.widgetData.state {
            case .noSchedule:
                noScheduleView
                
            case .nextCare:
                nextCareView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .containerBackground(Color.primary0, for: .widget)
        
    }
}

// MARK: - Subviews
private extension widgetEntryView {
    
    // 사용자가 케어 시간을 하나도 등록하지 않았을 때
    var noScheduleView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing:4){
                Image("WidgetIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25)
                
                Text("등록된 일정이 없어요")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.textbg2)
            }
            
            
            Text("케어 시간을\n설정해보세요")
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(.textbg2)
                .multilineTextAlignment(.leading)
            
            Spacer()
        }
        .padding(16)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        
    }
    
    // 다음 케어 일정이 있을 때
    var nextCareView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing:4){
                Image("WidgetIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25)
                
                Text(entry.widgetData.careType?.titleText ?? "")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.textbg2)
                    .multilineTextAlignment(.leading)
            }
            
            
            Text(remainingTimeText(until: entry.widgetData.targetDate))
                .font(.system(size: 27, weight: .bold))
                .foregroundStyle(.textbg2)
                .multilineTextAlignment(.leading)
                .minimumScaleFactor(0.6)
            
            Spacer()
        }
        .padding(16)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )

    }
    
    // targetDate까지 남은 시간을 텍스트로 변환
    // 예: "1시간 30분", "25분"
    func remainingTimeText(until targetDate: Date?) -> String {
        guard let targetDate else {
            return "--"
        }
        
        let seconds = max(0, Int(targetDate.timeIntervalSince(Date())))
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        
        if hours > 0 {
            return "\(hours)시간 \(minutes)분"
        } else {
            return "\(minutes)분"
        }
    }
}

// MARK: - Widget Configuration
struct widget: Widget {
    let kind: String = "widget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()
        ) { entry in
            widgetEntryView(entry: entry)
        }
        .configurationDisplayName("Sugarcat")
        .description("다음 케어 일정을 보여줘요.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

// MARK: - Preview
#Preview("일정 없음", as: .systemSmall) {
    widget()
} timeline: {
    SimpleEntry(
        date: .now,
        widgetData: .noSchedule
    )
}

#Preview("다음 인슐린", as: .systemSmall) {
    widget()
} timeline: {
    SimpleEntry(
        date: .now,
        widgetData: NextCareWidgetData(
            state: .nextCare,
            careType: .insulin,
            sequence: 1,
            targetDate: Date().addingTimeInterval(60 * 90)
        )
    )
}

#Preview("다음 혈당", as: .systemSmall) {
    widget()
} timeline: {
    SimpleEntry(
        date: .now,
        widgetData: NextCareWidgetData(
            state: .nextCare,
            careType: .bloodSugar,
            sequence: 1,
            targetDate: Date().addingTimeInterval(60 * 30)
        )
    )
}

#Preview("10시간 이상", as: .systemSmall) {
    widget()
} timeline: {
    SimpleEntry(
        date: .now,
        widgetData: NextCareWidgetData(
            state: .nextCare,
            careType: .insulin,
            sequence: 1,
            targetDate: Date().addingTimeInterval(60 * 60 * 12)
        )
    )
}
