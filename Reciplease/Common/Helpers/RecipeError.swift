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
    case unknow
    case incorrectElement
    case remove
    case saveCoreData
    case deleteCoreData

    var errorDescription: String? {
        switch self {
        case .fetchError:
            return "Sorry, no recipe was found, try with other ingredients. Check your network connection if necessary."
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
            return "This recipe has been removed from the favorites list"
        }
    }
}
