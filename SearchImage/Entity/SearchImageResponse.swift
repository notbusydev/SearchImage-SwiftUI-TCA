//
//  SearchImageResponse.swift
//  SearchImage
//
//  Created by JaeBin on 2023/01/14.
//

import Foundation
struct SearchImageResponse: Decodable, Equatable {
    let meta: Meta
    let documents: [Document]
    
    // MARK: - Meta
    struct Meta: Decodable, Equatable {
        let isEnd: Bool
    }
    
    // MARK: - Document
    struct Document: Decodable, Equatable, Identifiable, Hashable {
        var id: String { return thumbnailURL }
        
        let collection: String
        let thumbnailURL: String
        let imageURL: String
        let width: Int
        let height: Int
        let displaySitename: String
        let docURL: String
        let datetime: String
    }
}





