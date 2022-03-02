//
//  RecipeRepository.swift
//  Reciplease
//
//  Created by fred on 17/02/2022.
//

import Foundation

typealias RecipePageOrError = (_ recipe: (RecipePage)?, _ error: RecipeError?) -> Void

/// Protocol to mock the method
protocol RecipeRepositoryProtocol {
    func getRecipes(with url: URL, callback: @escaping RecipePageOrError)
}

class RecipeRepositoryFetcher: RecipeRepositoryProtocol {

   private let client = APIService.shared

   /// Decodes the data received from the APIService request, and passes them on by callback
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

// MARK: - Decode Recipe Data

   func parse(_ data: Data) -> RecipePage? {
       do {
           let dataSet = try JSONDecoder().decode(RecipePage.self, from: data)
           return dataSet
       } catch {
           return nil
       }
   }
}

class RecipeRepository {

   private let repositoryFetcher: RecipeRepositoryFetcher

   init(repositoryFetcher: RecipeRepositoryFetcher) {
      self.repositoryFetcher = repositoryFetcher
    }

   var apiKey: String = (Bundle.main.infoDictionary?["API_KEY"] as? String ?? "")
   var appId: String = (Bundle.main.infoDictionary?["ID_APP_KEY"] as? String ?? "")

// MARK: - Get Recipes and Url

    /// Decodes the data received from the APIService request, and passes them on by callback
    func getRecipes(with url: URL, callback: @escaping RecipePageOrError) {
       repositoryFetcher.getRecipes(with: url, callback: callback)
    }

    /// Build url with the app id, key, and list of ingredients parameters
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
