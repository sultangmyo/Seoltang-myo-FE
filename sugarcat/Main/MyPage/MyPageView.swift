//
//  HomeView.swift
//  sugarcat
//
//  Created by 서세린 on 4/9/26.
//

import SwiftUI

enum MyPageRoute: Hashable {
    case printSave //인쇄 및 저장
    case notificationSetting // 알림 설정
    case insulinNFsetting1 // 알림설정 -> 인슐린
    case bsNFsetting1 // 알림설정 -> 혈당
    case mealNFsetting1 // 알림설정 -> 식사
    case editCatInfo // 고양이 정보 수정
    case editNickname // 닉네임 변경 페이지
    case inviteCreate // 초대코드 생성뷰
    case pdfPreview(catName: String, records: [CatRecordRow]) //pdf 설정 화면 ->pdf 미리보기 화면
}

struct MyPageView: View {
    //로그아웃 클로저 변수
    let logoutAction: () -> Void
    
    //네비게이션
    @State private var path = NavigationPath()
    @StateObject private var viewModel = MyPageTopProfileSectionViewModel()
    
    var body: some View {
        NavigationStack(path: $path) {
            //네비게이션 헤더
            VStack (spacing: 0){
                VStack(spacing: 0) {
                    NavigationHeaderView(title: "마이페이지")
                    Divider()
                }
                ScrollView {
                    // MARK: - divider 상단 영역
                    VStack(spacing: 0) {
                        if viewModel.isLoading {
                            // 로딩뷰
                            ProgressView()
                                .padding(.vertical, 40)
                        } else {
                            
                            MyPageTopProfileSection(path: $path, viewModel: viewModel)
                        }
                    }
                    
                    //커스텀 divider 적용
                    CustomDividerView()
                    
                    //divider 하단 영역 뷰 구현
                    DividerBottomSection(path: $path, logoutAction: logoutAction)
                        .padding(.bottom, 90)
                }
            }
            .navigationDestination(for: MyPageRoute.self) { route in
                switch route {
                case .printSave:
                    PrintSaveView1(path: $path)
                case .pdfPreview(let catName, let records): // 추가된 부분
                    PDFPreviewView(catName: catName, records: records)
                case .notificationSetting:
                    MyPageNotificationSettingView(path: $path)
                case .insulinNFsetting1:
                    InsulinNFsettingView1()
                case .bsNFsetting1:
                    BSNFsettingView1()
                case .mealNFsetting1:
                    MealNFsettingView1()
                case .editCatInfo:
                    EditCatInfoView(parentViewModel: viewModel, path: $path)
                case .editNickname:
                    EditNicknameView(viewModel: viewModel, path: $path)
                case .inviteCreate:
                        InviteCreateView()
                }
            }
        }
    }
}

//#Preview {
//    NavigationStack {
//        MyPageView(logoutAction: () -> Void)
//    }
//}
