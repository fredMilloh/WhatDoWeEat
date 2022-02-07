//
//  RecipeError.swift
//  Reciplease
//
//  Created by fred on 07/02/2022.
//

import Foundation

enum RecipeError: LocalizedError {
    case invalidData
    case unknow

    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "There is no corresponding recipe. Add an ingredient if necessary."
        case .unknow:
            return "Oups... An error has occurred... Try again."
        }
    }
}
