//
//  CatSetup.swift
//  sugarcat
//
//  Created by 野菜サンド on 4/22/26.
//

//고양이 분기처리 뷰
import SwiftUI


struct CatSetupView: View {
    
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 타이틀
            VStack(alignment: .leading, spacing: 4) {
                (Text("함께할 고양이")
                    .foregroundColor(Color("primary0")) +
                 Text("를"))
                    .mainTitleB()
                    .foregroundColor(Color("textbg1"))
                Text("알려주세요")
                    .mainTitleB()
                    .foregroundColor(Color("textbg1"))
            }
            .padding(.top, 70)
            .padding(.horizontal, 16)

            // 새로운 고양이 등록하기
            OnboardingOptionCard(
                title: "새로운 고양이 등록하기",
                subtitle: "우리 집 아이 정보 만들기 >",
                icon: "list.clipboard"
            ){ path.append(OnboardingPage.catProfile)  //신규 등록
                        }
            
            // 초대받은 고양이 합류하기
            OnboardingOptionCard(
                title: "초대받은 고양이 합류하기",
                subtitle: "동료 집사가 이미 등록했다면? >",
                icon: "person.2"
            ){
               path.append(OnboardingPage.catInvite)   // 초대 합류
            }

            Spacer()
        }
        .background(Color.white)
    }
}

// 카드 컴포넌트
struct OnboardingOptionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                //상단영역
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .subTitle1B()
                            .foregroundColor(Color("textbg1"))
                        Text(subtitle)
                            .caption2R()
                            .foregroundColor(Color("textbg1"))
                    }
                    Spacer()
                }
                
                Spacer()
                
                //하단 영역
                HStack {
                    Spacer()
                    Image(systemName: icon)
                        .font(.system(size: 53))
                        .foregroundColor(Color("gray2"))
                }
            }
            .padding(24)
            .frame(maxWidth: .infinity)
            .frame(height: 193) //세로 길이 고정
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color("gray2"), lineWidth: 1)
            )
        }
        .padding(.horizontal, 18)
        .padding(.top, 20)
    }
}
#Preview {
    CatSetupView(path: .constant(NavigationPath()))
}
