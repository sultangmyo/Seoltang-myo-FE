import SwiftUI

struct PDFPreviewView: View {
    let catName: String
    let records: [CatRecordRow]
    let isMonthly: Bool
    @State private var isShareSheetPresented = false
    @State private var generatedPDFURL: URL?
    @Environment(\.dismiss) var dismiss

    private let pdfPageWidth: CGFloat = 595
    private let pdfHorizontalPadding: CGFloat = 16

    // PDF 및 화면에서 공통으로 사용할 표 영역
    private func recordTable(records: [CatRecordRow], width: CGFloat) -> some View {
        VStack(spacing: 0) {
            headerRow(width: width)
            ForEach(records, id: \.recordDate) { record in
                dataRows(for: record, width: width)
            }
        }
        .frame(width: width)
        .background(Color.white)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("\(catName) 기록일지")
                .mainTitleB()
                .padding(.horizontal, 16)
                .padding(.bottom, 20)

            GeometryReader { geometry in
                ScrollView {
                    recordTable(records: records, width: geometry.size.width)
                }
            }
            .border(Color.gray)
            .padding(.horizontal, 16)

            Spacer()

            Button("PDF 출력") {
             //pdf generate 에 전달
                let tableWidth = pdfPageWidth - (pdfHorizontalPadding * 2)
                let pages = pdfRecordGroups.map { records in
                    AnyView(recordTable(records: records, width: tableWidth))
                }

                if let url = PDFGenerator.generatePDF(
                    pages: pages,
                    fileName: "\(catName)_기록지"
                ) {
                    self.generatedPDFURL = url
                    self.isShareSheetPresented = true
                }
            }
            .buttonStyle(OnboardingButtonStyle(isValid: true, isLoading: false))
            .padding(.horizontal, 16)
            .padding(.bottom, 10)
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
            if let url = generatedPDFURL {
                ShareSheet(items: [url])
            }
        }
    }

    private var pdfRecordGroups: [[CatRecordRow]] {
        guard isMonthly else {
            return [records]
        }

        let groupedRecords = Dictionary(grouping: records) { record in
            guard let date = record.recordDate, date.count >= 7 else {
                return "unknown"
            }
            return String(date.prefix(7))
        }

        let monthlyGroups = groupedRecords.keys.sorted().compactMap {
            groupedRecords[$0]
        }
        return monthlyGroups.isEmpty ? [[]] : monthlyGroups
    }

    // MARK: - 공통 셀 뷰
    
    private struct TableCell: View {
        let text: String
        var width: CGFloat? = nil
        var height: CGFloat = 40
        var bold: Bool = false
        var expandsWidth: Bool = false
        var content: AnyView? = nil

        var body: some View {
            Group {
                if let content = content {
                    content
                } else {
                    Text(text)
                        .multilineTextAlignment(.center)
                }
            }
            .font(.caption2)
            .fontWeight(bold ? .bold : .regular)
            .frame(width: expandsWidth ? nil : width, height: height)
            .frame(maxWidth: expandsWidth ? .infinity : nil)
            .overlay(Rectangle().stroke(Color.gray, lineWidth: 0.5))
        }
    }

    // MARK: - 표 구성 요소
    private func headerRow(width: CGFloat) -> some View {
        let dateColumnWidth = width * 70 / 340
        let categoryColumnWidth = width * 100 / 340
        let detailColumnWidth = categoryColumnWidth / 2

        return HStack(spacing: 0) {
            TableCell(text: "날짜", width: dateColumnWidth, height: 80, bold: true)

            VStack(spacing: 0) {
                TableCell(text: "혈당", height: 40, bold: true, expandsWidth: true)
                HStack(spacing: 0) {
                    TableCell(text: "시간", width: detailColumnWidth, height: 40)
                    TableCell(text: "혈당", width: detailColumnWidth, height: 40)
                }
            }
            .frame(width: categoryColumnWidth)

            VStack(spacing: 0) {
                TableCell(text: "식사", height: 40, bold: true, expandsWidth: true)
                HStack(spacing: 0) {
                    TableCell(text: "시간", width: detailColumnWidth, height: 40)
                    TableCell(text: "식사", width: detailColumnWidth, height: 40)
                }
            }
            .frame(width: categoryColumnWidth)

            TableCell(text: "인슐린\n누락", width: dateColumnWidth, height: 80, bold: true)
        }
        .background(Color(.systemGray6))
    }

    private func dataRows(for record: CatRecordRow, width: CGFloat) -> some View {
        let bs = record.bloodSugars ?? []
        let ms = record.meals ?? []
        let maxCount = max(bs.count, ms.count)
        let dateColumnWidth = width * 70 / 340
        let detailColumnWidth = width * 50 / 340

        return ForEach(0..<maxCount, id: \.self) { i in
            HStack(spacing: 0) {
                TableCell(
                    text: i == 0 ? (record.recordDate ?? "") : "",
                    width: dateColumnWidth,
                    height: 30
                )

                TableCell(
                    text: bs.indices.contains(i) ? (bs[i].recordTime ?? "-") : "-",
                    width: detailColumnWidth,
                    height: 30
                )

                TableCell(
                    text: "",
                    width: detailColumnWidth,
                    height: 30,
                    content: AnyView(sugarValueView(bs: bs, index: i))
                )

                TableCell(
                    text: ms.indices.contains(i) ? (ms[i].recordTime ?? "-") : "-",
                    width: detailColumnWidth,
                    height: 30
                )

                TableCell(
                    text: ms.indices.contains(i) ? (ms[i].mealStatus == "FULL" ? "O" : "△") : "-",
                    width: detailColumnWidth,
                    height: 30
                )

                TableCell(
                    text: i == 0 && !(record.insulin?.missedIndexes?.isEmpty ?? true)
                        ? "\(record.insulin?.missedIndexes?.count ?? 0)번 누락"
                        : (i == 0 ? "-" : ""),
                    width: dateColumnWidth,
                    height: 30
                )
            }
        }
    }

    //혈당값 + 정상범위 이모지
    private func sugarValueView(bs: [BloodSugarRecord], index i: Int) -> some View {
        HStack(spacing: 2) {
            Text(bs.indices.contains(i) ? "\(bs[i].sugarValue ?? 0)" : "-")
                .font(.caption2)
            if bs.indices.contains(i), let status = bs[i].sugarStatus {
                sugarStatusIcon(status)
            }
        }
    }

    private func sugarStatusIcon(_ status: String) -> some View {
        Group {
            if status == "HIGH" {
                Image(systemName: "square.fill").foregroundColor(.yellow).font(.system(size: 8))
            } else if status == "LOW" {
                Image(systemName: "circle.fill").foregroundColor(.blue).font(.system(size: 8))
            }
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
        PDFPreviewView(catName: "나비", records: dummyRecords, isMonthly: true)
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]
    func makeUIViewController(context: Context) -> UIActivityViewController {
        return UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
