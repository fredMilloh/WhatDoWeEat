//
//  RecipeRepository.swift
//  Reciplease
//
//  Created by fred on 07/02/2022.
//

import Foundation

typealias RecipePageOrError = (_ recipe: (RecipePage)?, _ error: RecipeError?) -> Void

protocol ListViewModelDelegate: AnyObject {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with reason: String)
}

class ListRecipesViewModel {

    // MARK: - Properties

    private let client = APIService.shared
    private var recipeRepository = RecipeRepository.shared
    weak var delegate: ListViewModelDelegate?

    init(delegate: ListViewModelDelegate) {
        self.delegate = delegate
    }

    var recipes: [Recipe] = []
    var nextPageUrl: String = ""
    private var isFetchingProgress = false

    /// Use for the calculation of the cells to be displayed
    var currentCount: Int {
      return recipes.count
    }

    func recipe(at index: Int) -> Recipe {
        return recipes[index]
    }

    // MARK: - Common Methods

    func getRecipes() {

        guard !isFetchingProgress else { return }
        isFetchingProgress = true

        guard let url = URL(string: nextPageUrl) else {
            print("url is nil")
            return }

        recipeRepository.getRecipes(with: url) { [self] recipePage, error in
            if let newRecipePage = recipePage {
                isFetchingProgress = false
                nextPageUrl = ""
                recipes.append(contentsOf: newRecipePage.hits)
                guard let newUrl = newRecipePage.nextPage else { return }
                nextPageUrl = newUrl

                /// If this isn't the first page, determine how to update the tableView by calculating the index paths to reload.
                if newRecipePage.counter > 20 {
                    let indexPathsToReload = calculateIndexPathsToReload(from: newRecipePage.hits)
                    self.delegate?.onFetchCompleted(with: indexPathsToReload)
                } else {
                    self.delegate?.onFetchCompleted(with: .none)
                }
            } else if let error = error {
                isFetchingProgress = false
                self.delegate?.onFetchFailed(with: error.localizedDescription)

            }
        }
    }

    /// calculate the indexes of the last page received. Will be used to refresh the tableView
    func calculateIndexPathsToReload(from newRecipes: [Recipe]) -> [IndexPath] {
        let startIndex = recipes.count - newRecipes.count
        let endIndex = startIndex + newRecipes.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
