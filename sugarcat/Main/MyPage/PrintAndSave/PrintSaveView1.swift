//
//  PrintSaveView1.swift
//  sugarcat
//
//  Created by 서세린 on 5/6/26.
//

import SwiftUI

struct PrintSaveView1: View {
    @Binding var path: NavigationPath
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var isMonthly = true

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            NavigationIncludeBackView(title: "인쇄 및 저장")
            
            headerSection
            
            datePickerSection
            
            infoSection
            
            CheckboxView(isChecked: $isMonthly)
                .padding(.horizontal)
            
            Spacer()
            
            Button("PDF 미리보기") {
                Task {
                    do {
                        // 데이터 조회
                        let fetchedRecords = try await fetchRecords(start: startDate, end: endDate)
                        
                        // 데이터 조회 성공 시 이동 (데이터 전달)
                        await MainActor.run {
                            path.append(MyPageRoute.pdfPreview(catName: "나비", records: fetchedRecords))
                        }
                    } catch {
                        print("데이터 조회 실패: \(error)")
                        
                    }
                }
            }
            .buttonStyle(OnboardingButtonStyle(isValid: true, isLoading: false))
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.white.ignoresSafeArea())
    }
    
    // MARK: - Logic
//    private func fetchRecords(start: Date, end: Date) async throws -> [CatRecordRow] {
//        let startStr = DateStringFormatter.dateString(from: start)
//        let endStr = DateStringFormatter.dateString(from: end)
//     
//        let endpoint = CatEndpoint.catPDFCheck(startDate: startStr, endDate: endStr)
//        
//        let records: [CatRecordRow] = try await APIClient.request(
//            path: endpoint.path,
//            method: endpoint.method
//        )
//        
//        return records
//    }
    private func fetchRecords(start: Date, end: Date) async throws -> [CatRecordRow] {
        let startStr = DateStringFormatter.dateString(from: start)
        let endStr = DateStringFormatter.dateString(from: end)

        let endpoint = CatEndpoint.catPDFCheck(
            startDate: startStr,
            endDate: endStr
        )

        let response: CatPDFResponseDTO = try await APIClient.request(
            path: endpoint.path,
            method: endpoint.method
        )

        return response.rows ?? []
    }
    
    // MARK: - Subviews
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("PDF로 기록을").mainTitleB()
            Text("문서화 하세요").mainTitleB()
            Text("조회할 기록의 날짜를 선택해 주세요.")
                .caption2R()
                .foregroundColor(.gray)
                .padding(.top, 4)
        }
        .padding(.horizontal)
    }
    
    private var datePickerSection: some View {
        VStack(spacing: 15) {
            DatePickerRow(title: "시작 날짜", selection: $startDate)
            Divider()
            DatePickerRow(title: "종료 날짜", selection: $endDate)
        }
        .padding()
        .padding(.horizontal)
    }
    
    private var infoSection: some View {
        Text("pdf 페이지 분할 여부를 선택해 주세요.")
            .caption2R()
            .foregroundColor(.gray)
            .padding(.leading, 20)
    }
}

// 날짜 선택 행 컴포넌트
struct DatePickerRow: View {
    let title: String
    @Binding var selection: Date
    
    var body: some View {
        HStack {
            Text(title).body1M()
            Spacer()
            DatePicker("", selection: $selection, displayedComponents: .date)
                .labelsHidden()
                .frame(width: 120)
        }
    }
}

// 체크박스 컴포넌트
struct CheckboxView: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: { isChecked.toggle() }) {
            HStack(spacing: 12) {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isChecked ? Color("primary0") : Color("gray1"))
                    .font(.system(size: 22))
                
                Text("월별로 나누어 정리된 pdf를 받을게요.")
                    .caption2R()
                    .foregroundColor(.black)
            }
        }
    }
}

#Preview {
    struct PreviewContainer: View {
        @State private var path = NavigationPath()
        var body: some View {
            PrintSaveView1(path: $path)
        }
    }
    return PreviewContainer()
}
