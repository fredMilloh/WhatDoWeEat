//
//  RecipeRepository.swift
//  Reciplease
//
//  Created by fred on 07/02/2022.
//

import Foundation

protocol ListViewModelDelegate: AnyObject {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with error: RecipeError)
}

class ListRecipesViewModel {

    var recipeRepository = RecipeRepository.shared
    weak var delegate: ListViewModelDelegate?

    init(delegate: ListViewModelDelegate) {
        self.delegate = delegate
    }

// MARK: - Properties

    var recipes: [Recipe] = []
    var nextPageUrl: String = ""
    private var isFetchingProgress = false

    /// Use for the calculation of the cells to be displayed
    var currentCount: Int {
      return recipes.count
    }

    var url: URL {
        guard let url = URL(string: nextPageUrl) else {
            delegate?.onFetchFailed(with: .fetchError)
            return URL(fileURLWithPath: "www")
        }
        return url
    }

// MARK: - Common Methods

    func recipe(at index: Int) -> Recipe {
        return recipes[index]
    }

    func getRecipes() {

        guard !isFetchingProgress else { return }
        isFetchingProgress = true

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
                self.delegate?.onFetchFailed(with: error)

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
