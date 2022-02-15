//
//  FavoriteController.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit

class FavoriteController: TabBarController {

    @IBOutlet weak var listFavoriteTableView: UITableView!

    private let favoriteRepository = FavoriteRepository()
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
        favoritesRecipes = [Favorite]()
        favoriteRepository.getFavorite { favorites in

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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
                as? ListRecipeCell else { return UITableViewCell() }

        let recipe = convertionIntoRecipeFrom(favorite: favoritesRecipes[indexPath.row])
        if recipe.imageUrl != nil {
            guard let url = recipe.imageUrl else { return UITableViewCell() }
            cell.listCellImageView.setImageFromURl(stringImageUrl: url)
        } else {
            cell.listCellImageView.image = UIImage(named: "DefaultImage")
        }
        cell.configCell(with: recipe)
        return cell
    }
}

//MARK: - TableView Delegate

extension FavoriteController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favoriteRecipe = favoritesRecipes[indexPath.row]
        let selectedRecipe = convertionIntoRecipeFrom(favorite: favoriteRecipe)

        guard let cell = listFavoriteTableView.cellForRow(at: indexPath) as? ListRecipeCell,
              let imageSelectedRecipe = cell.listCellImageView.image
        else { return }

        let storyboard = UIStoryboard(name: "DetailRecipe", bundle: Bundle.main)
        guard let detailRecipe = storyboard.instantiateViewController(withIdentifier: "DetailRecipe")
                as? DetailRecipeController else { return }

        detailRecipe.selectedRecipe = selectedRecipe
        detailRecipe.selectedImage = imageSelectedRecipe
        self.navigationController?.pushViewController(detailRecipe, animated: true)
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath
        ) {
        if editingStyle == .delete {
            AskConfirmation(title: "Are you sure ?",
                            message: "Remove this recipe")
            { [self] result in
                if result {
                    guard let recipeUrl = favoritesRecipes[indexPath.row].urlDirections else { return }
                    favoriteRepository.deleteFavorite(recipeUrl: recipeUrl)
                    favoritesRecipes.remove(at: indexPath.row)
                    listFavoriteTableView.deleteRows(at: [indexPath], with: .fade)
                    presentAlert(message: .remove)
                    getFavorite()
                    listFavoriteTableView.reloadData()
                }
            }
        }
    }
}

extension FavoriteController {

    func convertionIntoRecipeFrom(favorite: Favorite) -> Recipe {
        guard let name = favorite.name,
              let ingredients = favorite.ingredients,
              let urlDirections = favorite.urlDirections,
              let ingredientLines = favorite.ingredientLines,
              let imageUrl = favorite.imageUrl
        else { return Recipe(name: "",
                             imageUrl: "",
                             urlDirections: "",
                             yield: 0,
                             ingredientLines: [""],
                             ingredients: "",
                             totalTime: 0)
        }
        let yield = favorite.yield
        let totalTime = favorite.totalTime

        return Recipe(name: name,
                      imageUrl: imageUrl,
                      urlDirections: urlDirections,
                      yield: yield,
                      ingredientLines: ingredientLines,
                      ingredients: ingredients,
                      totalTime: totalTime
        )
    }
}
