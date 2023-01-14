//
//  SearchImageView.swift
//  SearchImage
//
//  Created by JaeBin on 2023/01/13.
//

import SwiftUI
import ComposableArchitecture

struct SearchImageView: View {
    let store: StoreOf<SearchImage>
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}
