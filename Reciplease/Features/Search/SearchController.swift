//
//  SearchController.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit

class SearchController: TabBarController {

    @IBOutlet weak var ingredientTextField: UITextField!
    @IBOutlet weak var ingredientTableView: UITableView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!

    var recipeRepository = RecipeRepository.shared
    lazy var ingredientManager = IngredientViewModel(delegate: self, alertDelegate: self)

    var listOfIngredients = [String]()

    var inventory: String {
        guard let inventory = ingredientTextField.text else { return ""}
        return inventory
    }

    var url: URL {
        guard let url = recipeRepository.getUrl(with: listOfIngredients)
        else { return URL(fileURLWithPath: "www") }
        return url
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Reciplease"
        setTextField()
        buttonsAreAvaiables()
        tabBarConfig()
        ingredientTableView.delegate = self
        ingredientTableView.dataSource = self
        ingredientTextField.delegate = self
    }

// MARK: - Buttons Actions

    @IBAction func addButton(_ sender: UIButton) {
        ingredientManager.createIngredientsArray(with: inventory)
        ingredientManager.addIngredientToList()
        buttonsAreAvaiables()
        ingredientTextField.text = "One more thing ? ..."
        ingredientTableView.reloadData()
        ingredientTextField.resignFirstResponder()
    }

    @IBAction func clearIngredientList(_ sender: UIButton) {
        AskConfirmation() { [self] result in
            if result {
                ingredientManager.clearListOfIngredients()
                ingredientTableView.reloadData()
                buttonsAreAvaiables()
                presentInfo(message: "Ingredients have been removed")
            }
        }
    }

    @IBAction func searchRecipesButton(_ sender: UIButton) {
        toRecipesList()
    }

// MARK: - Convenience Methods

    private func toRecipesList() {

        let storyboard = UIStoryboard(name: "ListRecipesController", bundle: Bundle.main)

        guard let recipesList = storyboard.instantiateViewController(withIdentifier: "ListRecipesController")
                as? ListRecipesController else { return }
        recipesList.url = url
        self.navigationController?.pushViewController(recipesList, animated: true)
    }

    private func setTextField() {
        ingredientTextField.attributedPlaceholder = NSAttributedString(
            string: "Lemon, Cheese, Sausages,...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.clearStack]
        )
        ingredientTextField.setBottomBorder()
    }

    private func buttonsAreAvaiables() {
        searchButton.alpha = listOfIngredients.isEmpty ? 0.5 : 1
        clearButton.alpha = listOfIngredients.isEmpty ? 0.5 : 1
        addButton.alpha = listOfIngredients.isEmpty ? 0.5 : 1
        searchButton.isEnabled = listOfIngredients.isEmpty ? false : true
        clearButton.isEnabled = listOfIngredients.isEmpty ? false : true
        addButton.isEnabled = listOfIngredients.isEmpty ? false : true
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

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath
        ) {
        if editingStyle == .delete {
            AskConfirmation() { [self] result in
                if result {
                    ingredientManager.removeToList(at: indexPath.row)
                    ingredientTableView.deleteRows(at: [indexPath], with: .automatic)
                    ingredientTableView.reloadData()
                    buttonsAreAvaiables()
                    presentInfo(message: "This ingredient has been removed")
                }
            }
        }
    }
}

// MARK: - Textfield Delegate

extension SearchController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        ingredientTextField.becomeFirstResponder()
        ingredientTextField.placeholder = ""
        addButton.alpha = 1
        addButton.isEnabled = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        ingredientTextField.resignFirstResponder()
        return true
    }

    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        ingredientTextField.resignFirstResponder()
        ingredientTextField.text = "One more thing ? ..."
    }
}

// MARK: - Protocol Ingredients

extension SearchController: IngredientDelegate {

    func ingredientsList(with ingredients: [String]) {
        listOfIngredients = ingredients
    }
}
