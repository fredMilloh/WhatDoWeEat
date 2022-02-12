//
//  APIService.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import Foundation
import Alamofire

class APIService {

    static var shared = APIService()
    private init() {}

    func get(url: URL, callback: @escaping (_ data: (Data), _ error: (AFError)?) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .failure(let error):
                callback(Data(), error)
            case .success(let data):
                callback(data, nil)
            }
        }
    }
}
