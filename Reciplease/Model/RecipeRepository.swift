//
//  RecipeRepository.swift
//  Reciplease
//
//  Created by fred on 07/02/2022.
//

import Foundation

class RecipeRepository {

    typealias RecipesOrError = (_ recipes: (RecipePage)?, _ error: RecipeError?) -> Void

    /// Retrieving the result of the network call (Weather data or error) with the APIService method call.

    static var shared = RecipeRepository()
    private init() {}

    var apiKey: String = "7"
    var appId: String = "17f51d8a"
    /// to test getUrl method with a fake apiKey
    init(apiKey: String, appId: String) {
        self.apiKey = apiKey
        self.appId = appId
    }

    func getRecipes(ingredients: [String], completion: @escaping RecipesOrError) {

        let recipesUrl = getUrl(with: ingredients)
        guard let url = recipesUrl else {
            completion(nil, nil)
            return
        }

        APIService.shared.getRecipes(url: url) { status, recipes in
            if status {
                completion(recipes, nil)
            }
            completion(nil, .invalidData)
        }
    }
}

extension RecipeRepository {

    /// build url with the app id, key, and list of ingredients parameters
    func getUrl(with ingredients: [String]) -> URL? {

        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.edamam.com"
        component.path = "/api/recipes/v2"
        component.queryItems = [
            URLQueryItem(name: "type", value: "public"),
            /// convert ingredients array to String with a comma between each ingredient
            URLQueryItem(name: "q", value: ingredients.joined(separator: ",")),
            URLQueryItem(name: "app_id", value: appId),
            URLQueryItem(name: "app_key", value: apiKey)
        ]
        return component.url
    }
}
