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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var searchButton: UIButton!

    var listOfIngredients = [String]()
    lazy var ingredientManager = IngredientManager(delegate: self)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Reciplease"
        setTextField()
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
        ingredientTextField.resignFirstResponder()
    }

    @IBAction func clearIngredientList(_ sender: UIButton) {
        ingredientManager.clearListOfIngredients()
        ingredientTableView.reloadData()
    }

    @IBAction func searchRecipesButton(_ sender: UIButton) {
        searchButton.isHidden = true
        activityIndicator.isHidden = false

        RecipeRepository.shared.getRecipes(ingredients: listOfIngredients) { [self] recipes, error in
            searchButton.isHidden = false
            activityIndicator.isHidden = true

            guard let recipes = recipes else { return }
            self.toRecipesList(with: recipes)
            #if DEBUG
            print("nextUrl", recipes.nextPage)
            print("count", recipes.count)
            #endif
        }
    }

    private func toRecipesList(with recipes: (RecipePage)) {
        let storyboard = UIStoryboard(name: "ListRecipes", bundle: Bundle.main)
        guard let recipesList = storyboard.instantiateViewController(withIdentifier: "ListRecipes") as? ListRecipesController else { return }
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

    func presentAlert(message alertError: RecipeError) {
        let alert = UIAlertController(
            title: "Oups...",
            message: alertError.localizedDescription,
            preferredStyle: .alert
        )
        let errorAction = UIAlertAction(
            title: "ok",
            style: .cancel
        )
        alert.addAction(errorAction)
        present(alert, animated: true)
    }

    func ingredientsList(with ingredients: [String]) {
        listOfIngredients = ingredients
    }
}

// MARK: - Textfield delegate

extension SearchController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        ingredientTextField.becomeFirstResponder()
        ingredientTextField.placeholder = ""
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientTextField.resignFirstResponder()
        return true
    }

    private func setTextField() {
        ingredientTextField.attributedPlaceholder = NSAttributedString(
            string: "Lemon, Cheese, Sausages,...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.clearStack]
        )
        ingredientTextField.setBottomBorder()
    }
}
