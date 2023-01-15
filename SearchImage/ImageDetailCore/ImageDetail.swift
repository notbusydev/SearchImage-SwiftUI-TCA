//
//  ImageDetail.swift
//  SearchImage
//
//  Created by JaeBin on 2023/01/15.
//

import Foundation
import ComposableArchitecture

struct ImageDetail: ReducerProtocol {
    struct State: Equatable {
        var document: Document
    }
    
    enum Action: Equatable {
        case onDisappear
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .onDisappear:
                return .none
            }
        }
    }
}
