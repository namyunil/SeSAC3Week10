//
//  SeSACAPI.swift
//  SeSAC3Week10
//
//  Created by NAM on 2023/09/19.
//

import Foundation
import Alamofire

//enum Router: URLRequestConvertible { //더 강제화가 된 구조를 만들 수 있다.. -> 다른 개발자가 봐도 어떤 구조인지 대략 알 수 있다
//
//}


enum SeSACAPI {
    
    private static let key = "4XAKUY4o2AszZ3mzeGWxR1J52u0b-jF2Jye0rWE4uB8"
    
    
    case search(query: String) // 연관값, associated value
    case random
    case photo(id: String) // 연관값, associated value
    
    private var baseURL: String { // baseURL은 하나로 고정되어있지는 않다, 당연히 상황에 따라 다르게 나누어줄 수 있다..!
        return "https://api.unsplash.com/"
    }
    
    var endpoint: URL {
        switch self {
        case .search:
            return URL(string: baseURL + "search/photos")!
        case .random:
            return URL(string: baseURL + "photos/random")!
        case .photo(let id): // (let id) - 연관값
            return URL(string: baseURL + "photos/\(id)")!
            //열거형을 사용하면서도 매개변수를 활용할 수 있다..!
            //URL이 항상 같은 것이 아니라, 그때그때 달라질 수 있다..!
            //
        }
    }
    
    var header: HTTPHeaders {
        return ["Authorization": "Client-ID \(SeSACAPI.key)"]
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var query: [String: String] {
        switch self {
        case .search(let query):
            return ["query": query]
        case .random, .photo:
            return ["": ""]
        }
    }
}


