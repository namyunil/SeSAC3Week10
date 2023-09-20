//
//  AssignmentNetworkBasic.swift
//  SeSAC3Week10
//
//  Created by NAM on 2023/09/20.
//

import Foundation
import Alamofire

enum BeerError: Int, Error {
    case unauthorized = 400
}


class AssignmentNetworkBasic {
    
    static let shared = AssignmentNetworkBasic()
    
    private init() { }
    
    
    func request(api: BeerAPI, completion: @escaping (Result<Beer, Error>) -> Void ) {
        let url = "https://api.punkapi.com/v2/beers"
        AF.request(api.endpoint, method: api.method).responseDecodable(of: Beer.self) { response in
            switch response.result {
            case .success(let data):
                dump(data)
                completion(.success(data))
            case .failure(_):
                //print(error)
                let statusCode = response.response?.statusCode ?? 400
                guard let error = BeerError(rawValue: statusCode) else { return }
                completion(.failure(error))
            }
            
        }
    }
    
    func single(api: BeerAPI, completion: @escaping (Result<Beer, Error>) -> Void) {
        let url = "https://api.punkapi.com/v2/beers/1"
        AF.request(api.endpoint, method: api.method).responseDecodable(of: Beer.self) { response in
            switch response.result {
            case .success(let data):
                dump(data)
                completion(.success(data))
            case .failure(_):
                //print(error)
                let statusCode = response.response?.statusCode ?? 400
                guard let error = BeerError(rawValue: statusCode) else { return }
                completion(.failure(error))
                
            }
            
        }
    }
    
    func random(api: BeerAPI, completion: @escaping ((Result<Beer, Error>) -> Void)) {
        let url = "https://api.punkapi.com/v2/beers/random"
        AF.request(api.endpoint, method: api.method).responseDecodable(of: Beer.self) { response in
            switch response.result {
            case .success(let data):
                dump(data)
                completion(.success(data))
            case .failure(_):
                //print(error)
                let statusCode = response.response?.statusCode ?? 400
                guard let error = BeerError(rawValue: statusCode) else { return }
                completion(.failure(error))
            }
            
        }
    }
}
