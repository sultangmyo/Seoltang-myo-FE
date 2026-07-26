//
//  PDFGenerator.swift
//  sugarcat
//
//  Created by 野菜サンド on 6/29/26.
//

import SwiftUI

enum PDFGenerator {
    /// SwiftUI View를 이미지로 렌더링한 뒤 PDF 파일로 저장합니다.
    ///
    /// 화면에 연결되지 않은 UIHostingController의 layer를 바로 캡처하면
    /// SwiftUI의 레이아웃이 끝나기 전에 흰 배경만 PDF에 기록될 수 있습니다.
    /// ImageRenderer를 사용하면 화면 표시 여부와 관계없이 View를 확정 렌더링할 수 있습니다.
    @MainActor
    static func generatePDF<Content: View>(
        view content: Content,
        fileName: String
    ) -> URL? {
        let pageWidth: CGFloat = 595

        // PDF에 들어갈 콘텐츠의 너비를 고정하고 배경을 명시합니다.
        // 배경을 지정하면 다크 모드에서도 PDF가 흰색 문서로 생성됩니다.
        let imageRenderer = ImageRenderer(
            content: content
                .frame(width: pageWidth)
                .fixedSize(horizontal: false, vertical: true)
                .background(Color.white)
        )

        // 높이는 nil로 두어 표의 실제 내용만큼 자동으로 계산되게 합니다.
        imageRenderer.proposedSize = ProposedViewSize(width: pageWidth, height: nil)

        // PDF 안의 글자와 선이 흐려지지 않도록 2배 해상도로 렌더링합니다.
        imageRenderer.scale = 2

        guard let renderedImage = imageRenderer.uiImage,
              renderedImage.size.width > 0,
              renderedImage.size.height > 0 else {
            print("❌ PDF 콘텐츠 이미지 렌더링 실패")
            return nil
        }

        // UIImage.size는 포인트 단위이므로 이 크기를 그대로 PDF 페이지 크기로 사용합니다.
        let pageBounds = CGRect(origin: .zero, size: renderedImage.size)
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: pageBounds)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).pdf")

        do {
            try pdfRenderer.writePDF(to: url) { context in
                context.beginPage()
                renderedImage.draw(in: pageBounds)
            }
            return url
        } catch {
            print("❌ PDF 파일 생성 실패: \(error)")
            return nil
        }
    }
}
