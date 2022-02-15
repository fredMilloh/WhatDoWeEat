//
//  UrlParse.swift
//  Reciplease
//
//  Created by fred on 15/02/2022.
//

import Foundation

class ParserRepository {

    static var shared = ParserRepository()
    private init() {}

    // MARK: - Url Request

    var apiKey: String = "7"
    var appId: String = "17f51d8a"
    
    /// to test getUrl method with a fake apiKey
    init(apiKey: String, appId: String) {
        self.apiKey = apiKey
        self.appId = appId
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
            URLQueryItem(name: "q", value: ingredients.joined(separator: ",")),
            URLQueryItem(name: "app_id", value: appId),
            URLQueryItem(name: "app_key", value: apiKey)
        ]
        return component.url
    }
}

    // MARK: - Recipe Data

extension ParserRepository {

    func parse(_ data: Data?) -> RecipePage {
        guard let data = data,
              let dataSet = try? JSONDecoder().decode(RecipePage.self, from: data) else {
                  return RecipePage(nextPage: "", counter: 0, count: 0, hits: [])
        }
        return dataSet
    }
}
