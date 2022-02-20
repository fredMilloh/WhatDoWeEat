//
//  RecipeError.swift
//  Reciplease
//
//  Created by fred on 07/02/2022.
//

import Foundation

enum RecipeError: Error {
    case fetchError
    case invalidData
    case unknow
    case incorrectElement
    case remove
    case saveCoreData
    case deleteCoreData

    var errorDescription: String? {
        switch self {
        case .fetchError:
            return "An error occurred while retrieving the recipes"
        case .invalidData:
            return "There is no corresponding recipe. Add an ingredient if necessary."
        case .unknow:
            return "An error has occurred... Try again."
        case .incorrectElement:
            return "Only words and comma are correct."
        case .remove:
            return "The element has been removed from the list"
        case .saveCoreData:
            return "This recipe has been successfully added to your favorites"
        case .deleteCoreData:
            return "This recipe has been removed"
        }
    }
}
