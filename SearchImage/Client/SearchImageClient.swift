//
//  SearchImageClient.swift
//  SearchImage
//
//  Created by JaeBin on 2023/01/14.
//

import Foundation
import ComposableArchitecture
typealias Document = SearchImageResponse.Document
struct SearchImageClient {
    var fetch: @Sendable (String,Int?) async throws -> SearchImageResponse
}

extension DependencyValues {
  var searchImageClient: SearchImageClient {
    get { self[SearchImageClient.self] }
    set { self[SearchImageClient.self] = newValue }
  }
}

extension SearchImageClient: DependencyKey {
    static var liveValue: SearchImageClient = Self(
        fetch: { keyword, page in
            guard let url = "https://dapi.kakao.com/v2/search/image".toURL else { throw RequestError.invalidError }
            var queryItems: [URLQueryItem] = [URLQueryItem(name: "query", value: keyword),
                                              URLQueryItem(name: "size", value: "30")]
            if let page = page {
                queryItems.append(URLQueryItem(name: "page", value: page.toString))
            }
            var request = URLRequest(url: url.appending(queryItems: queryItems))
            request.httpMethod = "GET"
            request.addValue("KakaoAK 1ecf35ec7347b17d762191bdfcc5bcdb", forHTTPHeaderField: "Authorization")
            let (data, response) = try await URLSession.shared.data(for: request)
            return try JSONDecoder().decode(SearchImageResponse.self, from: data)
        }
    )
    
    static let testValue = Self(
        fetch: { _,_ in
            unimplemented("\(Self.self).fetch")
        }
    )
}

enum RequestError: LocalizedError {
    case invalidError
}

