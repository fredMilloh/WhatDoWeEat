//
//  FavoriteRepository.swift
//  Reciplease
//
//  Created by fred on 08/02/2022.
//

import Foundation
import CoreData

class FavoriteRepository: TabBarController {
    
    func getFavorite(completion:([Favorite]) -> Void) {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        do {
            let favorites = try AppDelegate.viewContext.fetch(request)
            completion(favorites)
        } catch {
            completion([])
        }
    }

    func saveFavorite(recipe: Recipe, completion: () -> Void) {

        let favorite = Favorite(context: AppDelegate.viewContext)

        favorite.name = recipe.name
        favorite.imageUrl = recipe.imageUrl
        favorite.ingredients = recipe.ingredients
        favorite.urlDirections = recipe.urlDirections
        favorite.yield = recipe.yield
        favorite.totalTime = recipe.totalTime
        favorite.ingredientLines = recipe.ingredientLines
        do {
            try AppDelegate.viewContext.save()
            completion()
        } catch {
            presentInfo(message: "Unable to save this recipe")
        }
    }

    func deleteFavorite(recipeUrl: String) {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "urlDirections == %@", "\(recipeUrl)")
        do {
            let arrayResponse = try AppDelegate.viewContext.fetch(request)
            for item in arrayResponse {
                AppDelegate.viewContext.delete(item)
            }
            try AppDelegate.viewContext.save()
        } catch {
            presentInfo(message: "Unable to delete this recipe")
        }
    }

    func isFavorite(recipeUrl: String) -> Bool {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "urlDirections == %@", "\(recipeUrl)")
        do {
            let arrayResponse = try AppDelegate.viewContext.fetch(request)
            for _ in arrayResponse {
                return true
            }
        } catch {
            presentInfo(message: "Unable to find this recipe")
        }
        return false
    }
}
