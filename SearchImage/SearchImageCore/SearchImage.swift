//
//  SearchImageCore.swift
//  SearchImage
//
//  Created by JaeBin on 2023/01/14.
//

import Foundation
import ComposableArchitecture

struct SearchImage: ReducerProtocol {
    
    enum Route: Hashable {
        case imageDetail(Document)
    }
    
    struct State: Equatable {
        var navigationPaths: [Route] = []
        var searchText: String = ""
        var page: Int? = nil
        var documents: [Document] = []
        var isPagingEnabled: Bool = false
        var errorMessage: String?
    }
    
    enum Action: Equatable {
        case navigationPathChanged([Route])
        case errorMessage(String?)
        case searchTextChanged(String)
        case searchImage
        case searchFetchResponse(SearchImageResponse)
        case more
    }
    
    private enum SearchTextDebounceID { }
    
    @Dependency(\.searchImageClient) var searchImageClient
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .navigationPathChanged(let paths):
                state.navigationPaths = paths
                return .none
            case .errorMessage(let message):
                state.errorMessage = message
                return .none
            case .searchTextChanged(let text):
                state.searchText = text
                state.page = nil
                state.isPagingEnabled = false
                state.documents = []
                return .task {
                    try await Task.sleep(for: .seconds(1))
                    return .searchImage
                }.cancellable(id: SearchTextDebounceID.self)
            case .searchImage:
                let searchText = state.searchText
                let page = state.page
                return .task {
                    do {
                        let response = try await searchImageClient.fetch(searchText, page)
                        return .searchFetchResponse(response)
                    } catch {
                        return .errorMessage(error.localizedDescription)
                    }
                }
            case .searchFetchResponse(let response):
                let newDocuments = response.documents
                if state.page == nil {
                    state.documents = response.documents
                } else {
                    let currentDocuments = state.documents
                    state.documents = currentDocuments + newDocuments
                }
                state.isPagingEnabled = !response.meta.isEnd
                return .none
            case .more:
                let currentPage = state.page ?? 1
                state.page = currentPage + 1
                return .task { .searchImage }
            }
          
        }
    }
}
