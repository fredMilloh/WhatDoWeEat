//
//  SearchController.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit

class SearchController: UIViewController {

    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var ingredientTableView: UITableView!

    var listOfIngredients = [String]()
    lazy var ingredientManager = IngredientManager(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Reciplease"
        tabBarConfig()
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self
        ingredientTextField.delegate = self
    }

    @IBAction func addButton(_ sender: UIButton) {
        guard let inventory = ingredientTextField.text else { return }
        ingredientManager.createIngredientsArray(with: inventory)
        ingredientManager.addIngredientToList()
        ingredientTableView.reloadData()
        ingredientTextField.placeholder = "something else ..."
        ingredientTextField.resignFirstResponder()
    }

    @IBAction func clearIngredientList(_ sender: UIButton) {
        ingredientManager.clearListOfIngredients()
        ingredientTableView.reloadData()
    }

    @IBAction func searchRecipesButton(_ sender: UIButton) {
        RecipeRepository.shared.getRecipes(ingredients: listOfIngredients) { recipes, error in
            if let recipeError = error {
                print("search error : ", recipeError.localizedDescription)
            }
            guard let recipes = recipes?.hits else { return }
            self.toRecipesList(with: recipes)
        }
    }

    private func toRecipesList(with recipes: [Recipe]) {
        guard let recipesList = self.storyboard?.instantiateViewController(withIdentifier: "ListRecipes") as? ListRecipesController else { return }
        recipesList.listOfRecipes = recipes
        self.navigationController?.pushViewController(recipesList, animated: true)
    }
}

// MARK: - TableView DataSource

extension SearchController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfIngredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "IngredientCell",
            for: indexPath) as? IngredientCell else { return UITableViewCell() }

        let ingredient = listOfIngredients[indexPath.row]
        cell.configCell(withIngredient: ingredient)
        return cell
    }
}

// MARK: - TableView Delegate

extension SearchController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            ingredientManager.removeToList(at: indexPath.row)
            ingredientTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}
// MARK: - Protocol

extension SearchController: IngredientDelegate {

    func ingredientsList(with ingredients: [String]) {
        listOfIngredients = ingredients
    }
}

// MARK: - Textfield delegate

extension SearchController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        ingredientTextField.becomeFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientTextField.resignFirstResponder()
        return true
    }
}
