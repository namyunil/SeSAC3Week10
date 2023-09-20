//
//  AssignmentNetwork.swift
//  SeSAC3Week10
//
//  Created by NAM on 2023/09/20.
//

import Foundation
import Alamofire

class AssignmentNetwork {
    static let shared = AssignmentNetwork()
    
    private init() { }
    
    func request<T: Decodable>(type: T.Type, api: BeerAPI, completion: @escaping (Result<T, Error>) -> Void ) {
        let url = "https://api.punkapi.com/v2/beers"
        AF.request(api.endpoint, method: api.method).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                dump(data)
                completion(.success(data))
            case .failure(_):
                let statusCode = response.response?.statusCode ?? 400
                guard let error = BeerError(rawValue: statusCode) else { return }
                completion(.failure(error))
            }
            
        }
    }
}
