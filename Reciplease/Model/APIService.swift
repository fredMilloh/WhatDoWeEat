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

    let url = URL(string: "https://api.edamam.com/api/recipes/v2?type=public&q=lemon&app_id=17f51d8a&app_key=7")

    typealias completion = (_ status: Bool, _ recipes: RecipePage?) -> Void

    func getRecipes(callback: @escaping completion) {
        guard let urL = url else { return }

        AF.request(urL as URLConvertible).response { (responseData) in
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
