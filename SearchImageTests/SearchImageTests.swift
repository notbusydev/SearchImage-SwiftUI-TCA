//
//  SearchImageTests.swift
//  SearchImageTests
//
//  Created by JaeBin on 2023/01/13.
//

import XCTest
import ComposableArchitecture
@testable import SearchImage

@MainActor
final class SearchImageTests: XCTestCase {
    
    func test검색_Swift() async {
        let store = TestStore(initialState: SearchImage.State(),
                              reducer: SearchImage())
        store.dependencies.searchImageClient.fetch = { _,_ in .mock }
        
        await store.send(.searchTextChanged("Swift")) { state in
            state.searchText = "Swift"
            state.isChangingText = true
        }
        
        await store.receive(.searchImage, timeout: .seconds(1.5))
        await store.receive(.searchFetchResponse(.mock)) { state in
            state.documents = SearchImageResponse.mock.documents
            state.isPagingEnabled = true
            state.isChangingText = false
        }
    }
    
    func test검색어_변경_디바운스() async {
        let store = TestStore(initialState: SearchImage.State(),
                              reducer: SearchImage())
        store.dependencies.searchImageClient.fetch = { _,_ in .mock }
        
        await store.send(.searchTextChanged("ㄱ")) { state in
            state.searchText = "ㄱ"
            state.isChangingText = true
        }
        
        await store.send(.searchTextChanged("ㄱㄱ")) { state in
            state.searchText = "ㄱㄱ"
        }
        
        await store.send(.searchTextChanged("ㄱㄱㄱ")) { state in
            state.searchText = "ㄱㄱㄱ"
        }
        
        await store.receive(.searchImage, timeout: .seconds(1.5))
        await store.receive(.searchFetchResponse(.mock)) { state in
            state.documents = SearchImageResponse.mock.documents
            state.isPagingEnabled = true
            state.isChangingText = false
        }
    }
    
    func test검색_더보기() async {
        let store = TestStore(initialState: SearchImage.State(searchText: "Swift",
                                                              documents: SearchImageResponse.mock.documents,
                                                              isPagingEnabled: true),
                              reducer: SearchImage())
        store.dependencies.searchImageClient.fetch = { _,_ in .moreMock }
        
        await store.send(.more) { state in
            state.page = 2
        }
        
        await store.receive(.searchImage)
        await store.receive(.searchFetchResponse(.moreMock)) { state in
            state.documents = SearchImageResponse.mock.documents + SearchImageResponse.moreMock.documents
            state.isPagingEnabled = false
        }
    }
}


extension SearchImageResponse {
    static let mock = Self(meta: Meta(isEnd: false),
                           documents: [Document(collection: "네이버", thumbnailurl: "thumbnailurl1",
                                                imageurl: "imageurl", width: 300, height: 150,
                                                displaySitename: "네이버 뉴스", datetime: "2017-06-21T15:59:30.000+09:00"),
                                       Document(collection: "다음", thumbnailurl: "thumbnailurl2",
                                                imageurl: "imageurl", width: 300, height: 150,
                                                displaySitename: "다음 뉴스", datetime: "2017-06-21T15:59:30.000+09:00"),
                                       Document(collection: "토스", thumbnailurl: "thumbnailurl3",
                                                imageurl: "imageurl", width: 300, height: 150,
                                                displaySitename: "토스 뉴스", datetime: "2017-06-21T15:59:30.000+09:00"),
                                       Document(collection: "브랜디", thumbnailurl: "thumbnailurl4",
                                                imageurl: "imageurl", width: 300, height: 150,
                                                displaySitename: "브랜디 뉴스", datetime: "2017-06-21T15:59:30.000+09:00"),
                                       Document(collection: "당근", thumbnailurl: "thumbnailurl5",
                                                imageurl: "imageurl", width: 300, height: 150,
                                                displaySitename: "당근 뉴스", datetime: "2017-06-21T15:59:30.000+09:00"),
                                       Document(collection: "배민", thumbnailurl: "thumbnailurl6",
                                                imageurl: "imageurl", width: 300, height: 150,
                                                displaySitename: "배민 뉴스", datetime: "2017-06-21T15:59:30.000+09:00"),
                                       Document(collection: "요기요", thumbnailurl: "thumbnailurl7",
                                                imageurl: "imageurl", width: 300, height: 150,
                                                displaySitename: "요기요 뉴스", datetime: "2017-06-21T15:59:30.000+09:00")])
    static let moreMock = Self(meta: Meta(isEnd: true),
                               documents: [Document(collection: "네이버2", thumbnailurl: "thumbnailurl8",
                                                    imageurl: "imageurl", width: 300, height: 150,
                                                    displaySitename: "네이버 뉴스", datetime: "2017-06-21T15:59:30.000+09:00"),
                                           Document(collection: "다음2", thumbnailurl: "thumbnailurl9",
                                                    imageurl: "imageurl", width: 300, height: 150,
                                                    displaySitename: "다음 뉴스", datetime: "2017-06-21T15:59:30.000+09:00"),
                                           Document(collection: "토스2", thumbnailurl: "thumbnailurl10",
                                                    imageurl: "imageurl", width: 300, height: 150,
                                                    displaySitename: "토스 뉴스", datetime: "2017-06-21T15:59:30.000+09:00"),
                                           Document(collection: "브랜디2", thumbnailurl: "thumbnailurl11",
                                                    imageurl: "imageurl2", width: 300, height: 150,
                                                    displaySitename: "브랜디 뉴스", datetime: "2017-06-21T15:59:30.000+09:00"),
                                           Document(collection: "당근2", thumbnailurl: "thumbnailurl12",
                                                    imageurl: "imageurl", width: 300, height: 150,
                                                    displaySitename: "당근 뉴스", datetime: "2017-06-21T15:59:30.000+09:00"),
                                           Document(collection: "배민2", thumbnailurl: "thumbnailurl13",
                                                    imageurl: "imageurl", width: 300, height: 150,
                                                    displaySitename: "배민2 뉴스", datetime: "2017-06-21T15:59:30.000+09:00"),
                                           Document(collection: "요기요2", thumbnailurl: "thumbnailurl14",
                                                    imageurl: "imageurl", width: 300, height: 150,
                                                    displaySitename: "요기요 뉴스", datetime: "2017-06-21T15:59:30.000+09:00")])
    static let emptyMock = Self(meta: Meta(isEnd: false),
                           documents: [])
}
