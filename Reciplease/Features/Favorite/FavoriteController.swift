//
//  FavoriteController.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit

class FavoriteController: UIViewController {
    
    @IBOutlet weak var listFavoriteTableView: UITableView!

    var listOfFavoriteRecipes = RecipeManager.shared.favoriteRecipes


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Reciplease"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        listFavoriteTableView.delegate = self
        listFavoriteTableView.dataSource = self

    }
}

// MARK: - TableView DataSource

extension FavoriteController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfFavoriteRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListRecipeCell else { return UITableViewCell() }

        let recipe = self.listOfFavoriteRecipes[indexPath.row]
        cell.configCell(name: recipe.name, ingredients: recipe.ingredients, yields: recipe.yield, time: recipe.totalTime)
        return cell
    }
}

//MARK: - TableView Delegate

extension FavoriteController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            listOfFavoriteRecipes.remove(at: indexPath.row)
            listFavoriteTableView.deleteRows(at: [indexPath], with: .fade)
                } 
    }

}
