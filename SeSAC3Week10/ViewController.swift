//
//  ViewController.swift
//  SeSAC3Week10
//
//  Created by NAM on 2023/09/19.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Network.shared.request(api: , completion: <#T##(Result<Decodable, SeSACError>) -> Void#>)
        
        Network.shared.request(type: PhotoResult.self, api: .random) { response in
            switch response {
            case .success(let success):
                dump(success)
            case .failure(let failure):
                print(failure.errorDescription)
            }
        }
        
        Network.shared.request(type: PhotoResult.self, api: .search(query: "roWGFsnlVDA")) { response in
            switch response {
            case .success(let success):
                dump(success)
            case .failure(let failure):
                print(failure.errorDescription)
            }
        }
        
        
        
        
        /*
         NetworkBasic.shared.random { photo, error in // 매개변수가 2개로 나온다
         
         guard let photo = photo else { // optional값이기 떄문에 옵셔널 바인딩을..!
         
         return
         
         }
         */
        /*
         해당 코드는 보기엔 문제가 없는 것 같지만, 논리적으론 양립할 수 없는 구문이다
         //1.
         guard let photo = photo else { return }
         guard let error = error else { return }
         
         //2.
         guard let photo = photo, error = error else { return }
         */
        
        /*
         NetworkBasic.shared.detailPhoto(id: "") { response in // 매개변수가 하나로 나온다.
         switch response { // 옵셔널 타입이 아니기때문에 대응 할 필요가 없다..!
         case .success(let success): // 성공했을때의 데이터가 let success에서 success에 들어간다..! success는 photoResult 타입..!
         print(success)
         case .failure(let failure):
         print(failure)
         }
         }
         }
         */
    }
    }
    
    //Codable : Decodable + Encodable
    //decoding : 우리가 사용할 수 있는 형태로 변환
    //encoding : 밖으로 보냈을 때, 혼용해서 사용할 수 있도록
    //다른 API 호출하더라도 구조가 동일하다면, 굳이 새로운 구조체를 만들어서 대응하지않아도 된다.
    struct Photo: Decodable {
        let total: Int
        let total_pages: Int
        let results: [PhotoResult]
    }
    
    struct PhotoResult: Decodable {
        let id: String
        let created_at: String
        let urls: PhotoURL
    }
    
    struct PhotoURL : Decodable {
        let full: String
        let thumb: String
    }

