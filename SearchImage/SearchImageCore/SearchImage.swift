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
        case imageDetail()
    }
    
    struct State: Equatable {
        var searchText: String = ""
        var page: Int? = nil
        var documents: 
    }
    
    enum Action: Equatable {
        case searchTextChanged(String)
        case searchFetch
    }
    
    var body: some Reduce {
    }
}
