//
//  TopTenUnavailableView.swift
//  TopTenMarketCap
//
//  Created by Swift on 01/12/24.
//

import SwiftUI

struct TopTenUnavailableView: View {
    
    var title: String = "Description is not available"
    var systemImage: String = "magnifyingglass"
    var description: Text = Text("Empty description")
    
    var body: some View {
        if #available(iOS 17.0, macOS 14.0, watchOS 11.0, *) {
            ContentUnavailableView(
                title,
                systemImage: systemImage,
                description: description
            )
            .foregroundColor(.gray)
        } else {
            VStack{
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 36.0, height:36)
                    .font(.title.weight(.ultraLight))
                    .foregroundColor(.gray)
                    .clipped()
                    .shadow(radius: 2, x: 0, y: 2)
                Text(title)
                    .foregroundColor(.gray)
                    .font(SwiftUI.Font.system(size: 20))
                    .font(.title.weight(.semibold))
                description
                    .foregroundColor(.gray)
                    .font(SwiftUI.Font.system(size: 14))
                    .font(.title.weight(.ultraLight))
            }
        }
    }
}

#Preview {
    TopTenUnavailableView()
}
