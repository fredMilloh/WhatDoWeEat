//
//  DetailRecipeController.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit
import SafariServices

class DetailRecipeController: TabBarController {

    @IBOutlet weak var detailTimeView: TimeView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var detailRecipeImageView: UIImageView!
    @IBOutlet weak var detailRecipeNameLabel: UILabel!

    var selectedRecipe: Recipe?

    private let favoriteRepository = FavoriteRepository()
    static let identifier = detailRecipeController
    private var favoriteButton: UIBarButtonItem?
    private var isFavorite = false

    var alertInfo: String = listRemoved {
        didSet {
            presentInfo(message: alertInfo)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.dataSource = self
        detailRecipeImageView.makeGradient(to: detailRecipeImageView)
        configureNavigationItem()
        configHeaderView()
    }

// MARK: - To directions web page

    @IBAction func getDirectionsButton(_ sender: UIButton) {
        guard let directionsLink = selectedRecipe?.urlDirections else { return }
        guard let directionsUrl = URL(string: directionsLink) else { return }
        let directionsView = SFSafariViewController(url: directionsUrl)
        present(directionsView, animated: true, completion: nil)
    }

// MARK: - Favorite button choice

    func configureNavigationItem() {
        favoriteButton = UIBarButtonItem(image: UIImage(systemName: noFavorite),
                                         style: .plain,
                                         target: self,
                                         action: #selector(favoriteButtonPressed))
        favoriteButton?.tintColor = .yellow
        guard let recipeUrl = selectedRecipe?.urlDirections else { return }
        if favoriteRepository.isFavorite(recipeUrl: recipeUrl) {
            isFavorite = true
            favoriteButton?.image = UIImage(systemName: favorite)
        }
        navigationItem.rightBarButtonItem = favoriteButton
    }

    @objc private func favoriteButtonPressed() {
        if isFavorite {
            favoriteButton?.image = UIImage(systemName: noFavorite)
            AskConfirmation() { [self] result in
                if result {
                    guard let recipeUrl = selectedRecipe?.urlDirections else { return}
                    favoriteRepository.deleteFavorite(recipeUrl: recipeUrl)
                    alertInfo = recipeNotFavorite
                }
            }
        } else {
            guard let selectedRecipe = selectedRecipe else { return }
            favoriteRepository.saveFavorite(recipe: selectedRecipe) {
                favoriteButton?.image = UIImage(systemName: favorite)
                alertInfo = recipeIsFavorite
            }
        }
    }

// MARK: - TableView Header

    func configHeaderView() {
        guard let selectedRecipe = selectedRecipe else { return }
        let yieldsString = String(selectedRecipe.yield.withoutDecimal())
        let timeString = (selectedRecipe.totalTime * 60).convertToString(style: .abbreviated)
        detailTimeView.yieldLabel.text = yieldsString
        detailTimeView.timeLabel.text = timeString
        detailRecipeNameLabel.text = selectedRecipe.name

        if let url = selectedRecipe.imageUrl {
            detailRecipeImageView.setImageFromURl(stringImageUrl: url)
        } else {
            detailRecipeImageView.image = UIImage(named: defaultRecipeImage)
        }
    }
}

// MARK: - TableView DataSource

extension DetailRecipeController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ingredientsCount = selectedRecipe?.ingredientLines.count else { return 0 }
        return ingredientsCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: IngredientCell.identifier, for: indexPath) as? IngredientCell, let selectedRecipe = selectedRecipe else { return UITableViewCell() }

        let ingredient = selectedRecipe.ingredientLines[indexPath.row]
        cell.configCell(withIngredient: ingredient)
        return cell
    }
}
