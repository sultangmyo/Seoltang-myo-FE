//
//  PDFGenerator.swift
//  sugarcat
//
//  Created by 野菜サンド on 6/29/26.
//

import SwiftUI
import PDFKit

class PDFGenerator {
    static func generatePDF(view: some View, fileName: String) -> URL? {
        let controller = UIHostingController(rootView: view.frame(width: 595)) // 너비 고정
        let view = controller.view
        
        let targetSize = view?.sizeThatFits(CGSize(width: 595, height: CGFloat.greatestFiniteMagnitude)) ?? CGSize(width: 595, height: 842)
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .white
        
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: targetSize))
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("\(fileName).pdf")
        
        do {
            try renderer.writePDF(to: url) { context in
                context.beginPage()
                view?.layer.render(in: context.cgContext)
            }
            return url
        } catch {
            return nil
        }
    }
}
