//
//  SearchController.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit

class SearchController: UIViewController {

    var listOfIngredients = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarConfig()
        // Do any additional setup after loading the view.
    }

}

// MARK: - Protocol

extension SearchController: IngredientDelegate {

func ingredientsList(with ingredients: [String]) {
    listOfIngredients = ingredients
}
}
