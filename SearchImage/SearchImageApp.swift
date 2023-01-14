//
//  SearchImageApp.swift
//  SearchImage
//
//  Created by JaeBin on 2023/01/13.
//

import SwiftUI
import ComposableArchitecture

@main
struct SearchImageApp: App {
    let store = StoreOf<SearchImage>(initialState: SearchImage.State(),
                                     reducer: SearchImage().dependency(\.searchImageClient, .liveValue))
    var body: some Scene {
        WindowGroup {
            SearchImageView(store: store)
        }
    }
}
