//
//  DetailRecipeController.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit
import SafariServices

class DetailRecipeController: UIViewController {

    @IBOutlet weak var detailTimeView: TimeView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var detailRecipeImageView: UIImageView!
    @IBOutlet weak var detailRecipeNameLabel: UILabel!

    var selectedRecipe: Recipe!
    var selectedImage: UIImage!
    private var favoriteButton: UIBarButtonItem?
    private let favoriteRepository = FavoriteRepository()
    private var isFavorite = false
    private lazy var recipeUrl = selectedRecipe.urlDirections

    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailRecipeImageView.makeGradient(to: detailRecipeImageView)
        configureNavigationItem()
    }

    @IBAction func getDirectionsButton(_ sender: UIButton) {
        let directionsLink = selectedRecipe.urlDirections
        guard let directionsUrl = URL(string: directionsLink) else { return }
        let directionsView = SFSafariViewController(url: directionsUrl)
        present(directionsView, animated: true, completion: nil)
    }

    private func configureNavigationItem() {
        favoriteButton = UIBarButtonItem(image: UIImage(systemName: "star"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(favoriteButtonPressed))
        favoriteButton?.tintColor = .yellow
        if favoriteRepository.isFavorite(recipeUrl: recipeUrl) {
            isFavorite = true
            favoriteButton?.image = UIImage(systemName: "star.fill")
        }
        navigationItem.rightBarButtonItem = favoriteButton
    }

    @objc private func favoriteButtonPressed() {
        if isFavorite {
            favoriteButton?.image = UIImage(systemName: "star")
            favoriteRepository.deleteFavorite(recipeUrl: recipeUrl)
        } else {
            favoriteRepository.saveFavorite(recipe: selectedRecipe) {
                favoriteButton?.image = UIImage(systemName: "star.fill")
            }
        }
    }
}

extension DetailRecipeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedRecipe.ingredientLines.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell",
                                                       for: indexPath
            ) as? IngredientCell else {
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
