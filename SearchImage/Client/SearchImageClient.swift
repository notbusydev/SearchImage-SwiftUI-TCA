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
            guard keyword != "테스트에러발생" else { throw RequestError.test }
            guard let url = "https://dapi.kakao.com/v2/search/image".toURL else { throw RequestError.invalidURL }
            var queryItems: [URLQueryItem] = [URLQueryItem(name: "query", value: keyword),
                                              URLQueryItem(name: "size", value: "30")]
            if let page = page {
                queryItems.append(URLQueryItem(name: "page", value: page.toString))
            }
            var request = URLRequest(url: url.appending(queryItems: queryItems))
            request.httpMethod = "GET"
            request.addValue("KakaoAK \(Constants.restAPIKEY)", forHTTPHeaderField: "Authorization")
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
    case invalidURL
    case test
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL이 유실 되었습니다."
        case .test:
            return "테스트용 에러메시지입니다."
            
        }
    }
    
}

