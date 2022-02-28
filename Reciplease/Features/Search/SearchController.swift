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

    lazy var viewModel = SearchViewModel(delegate: self, alertDelegate: self)

    var listOfIngredients = [String]()
    static let identifier = "SearchController"
    let firstPlaceholder = "Lemon, Cheese, Sausages,..."
    let oneMoreThing = "One more thing ? ..."

    var inventory: String {
        guard let inventory = ingredientTextField.text else { return "" }
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
        viewModel.createIngredientsArray(with: inventory)
        if viewModel.presentAlert != .incorrectElement {
            buttonsAreAvaiables()
            ingredientTextField.text = oneMoreThing
            ingredientTextField.resignFirstResponder()
            ingredientTableView.reloadData()
        } else if viewModel.presentAlert == .incorrectElement {
            ingredientTextField.text = ""
        }
    }

    @IBAction func clearIngredientList(_ sender: UIButton) {
        self.presentDeletePopUp(deleteAction: { [weak self] in
            guard let self = self else { return }
            self.viewModel.clearListOfIngredients()
            self.ingredientTableView.reloadData()
            self.buttonsAreAvaiables()
        })
    }

    @IBAction func searchRecipesButton(_ sender: UIButton) {
        toRecipesList()
    }

// MARK: - Convenience Methods

    private func toRecipesList() {

        let storyboard = UIStoryboard(name: ListRecipesController.identifier, bundle: Bundle.main)

        guard let recipesList = storyboard.instantiateViewController(withIdentifier: ListRecipesController.identifier)
                as? ListRecipesController else { return }
        recipesList.url = url
        self.navigationController?.pushViewController(recipesList, animated: true)
    }

    private func setTextField() {
        ingredientTextField.attributedPlaceholder = NSAttributedString(
            string: firstPlaceholder,
            attributes: [.foregroundColor: UIColor.clearStack]
        )
        ingredientTextField.setBottomBorder()
    }

    private func buttonsAreAvaiables() {
        let alpha = listOfIngredients.isEmpty ? 0.5 : 1
        let isEnabled = listOfIngredients.isEmpty ? false : true

        [searchButton, clearButton, addButton].forEach {
            $0?.alpha = alpha
            $0?.isEnabled = isEnabled
        }
    }
}

    // MARK: - TableView DataSource

extension SearchController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfIngredients.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: IngredientCell.identifier,
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
            self.presentDeletePopUp(deleteAction: { [weak self] in
                guard let self = self else { return }
                self.viewModel.removeToList(at: indexPath.row)
                self.ingredientTableView.deleteRows(at: [indexPath], with: .automatic)
                self.ingredientTableView.reloadData()
                self.buttonsAreAvaiables()
            })
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
        ingredientTextField.text = oneMoreThing
    }
}

// MARK: - Protocol Ingredients

extension SearchController: IngredientDelegate {

    func ingredientsList(with ingredients: [String]) {
        listOfIngredients = ingredients
    }
}
