//
//  RecipeRepository.swift
//  Reciplease
//
//  Created by fred on 17/02/2022.
//

import Foundation

typealias RecipePageOrError = (_ recipe: (RecipePage)?, _ error: RecipeError?) -> Void

/// Protocol to mock the method
protocol RecipeRepositoryDelegate {
    func getRecipes(with url: URL, callback: @escaping RecipePageOrError)
}

class RecipeRepository: RecipeRepositoryDelegate {

    static var shared = RecipeRepository()
    private init() {}

    private let client = APIService.shared
    var getDelegate: RecipeRepositoryDelegate?
    
    var apiKey: String = "7"
    var appId: String = "17f51d8a"

    /// to test getUrl method with a fake apiKey and getRecipes method
    init(apiKey: String, appId: String, getDelegate: RecipeRepositoryDelegate) {
        self.apiKey = apiKey
        self.appId = appId
        self.getDelegate = getDelegate
    }

// MARK: - Get Recipes and Url

    /// decodes the data received from the APIService request, and passes them on by callback
    func getRecipes(with url: URL, callback: @escaping RecipePageOrError) {
        client.get(url: url) { [self] data, error in
            if let data = data {
                let recipesPage = parse(data)
                callback(recipesPage, nil)
            } else {
                callback(nil, error)
            }
        }
    }

    /// build url with the app id, key, and list of ingredients parameters
    func getUrl(with ingredients: [String]) -> URL? {

        var component = URLComponents()
        component.scheme = "https"
        component.host = "api.edamam.com"
        component.path = "/api/recipes/v2"
        component.queryItems = [
            URLQueryItem(name: "type", value: "public"),
            /// convert ingredients array to String with a comma between each ingredient
            URLQueryItem(name: "q", value: ingredients.joined(separator: ",").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)),
            URLQueryItem(name: "app_id", value: appId),
            URLQueryItem(name: "app_key", value: apiKey)
        ]
        return component.url
    }
}

// MARK: - Decode Recipe Data

extension RecipeRepository {

    func parse(_ data: Data) -> RecipePage? {
        do {
            let dataSet = try JSONDecoder().decode(RecipePage.self, from: data)
            return dataSet
        } catch {
            return nil
        }
    }
}
