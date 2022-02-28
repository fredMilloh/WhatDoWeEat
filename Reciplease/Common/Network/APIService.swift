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

    /// Method to retrieve data or an error from the API, with url as parameter.
    /// - Url is defined according to the ingredients.
    /// - The data or error is placed in a callback to be retrieved when this method is called
    func get(url: URL, callback: @escaping (_ data: (Data)?, _ error: RecipeError?) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .failure(let error):
                debugPrint("AFError :", error)
                callback(nil, .fetchError)
            case .success(let data):
                callback(data, nil)
            }
        }
    }
}
