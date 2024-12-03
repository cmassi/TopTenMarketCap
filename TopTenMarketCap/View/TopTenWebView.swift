//
//  TopTenWebView.swift
//  TopTenMarketCap
//
//  Created by Swift on 01/12/24.
//

import SwiftUI
import WebKit

struct TopTenWebView: UIViewRepresentable {
    @Binding var text: String
    @Environment(\.colorScheme) var colorScheme

    // https://www.w3schools.com/colors/colors_shades.asp
    var htmlBodyColorText: String {
        if colorScheme == .dark {
            return "<html><body><h1 style='font-size:4vw'><div style='color:#00FF66'>"+text+"</div></h1></body></html>"
        } else {
            return "<html><body><h1 style='font-size:5vw'>"+text+"</h1></body></html>"
        }
    }
    
    var htmlBodyText: String {
        "<html><body>"+text+"</body></html>"
    }
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlBodyColorText, baseURL: nil)
        uiView.isOpaque = false
        uiView.backgroundColor = .systemBackground
        uiView.tintColor = .blue
    }
}

#Preview {
    @Previewable @State var text = "Top 10 Coins"
    TopTenWebView(text: $text)
}
