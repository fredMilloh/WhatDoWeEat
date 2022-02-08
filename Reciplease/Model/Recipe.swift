//
//  Recipe.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import Foundation

struct RecipePage: Decodable {
    var nextPage: String
    var count: Int
    let hits: [Recipe]
}

struct Recipe: Decodable {
    var name: String
    var imageUrl: String
    var urlDirections: String
    var yield: Double
    var ingredientLines: [String]
    var ingredients: String
    var totalTime: Double
}

extension RecipePage {

    enum MainKeys: String, CodingKey {
        case nextLink = "_links"
        case count = "count"
        case hits = "hits"

        enum HitsKeys: String, CodingKey {
            case recipe = "recipe"

            enum RecipeKeys: String, CodingKey {
                case name = "label"
                case imageUrl = "image"
                case urlDirections = "url"
                case yield = "yield"
                case ingredientLines = "ingredientLines"
                case ingredients = "ingredients"

                enum IngredientsKeys: String, CodingKey {
                    case ingredientName = "food"
                }
                case totalTime = "totalTime"
            }
        }

        enum LinkKeys: String, CodingKey {
            case next = "next"

            enum NextKeys: String, CodingKey {
                case nextUrl = "href"
            }
        }
    }

    init(from decoder: Decoder) throws {
        /// main container
        let container = try decoder.container(keyedBy: MainKeys.self)

        /// container array hits
        var hitsArray = try container.nestedUnkeyedContainer(forKey: .hits)

        var recipes = [Recipe]()

        while !hitsArray.isAtEnd {
            /// container of one recipe
            let hitContainer = try hitsArray.nestedContainer(keyedBy: MainKeys.HitsKeys.self)
            /// recipe container
            let recipeContainer = try hitContainer.nestedContainer(keyedBy: MainKeys.HitsKeys.RecipeKeys.self, forKey: .recipe)

            let name = try recipeContainer.decode(String.self, forKey: .name)
            let imageUrl = try recipeContainer.decode(String.self, forKey: .imageUrl)
            let urlDirections = try recipeContainer.decode(String.self, forKey: .urlDirections)
            let yield = try recipeContainer.decode(Double.self, forKey: .yield)
            let ingredientsLines = try recipeContainer.decode([String].self, forKey: .ingredientLines)

            /// ingredient name
            var ingredientsArray = try recipeContainer.nestedUnkeyedContainer(forKey: .ingredients)

            var ingredientNames = ""
            while !ingredientsArray.isAtEnd {
                let ingredientContainer = try ingredientsArray.nestedContainer(keyedBy: MainKeys.HitsKeys.RecipeKeys.IngredientsKeys.self)
                let ingredientName = try ingredientContainer.decode(String.self, forKey: .ingredientName)
                ingredientNames += ingredientNames == "" ? ingredientName : ", \(ingredientName)"
            }


            let totalTime = try recipeContainer.decode(Double.self, forKey: .totalTime)

            let recipe = Recipe(name: name, imageUrl: imageUrl, urlDirections: urlDirections, yield: yield, ingredientLines: ingredientsLines, ingredients: ingredientNames, totalTime: totalTime)
            recipes.append(recipe)
        }
        self.hits = recipes

        /// count
        self.count = try container.decode(Int.self, forKey: .count)
        
        /// link container
        let linkContainer = try container.nestedContainer(keyedBy: MainKeys.LinkKeys.self, forKey: .nextLink)
        let nextContainer = try linkContainer.nestedContainer(keyedBy: MainKeys.LinkKeys.NextKeys.self, forKey: .next)
        self.nextPage = try nextContainer.decode(String.self, forKey: .nextUrl)

    }
}
