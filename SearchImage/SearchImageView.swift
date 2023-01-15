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
                    if !viewStore.documents.isEmpty {
                        LazyVGrid(columns: columns, spacing: 0) {
                            ForEach(viewStore.documents, id: \.id) { document in
                                LazyImage(url: document.thumbnailurl.toURL)
                                    .aspectRatio(1, contentMode: .fill)
                                    .onTapGesture { viewStore.send(.imageTouched(document)) }
                            }
                            pagingProgressView(viewStore)
                            
                        }
                    } else {
                        emptyView(viewStore)
                    }
                }
                .navigationTitle("이미지 검색")
                .searchable(text: viewStore.binding(get: \.searchText, send: SearchImage.Action.searchTextChanged),
                            placement: .navigationBarDrawer,
                            prompt: "검색어를 입력 후 검색")
                .navigationDestination(for: SearchImage.Route.self) { route in
                    switch route {
                    case .imageDetail:
                        IfLetStore(self.store.scope(state: \.selectedDocument, action: SearchImage.Action.imageDetail)) { store in
                            ImageDetailView(store: store)
                        }
                    }
                }
                
            }
        }
    }
    
    @ViewBuilder func pagingProgressView(_ viewStore: ViewStoreOf<SearchImage>) -> some View {
        if viewStore.isPagingEnabled {
            Spacer()
            ProgressView()
                .frame(height: 200)
                .scaleEffect(2)
                .onAppear {
                    viewStore.send(.more)
                }
        }
    }
    
    @ViewBuilder func emptyView(_ viewStore: ViewStoreOf<SearchImage>) -> some View {
        Spacer(minLength: 100)
        if viewStore.searchText.isEmpty {
            Text("검색어를 입력해주세요.")
        } else if !viewStore.isChangingText {
            Text("검색 결과가 없습니다.")
        }
    }
}
