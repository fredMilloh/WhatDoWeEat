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
    }
}

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
