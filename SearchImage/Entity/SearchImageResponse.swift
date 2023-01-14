//
//  SearchImageResponse.swift
//  SearchImage
//
//  Created by JaeBin on 2023/01/14.
//

import Foundation
struct SearchImageResponse {
    let meta: Meta
    let documents: [Document]
    
    // MARK: - Meta
    struct Meta {
        let isEnd: Bool
    }
    
    // MARK: - Document
    struct Document {
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





