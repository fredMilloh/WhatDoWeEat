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

    func get(url: URL, callback: @escaping (_ data: (Data), _ error: (RecipeError)?) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .failure(let error):
                debugPrint(error)
                callback(Data(), .invalidData)
//                callback(Data(), .fetchError(error))
            case .success(let data):
                callback(data, nil)
            }
        }
    }
}
