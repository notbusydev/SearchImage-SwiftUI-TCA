//
//  Int+Extension.swift
//  SearchImage
//
//  Created by JaeBin on 2023/01/14.
//

import Foundation

extension String {
    var toURL: URL? {
        guard let encodingURLString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return nil }
        return URL(string: encodingURLString)
    }
}
