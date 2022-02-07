//
//  RecipeManager.swift
//  Reciplease
//
//  Created by fred on 06/02/2022.
//

import Foundation

class RecipeManager {

    static let shared = RecipeManager()
    private init() {}

    private(set) var favoriteRecipes = [Recipe]()

    func addToFavorite(recipe: Recipe) {
        favoriteRecipes.append(recipe)
    }

    func removeRecipe(at index: Int) {
        favoriteRecipes.remove(at: index)
    }
}
