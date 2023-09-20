//
//  BeerAPI.swift
//  SeSAC3Week10
//
//  Created by NAM on 2023/09/20.
//

import Foundation
import Alamofire

enum BeerAPI {
    
    case request
    case single
    case random
    
    var baseURL: String {
        return "https://api.punkapi.com/v2/beers"
    }
    
    var endpoint: URL {
        switch self {
        case .request:
            return URL(string: baseURL)!
        case .single:
            return URL(string: baseURL + "1")!
        case .random:
            return URL(string: baseURL + "random")!
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
}
