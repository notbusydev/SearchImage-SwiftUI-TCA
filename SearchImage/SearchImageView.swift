//
//  SearchImageView.swift
//  SearchImage
//
//  Created by JaeBin on 2023/01/13.
//

import SwiftUI
import ComposableArchitecture
import NukeUI


struct SearchImageView: View {
    let store: StoreOf<SearchImage>
    let columns = Array(repeating: GridItem(.flexible(),spacing: 0), count: 3)
    var body: some View {
        WithViewStore(store) { (viewStore: ViewStoreOf<SearchImage>) in
            NavigationStack(path: viewStore.binding(get: \.navigationPaths, send: SearchImage.Action.navigationPathChanged)) {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 0) {
                        ForEach(viewStore.documents, id: \.id) { document in
                            LazyImage(url: document.thumbnailurl.toURL)
                                .aspectRatio(1, contentMode: .fill)
                        }
                        pagingProgressView(viewStore)
                        
                    }
                }
                .searchable(text: viewStore.binding(get: \.searchText, send: SearchImage.Action.searchTextChanged),
                            placement: .navigationBarDrawer,
                            prompt: "검색어를 입력 후 검색")
            }
        }
    }
    
    @ViewBuilder func pagingProgressView(_ viewStore: ViewStoreOf<SearchImage>) -> some View {
        if viewStore.isPagingEnabled {
            Spacer()
            ProgressView().scaleEffect(2).onAppear {
                viewStore.send(.more)
            }
        }
    }
}
