//
//  RecipeRepository.swift
//  Reciplease
//
//  Created by fred on 07/02/2022.
//

import Foundation

protocol ListVMDelegate: AnyObject {
  func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
  func onFetchFailed(with reason: String)
}

class ListViewModel {

    // MARK: - Singleton

    static var shared = ListViewModel()
    private init() {}

    // MARK: - Properties

    private weak var delegate: ListVMDelegate?
    private let client = APIService.shared
    private var parser = ParserRepository.shared

    private var total = 0
    private var isFetchinInProgress = false
    var recipes: [Recipe] = []
    var nextPageUrl: String = ""

    /// number of rows List tableView
    var totalCount: Int {
      return total
    }

    /// Use for the calculation of the cells to be displayed
    var currentCount: Int {
      return recipes.count
    }

    func recipe(at index: Int) -> Recipe {
        return recipes[index]
    }

    // MARK: - Common Methods

    typealias RecipePageOrError = (_ recipe: (RecipePage)?, _ error: RecipeError?) -> Void

    func getRecipes(with url: URL, completion: @escaping RecipePageOrError) {

        client.get(url: url) { [self] data, error in

            if let data = data {
                let recipes = parser.parse(data)
                self.recipes.append(contentsOf: recipes.hits)
                self.total = recipes.count
                self.nextPageUrl = recipes.nextPage.orEmpty
                completion(recipes, nil)

                /// If this isn't the first page, determine how to update the tableView by calculating the index paths to reload.
                if recipes.counter > 20 {
                    let indexPathsToReload = calculateIndexPathsToReload(from: recipes.hits)
                    self.delegate?.onFetchCompleted(with: indexPathsToReload)
                } else {
                    self.delegate?.onFetchCompleted(with: .none)
                }
            } else if let error = error {
                self.delegate?.onFetchFailed(with: error.localizedDescription)
                completion(nil, .invalidData)
            }
        }
    }

    /// calculate the indexes of the last page received. Will be used to refresh the tableView
    private func calculateIndexPathsToReload(from newRecipes: [Recipe]) -> [IndexPath] {
        let startIndex = recipes.count - newRecipes.count
        let endIndex = startIndex + newRecipes.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
