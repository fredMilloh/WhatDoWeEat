//
//  DetailRecipeController.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit

class DetailRecipeController: UIViewController {

    @IBOutlet weak var detailTimeView: TimeView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var detailRecipeImageView: UIImageView!
    @IBOutlet weak var detailRecipeNameLabel: UILabel!

    var selectedRecipe: Recipe!
    var selectedImage: UIImage!
    private var favoriteButton: UIBarButtonItem?
    private var recipeManager = RecipeManager.shared
    lazy var favorites = recipeManager.favoriteRecipes
    private var isFavorite = false

    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailRecipeImageView.makeGradient(to: detailRecipeImageView)
        configureNavigationItem()
        checkFavorite()
    }
    
    @IBAction func getDirectionsButton(_ sender: UIButton) {
    }

    private func configureNavigationItem() {
        favoriteButton = UIBarButtonItem(image: UIImage(systemName: "star"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(favoriteButtonPressed))
        favoriteButton?.tintColor = .yellow
        if isFavorite {
            favoriteButton?.image = UIImage(systemName: "star.fill")
        }
        navigationItem.rightBarButtonItem = favoriteButton
    }

    @objc private func favoriteButtonPressed() {
        if !isFavorite {
            RecipeManager.shared.addToFavorite(recipe: selectedRecipe)
            favoriteButton?.image = UIImage(systemName: "star.fill")
        } else {
            favoriteButton?.image = UIImage(systemName: "star")
        }

    }
    /// avoids adding a recipe several times in favorites
    private func checkFavorite() {
        favorites.forEach { favoriteRecipe in
            if selectedRecipe.name == favoriteRecipe.name {
                isFavorite = true
            }
        }
    }
}

extension DetailRecipeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedRecipe.ingredientLines.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientCell else {
            return UITableViewCell()
        }

        let yieldsString = String(selectedRecipe.yield.withoutDecimal())
        let timeString = (selectedRecipe.totalTime * 60).convertToString(style: .abbreviated)
        detailTimeView.yieldLabel.text = yieldsString
        detailTimeView.timeLabel.text = timeString
        
        detailRecipeImageView.image = selectedImage != UIImage() ? selectedImage : UIImage(named: "DefaultImage")
        detailRecipeNameLabel.text = selectedRecipe.name

        let ingredient = selectedRecipe.ingredientLines[indexPath.row]

        cell.configCell(withIngredient: ingredient)

        return cell
    }


}
extension DetailRecipeController: UITableViewDelegate {

}
