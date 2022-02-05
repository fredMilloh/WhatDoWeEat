//
//  IngredientManager.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import Foundation

protocol IngredientDelegate: AnyObject {
    func ingredientsList(with ingredients: [String])
}

class IngredientManager {

    weak var delegate: IngredientDelegate?

    init(delegate: IngredientDelegate) {
        self.delegate = delegate
    }

    var listOfIngredients: [String] = [] {
        didSet {
            delegate?.ingredientsList(with: listOfIngredients)
        }
    }

    var ingredients = [String]()

    func createIngredientsArray(with inventory: String) {
        let ingredient = inventory.split(separator: ",").map{ "\($0.trimmingCharacters(in: .whitespaces).localizedCapitalized)" }
        self.ingredients = ingredient
    }

    private func listAlreadyContains(this: String) -> Bool {
        return listOfIngredients.contains(this)
    }

    // MARK: - Create Update

    func addIngredientToList() {
        ingredients.forEach { ingredient in
            if !listAlreadyContains(this: ingredient)
                && ingredient.count > 1 {
                listOfIngredients.append(ingredient)
                listOfIngredients = listOfIngredients.sorted()
            }
        }
    }

    // MARK: - Delete

    func removeToList(at index: Int) {
        listOfIngredients.remove(at: index)
    }

    func clearListOfIngredients() {
        listOfIngredients.removeAll()
    }
}
