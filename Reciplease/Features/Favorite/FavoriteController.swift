//
//  FavoriteController.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit

class FavoriteController: TabBarController {

    @IBOutlet weak var listFavoriteTableView: UITableView!

    let favoriteRepository = FavoriteRepository()
    var favoritesRecipes = [Favorite]()

    var alertMessage: RecipeError = .saveCoreData {
        didSet {
            presentAlert(message: alertMessage.localizedDescription)
        }
    }

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

// MARK: - Get favorites recipes from CoreData

    func getFavorite() {
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
        cell.configCell(with: recipe)
        return cell
    }
}

//MARK: - TableView Delegate

extension FavoriteController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "DetailRecipeController", bundle: Bundle.main)
        let favoriteRecipe = favoritesRecipes[indexPath.row]

        guard let selectedRecipe = convertionIntoRecipeFrom(favorite: favoriteRecipe),
              let detailRecipe = storyboard.instantiateViewController(withIdentifier: "DetailRecipeController")
                as? DetailRecipeController else { return }

        detailRecipe.selectedRecipe = selectedRecipe
        self.navigationController?.pushViewController(detailRecipe, animated: true)
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            AskConfirmation() { [self] result in
                if result {
                    guard let recipeUrl = favoritesRecipes[indexPath.row].urlDirections else { return }
                    favoriteRepository.deleteFavorite(recipeUrl: recipeUrl)
                    favoritesRecipes.remove(at: indexPath.row)
                    listFavoriteTableView.deleteRows(at: [indexPath], with: .fade)
                    alertMessage = .remove
                    getFavorite()
                    listFavoriteTableView.reloadData()
                }
            }
        }
    }
}

// MARK: - Convert Favorite to Recipe

extension FavoriteController {

    func convertionIntoRecipeFrom(favorite: Favorite) -> Recipe? {
        guard let name = favorite.name,
              let ingredients = favorite.ingredients,
              let urlDirections = favorite.urlDirections,
              let ingredientLines = favorite.ingredientLines,
              let imageUrl = favorite.imageUrl
        else { return nil }
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
