//
//  Network.swift
//  SeSAC3Week10
//
//  Created by NAM on 2023/09/19.
//

import Foundation
import Alamofire

class Network {
    static let shared = Network()
    
    private init() { }
    
    //"고래밥" > String > String.Type
    
    //Generic: decoding처리가 가능한 요소..! protocol 제약 필요..! / Photo -> T
//    func request<T: Decodable>(api: SeSACAPI, completion: @escaping (Result<T, SeSACError>) -> Void  ) {
    func request<T: Decodable>(type: T.Type, api: SeSACAPI, completion: @escaping (Result<T, SeSACError>) -> Void  ) {
        
        AF.request(api.endpoint, method: api.method, parameters: api.query, encoding: URLEncoding(destination: .queryString), headers: api.header)
            .responseDecodable(of: T.self) { response in // Photo -> T
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(_):
                    let statusCode = response.response?.statusCode ?? 500
                    guard let error = SeSACError(rawValue: statusCode) else { return }
                    completion(.failure(error))
                }
            }
    }

    
}
