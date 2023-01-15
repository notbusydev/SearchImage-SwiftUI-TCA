//
//  ImageDetailView.swift
//  SearchImage
//
//  Created by JaeBin on 2023/01/15.
//

import SwiftUI
import ComposableArchitecture
import NukeUI
struct ImageDetailView: View {
    let store: StoreOf<ImageDetail>
    var body: some View {
        WithViewStore(store) { (viewStore: ViewStoreOf<ImageDetail>) in
            GeometryReader { proxy in
                ScrollView {
                    LazyImage(url: viewStore.document.imageurl.toURL)
                        .frame(width: proxy.size.width)
                        .aspectRatio(viewStore.document.width.toCGFloat / viewStore.document.height.toCGFloat , contentMode: .fit)
                    imageInformation(viewStore)
                }
            }
            .navigationTitle(viewStore.document.collection.uppercased())
            
        }
    }
    
    @ViewBuilder func imageInformation(_ viewStore: ViewStoreOf<ImageDetail>) -> some View {
        VStack(alignment: .leading, spacing: 5){
            if let displaySitename = viewStore.document.displaySitename, !displaySitename.isEmpty {
                Text(String(format: "출처: %@", displaySitename))
            }
            if let dateTime = viewStore.document.datetime, !dateTime.isEmpty {
                Text(String(format: "문서 작성 시간: %@", dateTime))
            }
        }
        .frame(maxWidth: .infinity)
        .padding(10)
        
    }
}

