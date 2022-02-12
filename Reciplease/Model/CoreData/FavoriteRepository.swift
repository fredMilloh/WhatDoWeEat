//
//  FavoriteRepository.swift
//  Reciplease
//
//  Created by fred on 08/02/2022.
//

import Foundation
import CoreData

class FavoriteRepository {
    
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
            print("unable to save this recipe")
        }
    }

    func deleteFavorite(favorite: Favorite) {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        guard let favoriteUrl = favorite.urlDirections else { return }
        request.predicate = NSPredicate(format: "urlDirections == %@", "\(favoriteUrl)")
        do {
            let arrayResponse = try AppDelegate.viewContext.fetch(request)
            for item in arrayResponse {
                AppDelegate.viewContext.delete(item)
            }
            try AppDelegate.viewContext.save()
        } catch {
            print("unable to delete this recipe")
        }
    }
}
