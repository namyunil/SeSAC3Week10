//
//  NetworkBasic.swift
//  SeSAC3Week10
//
//  Created by NAM on 2023/09/19.
//

import Foundation
import Alamofire

enum SeSACError: Int, Error, LocalizedError { // Error 대응을 하기 위해 Error Protocol 채택
    case unauthorized = 401
    case permissionDenied = 403
    case invalidServer = 500
    case missingParameter = 400
    
    //연산 프로퍼티를 활용해서 오류 코드에 따른 문구를 다르게 표현하기..!
    var errorDescription: String { // LocalizedError 프로토콜에 구현되어 있기에 LocalizedError를 채택..!
        switch self {
        case .unauthorized:
            return "인증 정보가 없습니다"
        case .permissionDenied:
            return "권한이 없습니다"
        case .invalidServer:
            return "서버 점검 중입니다"
        case .missingParameter:
            return "검색어를 입력해주세요"
        }
    }
}



final class NetworkBasic { // final - 상속이 되지 않는다. -> 성능이 더욱 좋아질 것, 유지보수 차원에도 사용한다. final 키워드가 없다면 어디까지 영향을 미치는가..!
    
    static let shared = NetworkBasic()
    
    private init() { }
    //func request(query: String, completion: @escaping (Photo?, Error?) -> Void ) { // search photo
    func request(api: SeSACAPI, query: String, completion: @escaping (Result<Photo, SeSACError>) -> Void  ) { // search photo
        
        // 1. Photo O, Error X / 2. Photo X, Error O 의 경우가 있기때문에 둘을 옵셔널로 대응한다..!
        // 하지만 문법적으로 1. Photo O, Error O / 2. Photo X Error X 또한 문제가 없기때문에..!
        // 이를 해결하기위해 명확하게 2가지만 존재하는 열거형 타입의 Result<Success, Failure>로 대응할 수 있다.
        // 이를 활용하면 경우의 수는 줄어들고, 귀찮은 옵셔널에 대한 상황을 해결할 수 있다.
        
        
        //let api = SeSACAPI.search(query: query) -> 파라미터 추가 api: SeSACAPI
        //let key = "4XAKUY4o2AszZ3mzeGWxR1J52u0b-jF2Jye0rWE4uB8"
        //let url = "https://api.unsplash.com/search/photos"
        //let headers: HTTPHeaders = ["Authorization": "Client-ID \(SeSACAPI.key)"]
        // 1. type annotation을 하지않으면 [String : String]으로 타입 추론을 하기때문에, type annotation을 사용해야한다..!
        // 2. headers: headers -> HTTPHeaders(headers)처럼 형 변환과 비슷한 형태로 구조체 생성할 수 도 있다..!
        //let query: Parameters = ["query": query]

        
        //alamofire에 parameter는 method가 post일때, httpbody로 들어가게된다..! / .post -> http body
        //encoding: URLEncoding(destination: .queryString) -> url뒤에 붙이기 위해..! ?query=sky를 위한..!
        AF.request(api.endpoint, method: api.method, parameters: api.query, encoding: URLEncoding(destination: .queryString), headers: api.header) // encoding의 기본값은 httpbody로 향하는 것인데..! 이를 변경하기 위해 코드를 작성..!
            .responseDecodable(of: Photo.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(_): // let error가 아래의 코드에서는 사용되지 않고있어 와일드카드로 대응..!
                    //만약 아래 두 줄의 코드가 없다면 아래의 errors는 let error와 동일하다..!
                    //guard let statusCode = response.response?.statusCode else { return }
                    let statusCode = response.response?.statusCode ?? 500
                    guard let error = SeSACError(rawValue: statusCode) else { return }
                    completion(.failure(error))
                }
            } //of : 어떤 데이터를 decoding 할래?
    }

    
    //func random(completion : @escaping (PhotoResult?, SeSACError?) -> Void) { // random photo
    func random(api: SeSACAPI, completion: @escaping (Result<PhotoResult, SeSACError>) -> Void) {
            
            //let api = SeSACAPI.random
            //let key = "4XAKUY4o2AszZ3mzeGWxR1J52u0b-jF2Jye0rWE4uB8"
            //let url = "https://api.unsplash.com/photos/random"
            //let headers: HTTPHeaders = ["Authorization": "Client-ID \(SeSACAPI.key)"]
            
            AF.request(api.endpoint, method: api.method, headers: api.header)
                .responseDecodable(of: PhotoResult.self) { response in
                    switch response.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(_): // let error가 아래의 코드에서는 사용되지 않고있어 와일드카드로 대응..!
                        //만약 아래 두 줄의 코드가 없다면 아래의 errors는 let error와 동일하다..!
                        //guard let statusCode = response.response?.statusCode else { return }
                        let statusCode = response.response?.statusCode ?? 500
                        guard let error = SeSACError(rawValue: statusCode) else { return }
                        completion(.failure(error))
                    }
                }
        }
    
    //photos/:id
    func detailPhoto(api: SeSACAPI, id: String, completion: @escaping (Result<PhotoResult, SeSACError>) -> Void) {
       
        //let api = SeSACAPI.photo(id: id) // 연관값은 매개변수처럼 생각하자..!
        
        //let key = "4XAKUY4o2AszZ3mzeGWxR1J52u0b-jF2Jye0rWE4uB8"
        //let url = "https://api.unsplash.com/photos/\(id)"
        //let headers: HTTPHeaders = ["Authorization": "Client-ID \(SeSACAPI.key)"]
        
        AF.request(api.endpoint, method: api.method, headers: api.header)
        // encoding의 기본값은 httpbody로 향하는 것인데..! 이를 변경하기 위해 코드를 작성..!
            .responseDecodable(of: PhotoResult.self) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data))
                case .failure(_): // let error가 아래의 코드에서는 사용되지 않고있어 와일드카드로 대응..!
                    //만약 아래 두 줄의 코드가 없다면 아래의 errors는 let error와 동일하다..!
                    //guard let statusCode = response.response?.statusCode else { return }
                    let statusCode = response.response?.statusCode ?? 500
                    guard let error = SeSACError(rawValue: statusCode) else { return }
                    completion(.failure(error))
                }
            }
    }
    
}
