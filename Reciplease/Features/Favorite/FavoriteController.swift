//
//  FavoriteController.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit

class FavoriteController: UIViewController {
    
    @IBOutlet weak var listFavoriteTableView: UITableView!

    private let repository = FavoriteRepository()
    private var favoritesRecipes = [Favorite]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Reciplease"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        listFavoriteTableView.delegate = self
        listFavoriteTableView.dataSource = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFavorite()
        listFavoriteTableView.reloadData()
    }

    private func getFavorite() {
        repository.getFavorite { favorites in

            for favorite in favorites {
                self.favoritesRecipes.append(favorite)
            }
        }
    }
}

// MARK: - TableView DataSource

extension FavoriteController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListRecipeCell else { return UITableViewCell() }

        let recipe = favoritesRecipes[indexPath.row]
        cell.listCellImageView.setImageFromURl(stringImageUrl: recipe.imageUrl ?? "")
        cell.configCell(name: recipe.name ?? "", ingredients: recipe.ingredients ?? "", yields: recipe.yield, time: recipe.totalTime)
        return cell
    }
}

//MARK: - TableView Delegate

extension FavoriteController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedRecipe = favoritesRecipes[indexPath.row]
//        guard let cell = listFavoriteTableView.cellForRow(at: indexPath) as? ListRecipeCell,
//              let imageSelectedRecipe = cell.listCellImageView.image
//        else { return }
//
//        guard let detailRecipe = self.storyboard?.instantiateViewController(withIdentifier: "DetailRecipeController") as? DetailRecipeController else { return }
//
//        detailRecipe.selectedRecipe = selectedRecipe
//        detailRecipe.selectedImage = imageSelectedRecipe
//        self.navigationController?.pushViewController(detailRecipe, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            RecipeManager.shared.removeRecipe(at: indexPath.row)
            listFavoriteTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

}
