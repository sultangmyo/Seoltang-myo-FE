//


import SwiftUI

struct PDFPreviewView: View {
    let catName: String
    let records: [CatRecordRow]
    @State private var isShareSheetPresented = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
           
            
            Text("\(catName) 기록일지")
                .mainTitleB()
                .padding(.leading, 20)
                .padding(.bottom, 20)
            
            // 표 컨테이너 
            VStack(spacing: 0) {
                headerRow
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(records, id: \.recordDate) { record in
                            dataRows(for: record)
                        }
                    }
                }
            }
            .border(Color.gray)
            .padding(.horizontal, 20)
            
            Spacer()
            
            Button("PDF 출력") {
                isShareSheetPresented = true
            }
            .buttonStyle(OnboardingButtonStyle(isValid: true, isLoading: false))
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .navigationBarBackButtonHidden(true)
        
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                        Text("뒤로가기")
                    }
                }
            }
            ToolbarItem(placement: .principal) {
                Text("인쇄 및 저장").bold()
            }
        }
        .sheet(isPresented: $isShareSheetPresented) {
            ShareSheet(items: ["PDF 출력"])
        }
    }
    
    // 1. 헤더
    private var headerRow: some View {
        HStack(spacing: 0) {
            Text("날짜").frame(width: 70).bold().caption3R()
            VStack(spacing: 0) {
                Text("혈당").frame(maxWidth: .infinity).border(Color.gray).bold().caption3R()
                HStack(spacing: 0) {
                    Text("시간").frame(width: 50).border(Color.gray).caption3R()
                    Text("혈당").frame(width: 50).border(Color.gray).caption3R()
                }
            }.frame(width: 100)
            VStack(spacing: 0) {
                Text("식사").frame(maxWidth: .infinity).border(Color.gray).bold().caption3R()
                HStack(spacing: 0) {
                    Text("시간").frame(width: 50).border(Color.gray).caption3R()
                    Text("식사").frame(width: 50).border(Color.gray).caption3R()
                }
            }.frame(width: 100)
            Text("인슐린\n누락").frame(width: 70).caption3R().bold()
        }
        .background(Color(.systemGray6))
    }

    // 2. 데이터 행
    private func dataRows(for record: CatRecordRow) -> some View {
        let bs = record.bloodSugars ?? []
        let ms = record.meals ?? []
        let maxCount = max(bs.count, ms.count)
        
        return ForEach(0..<maxCount, id: \.self) { i in
            HStack(spacing: 0) {
                // 날짜 (i == 0 일 때만 표시하고 병합)
                Text(i == 0 ? (record.recordDate ?? "") : "").frame(width: 70, height: 30).border(Color.gray).font(.caption2)
                
                // 혈당
                Text(bs.indices.contains(i) ? (bs[i].recordTime ?? "-") : "-").frame(width: 50, height: 30).border(Color.gray).font(.caption2)
                HStack {
                    Text("\(bs.indices.contains(i) ? "\(bs[i].sugarValue ?? 0)" : "-")")
                    if bs.indices.contains(i), let status = bs[i].sugarStatus {
                        sugarStatusIcon(status)
                    }
                }.frame(width: 50, height: 30).border(Color.gray).font(.caption2)
                
                // 식사
                Text(ms.indices.contains(i) ? (ms[i].recordTime ?? "-") : "-").frame(width: 50, height: 30).border(Color.gray).font(.caption2)
                Text(ms.indices.contains(i) ? (ms[i].mealStatus == "FULL" ? "O" : "△") : "-").frame(width: 50, height: 30).border(Color.gray).font(.caption2)
                
                // 인슐린
                Text(i == 0 && !(record.insulin?.missedIndexes?.isEmpty ?? true) ?
                     "\(record.insulin?.missedIndexes?.count ?? 0)번 누락" : "-").frame(width: 70, height: 30).border(Color.gray).font(.caption2)
            }
        }
    }
    
    private func sugarStatusIcon(_ status: String) -> some View {
        Group {
            if status == "HIGH" { Image(systemName: "square.fill").foregroundColor(.yellow).font(.system(size: 8)) }
            else if status == "LOW" { Image(systemName: "circle.fill").foregroundColor(.blue).font(.system(size: 8)) }
        }
    }
}

// MARK: - Preview
#Preview {
    // 더미 데이터
    let dummyRecords = [
        CatRecordRow(
            recordDate: "2026-05-07",
            bloodSugars: [
                BloodSugarRecord(recordTime: "08:23", sugarValue: 100, sugarStatus: "NORMAL"),
                BloodSugarRecord(recordTime: "09:30", sugarValue: 150, sugarStatus: "HIGH")
            ],
            meals: [
                MealRecord(recordTime: "08:30", mealStatus: "FULL")
            ],
            insulin: InsulinRecord(missedIndexes: [1])
        )
    ]
    
   
    return NavigationStack {
        PDFPreviewView(catName: "나비", records: dummyRecords)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
