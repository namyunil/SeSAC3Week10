//
//  AssignmentViewController.swift
//  SeSAC3Week10
//
//  Created by NAM on 2023/09/20.
//

import UIKit
import Alamofire

class AssignmentViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AssignmentNetwork.shared.request(type: Beer.self, api: .request) { response in
            switch response {
            case .success(let success):
                dump(success)
            case .failure(let failure):
                print(failure)
            }
        }
        
    }
}


struct Beer: Decodable {
    let id: Int
    let name, description: String
    let imageURL: String
    let srm: Int
    let ph: Double
    let foodPairing: [String]
    let brewersTips, contributedBy: String

}

