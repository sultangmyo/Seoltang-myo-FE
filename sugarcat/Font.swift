//
//  Font.swift
//  sugarcat
//
//  Created by 서세린 on 4/8/26.
//


import SwiftUI

//모디파이어
struct MainTitleBModifier: ViewModifier {
    @ScaledMetric(relativeTo: .largeTitle) private var fontSize: CGFloat = 34

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .bold, design: .default))
    }
}

struct SubTitle1BModifier: ViewModifier {
    @ScaledMetric(relativeTo: .title) private var fontSize: CGFloat = 24

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .bold, design: .default))
    }
}

struct SubTitle2BModifier: ViewModifier {
    @ScaledMetric(relativeTo: .title2) private var fontSize: CGFloat = 24

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .semibold, design: .default))
    }
}

struct Body1SBModifier: ViewModifier {
    @ScaledMetric(relativeTo: .body) private var fontSize: CGFloat = 20

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .medium, design: .default))
    }
}

struct Body1MModifier: ViewModifier {
    @ScaledMetric(relativeTo: .body) private var fontSize: CGFloat = 20

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .medium, design: .default))
    }
}

struct Body2RModifier: ViewModifier {
    @ScaledMetric(relativeTo: .subheadline) private var fontSize: CGFloat = 18

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .regular, design: .default))
    }
}

struct Caption1SBModifier: ViewModifier {
    @ScaledMetric(relativeTo: .caption) private var fontSize: CGFloat = 16

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .semibold, design: .default))
    }
}

struct Caption2RModifier: ViewModifier {
    @ScaledMetric(relativeTo: .caption) private var fontSize: CGFloat = 16

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .regular, design: .default))
    }
}

struct Caption3RModifier: ViewModifier {
    @ScaledMetric(relativeTo: .caption2) private var fontSize: CGFloat = 13

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .regular, design: .default))
    }
}

struct GraphBarTitleModifier: ViewModifier {
    @ScaledMetric(relativeTo: .subheadline) private var fontSize: CGFloat = 18

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .medium, design: .default))
    }
}

struct Buttontitle1Modifier: ViewModifier {
    @ScaledMetric(relativeTo: .headline) private var fontSize: CGFloat = 20

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .semibold, design: .default))
    }
}

struct Buttontitle2Modifier: ViewModifier {
    @ScaledMetric(relativeTo: .headline) private var fontSize: CGFloat = 20

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .regular, design: .default))
    }
}

struct NumberCaption1Modifier: ViewModifier {
    @ScaledMetric(relativeTo: .largeTitle) private var fontSize: CGFloat = 72

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .bold, design: .default))
    }
}

struct NumberCaption2Modifier: ViewModifier {
    @ScaledMetric(relativeTo: .title) private var fontSize: CGFloat = 48

    func body(content: Content) -> some View {
        content.font(.system(size: fontSize, weight: .medium, design: .default))
    }
}


//익스텐션 사용
extension View {
    func mainTitleB() -> some View {
        modifier(MainTitleBModifier())
    }
    func subTitle1B() -> some View {
        modifier(SubTitle1BModifier())
    }
    func subTitle2B() -> some View {
        modifier(SubTitle2BModifier())
    }
    func body1SB() -> some View {
        modifier(Body1SBModifier())
    }
    func body1M() -> some View {
        modifier(Body1MModifier())
    }
    func body2R() -> some View {
        modifier(Body2RModifier())
    }
    func caption1SB() -> some View {
        modifier(Caption1SBModifier())
    }
    func caption2R() -> some View {
        modifier(Caption2RModifier())
    }
    func caption3R() -> some View {
        modifier(Caption3RModifier())
    }
    func graphBarTitle() -> some View {
        modifier(GraphBarTitleModifier())
    }
    func buttontitle1() -> some View {
        modifier(Buttontitle1Modifier())
    }
    func buttontitle2() -> some View {
        modifier(Buttontitle2Modifier())
    }
    func numberCaption1() -> some View {
        modifier(NumberCaption1Modifier())
    }
    func numberCaption2() -> some View {
        modifier(NumberCaption2Modifier())
    }
}
