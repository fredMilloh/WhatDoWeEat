//
//  RecipeError.swift
//  Reciplease
//
//  Created by fred on 07/02/2022.
//

import Foundation
import Alamofire

enum RecipeError: LocalizedError {
    case fetchError
    case invalidData
    case incorrectElement
    case remove
    case noFavorite
    case saveCoreData
    case deleteCoreData

    var errorDescription: String? {
        switch self {
        case .fetchError:
            return "Sorry, no recipe was found, try with other ingredients. Check your network connection if necessary."
        case .invalidData:
            return "There is no corresponding recipe. Add an ingredient if necessary."
        case .incorrectElement:
            return "Only words and comma are correct."
        case .remove:
            return "The element has been removed from the list"
        case .noFavorite:
            return "You don't have a favorite recipe yet.\n\n To complete your list, enter ingredients, then start a recipe search.\n\n When the list is displayed, select a recipe.\n\n Click on hollow star at the top right of the recipe details page.\n\n The star will turn completely yellow \("⭐️") \n\n If you click on it again, the recipe will be removed from the favorites."
        case .saveCoreData:
            return "This recipe has been successfully added to your favorites"
        case .deleteCoreData:
            return "This recipe has been removed from the favorites list"
        }
    }
}
