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
    
    enum CodingKeys: String, CodingKey {
        case meta = "meta"
        case documents = "documents"
    }
    
    // MARK: - Meta
    struct Meta: Decodable, Equatable {
        let isEnd: Bool
        
        enum CodingKeys: String, CodingKey {
            case isEnd = "is_end"
        }
    }
    
    // MARK: - Document
    struct Document: Decodable, Equatable, Identifiable, Hashable {
        var id: String { return thumbnailurl }
        
        let thumbnailurl: String
        let imageurl: String
        let width: Int
        let height: Int
        let displaySitename: String
        let datetime: String

        enum CodingKeys: String, CodingKey {
            case thumbnailurl = "thumbnail_url"
            case imageurl = "image_url"
            case width = "width"
            case height = "height"
            case displaySitename = "display_sitename"
            case datetime = "datetime"
        }
    }
}





