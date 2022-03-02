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

    weak var delegate: ListViewModelDelegate?

    init(delegate: ListViewModelDelegate) {
        self.delegate = delegate
    }

    lazy var recipeRepository = RecipeRepository(repositoryFetcher: RecipeRepositoryFetcher())

// MARK: - Properties

    var recipes: [Recipe] = []
    var nextPageUrl: String = ""
    private var isFetchingProgress = false

    /// Use for the calculation of the cells to be displayed
    var currentCount: Int {
        return recipes.count
    }

    var count = 0

    /// number of rows List tableView
    var totalCount: Int {
        return count
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

    func getFirstRecipes(with ingredientsUrl: URL, completion: @escaping (_ error: Bool) -> Void) {
       recipeRepository.getRecipes(with: ingredientsUrl) { recipePage, error in
          if let firstRecipePage = recipePage {
             self.recipes.append(contentsOf: firstRecipePage.hits)
              guard let url = firstRecipePage.nextPage else { return }
              self.nextPageUrl = url
              self.count = firstRecipePage.count
              completion(false)
          } else {
              completion(true)
          }
       }
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

extension ListRecipesViewModel: RecipeRepositoryProtocol {
   func getRecipes(with url: URL, callback: @escaping RecipePageOrError) {
   }


}
