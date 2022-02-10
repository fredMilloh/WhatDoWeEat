//
//  FavoriteRepository.swift
//  Reciplease
//
//  Created by fred on 08/02/2022.
//

import Foundation
import CoreData

class FavoriteRepository {

    private let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack = CoreDataStack.sharedInstance) {
        self.coreDataStack = coreDataStack
    }
    
    func getFavorite(completion:([Favorite]) -> Void) {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        do {
            let favorites = try coreDataStack.viewContext.fetch(request)
            completion(favorites)
        } catch {
            completion([])
        }

    }

    func saveFavorite(recipe: Favorite, completion: () -> Void) {

        let favorite = Favorite(context: coreDataStack.viewContext)

        favorite.name = recipe.name
        favorite.imageUrl = recipe.imageUrl
        favorite.ingredients = recipe.ingredients
        favorite.urlDirections = recipe.urlDirections
        favorite.yield = recipe.yield
        favorite.totalTime = recipe.totalTime
        do {
            try coreDataStack.viewContext.save()
            completion()
        } catch {
            print("unable to save this recipe")
        }
    }
}
