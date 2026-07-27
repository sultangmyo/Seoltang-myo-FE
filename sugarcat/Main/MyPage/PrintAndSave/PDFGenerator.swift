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
        generatePDF(pages: [AnyView(content)], fileName: fileName)
    }

    @MainActor
    static func generatePDF(
        pages: [AnyView],
        fileName: String
    ) -> URL? {
        let pageWidth: CGFloat = 595
        let renderedPages = pages.compactMap { page -> UIImage? in
            let imageRenderer = ImageRenderer(
                content: page
                    .frame(width: pageWidth)
                    .fixedSize(horizontal: false, vertical: true)
                    .background(Color.white)
            )
            imageRenderer.proposedSize = ProposedViewSize(width: pageWidth, height: nil)
            imageRenderer.scale = 2
            return imageRenderer.uiImage
        }

        guard renderedPages.count == pages.count,
              let firstPage = renderedPages.first,
              firstPage.size.width > 0,
              firstPage.size.height > 0 else {
            print("❌ PDF 페이지 렌더링 실패")
            return nil
        }

        let firstPageBounds = CGRect(origin: .zero, size: firstPage.size)
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: firstPageBounds)
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).pdf")

        do {
            try pdfRenderer.writePDF(to: url) { context in
                for renderedPage in renderedPages {
                    let pageBounds = CGRect(origin: .zero, size: renderedPage.size)
                    context.beginPage(withBounds: pageBounds, pageInfo: [:])
                    renderedPage.draw(in: pageBounds)
                }
            }
            return url
        } catch {
            print("❌ PDF 파일 생성 실패: \(error)")
            return nil
        }
    }
}
