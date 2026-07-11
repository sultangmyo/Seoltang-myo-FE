//
//  MealViewModel.swift
//  sugarcat
//
//  Created by 서세린 on 5/2/26.
//

import Foundation
import Combine

@MainActor
final class MealViewModel: ObservableObject {
    
    @Published var selectedDate: Date = Date()
    @Published var items: [MealRecordItem] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let mealService: MealServiceProtocol
    
    init(mealService: MealServiceProtocol) {
        self.mealService = mealService
    }
    
    func loadRecords() async {
        isLoading = true
        errorMessage = nil
        
        let dateString = DateStringFormatter.dateString(from: selectedDate)
        
        do {
            let setting = try await mealService.fetchMealSetting()
            let response = try await mealService.fetchMealRecords(date: dateString)
            
            items = makeRecordItems(
                settingCount: setting.count,
                records: response.records
            )
            
            isLoading = false
            
        } catch {
            errorMessage = "식사 기록을 불러오지 못했어요."
            isLoading = false
            print("식사 기록 로딩 실패: \(error)")
        }
    }
    
    func changeDate(_ date: Date) async {
        selectedDate = date
        await loadRecords()
    }
    
    func createRecord(
        sequence: Int,
        mealStatus: MealStatus,
        recordedTime: Date
    ) async {
        let dateString = DateStringFormatter.dateString(from: selectedDate)
        let timeString = DateStringFormatter.timeString(from: recordedTime)
        
        let request = MealCreateRequestDTO(
            date: dateString,
            sequence: sequence,
            recordTime: timeString,
            mealStatus: mealStatus
        )
        
        do {
            _ = try await mealService.createMealRecord(request)
            await loadRecords()
            
            //위젯 업데이트 함수
            Task {
                await RealWidgetUpdater.refresh()
            }
            
        } catch {
            errorMessage = "식사 기록 저장에 실패했어요."
            print("식사 기록 저장 실패: \(error)")
        }
    }
    
    func updateRecord(
        sequence: Int,
        mealStatus: MealStatus,
        recordedTime: Date
    ) async {
        let dateString = DateStringFormatter.dateString(from: selectedDate)
        let timeString = DateStringFormatter.timeString(from: recordedTime)
        
        let request = MealUpdateRequestDTO(
            date: dateString,
            sequence: sequence,
            recordTime: timeString,
            mealStatus: mealStatus
        )
        
        do {
            _ = try await mealService.updateMealRecord(request)
            await loadRecords()
        } catch {
            errorMessage = "식사 기록 수정에 실패했어요."
            print("식사 기록 수정 실패: \(error)")
        }
    }
    
    private func makeRecordItems(
        settingCount: Int,
        records: [MealRecordDTO]
    ) -> [MealRecordItem] {
        guard settingCount > 0 else { return [] }
        
        return (1...settingCount).map { sequence in
            let matchedRecord = records.first { $0.sequence == sequence }
            
            return MealRecordItem(
                sequence: sequence,
                recordTime: matchedRecord?.recordTime,
                mealStatus: matchedRecord?.mealStatus
            )
        }
    }
}
