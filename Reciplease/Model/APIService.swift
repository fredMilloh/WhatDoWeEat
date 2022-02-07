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

    typealias completion = (_ status: Bool, _ recipes: RecipePage?) -> Void

    func getRecipes(url: URL, callback: @escaping completion) {

        AF.request(url as URLConvertible).response { (responseData) in
            guard let input = responseData.data else {
                callback(false, nil)
                return
            }
            do {
                let recipes = try JSONDecoder().decode(RecipePage.self, from: input)
                callback(true, recipes)
            } catch {
                callback(false, nil)
            }
        }
    }
}
