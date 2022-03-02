//
//  ListRecipesController.swift
//  Reciplease
//
//  Created by fred on 06/02/2022.
//

import UIKit
import Alamofire

class ListRecipesController: TabBarController {

    @IBOutlet weak var listRecipesTableView: UITableView!
    @IBOutlet weak var listIndicatorView: UIActivityIndicatorView!

    lazy var viewModel = ListRecipesViewModel(delegate: self)

    static let identifier = "ListRecipesController"

    /// Url from SearchController
    var url: URL?

    var alertMessage: RecipeError = .fetchError {
        didSet {
            presentAlert(message: alertMessage.localizedDescription)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        listRecipesTableView.delegate = self
        listRecipesTableView.dataSource = self
        listRecipesTableView.prefetchDataSource = self
        getFirstRecipes()
    }

// MARK: - Get first recipes

    func getFirstRecipes() {
       listRecipesTableView.isHidden = true
       listIndicatorView.startAnimating()

       guard let url = url else { return }

       viewModel.getFirstRecipes(with: url) { error in
           self.listRecipesTableView.isHidden = false
           self.listIndicatorView.stopAnimating()
           if error {
              self.alertMessage = .fetchError
           }
print("vm count = ", self.viewModel.totalCount)
print("vm recipes count = ", self.viewModel.recipes.count)
           self.listRecipesTableView.reloadData()
       }
    }

    private func goBack() {
        let storyboard = UIStoryboard(name: SearchController.identifier, bundle: Bundle.main)
        guard let searchController = storyboard.instantiateViewController(withIdentifier: SearchController.identifier)
                as? SearchController else { return }
        self.navigationController?.pushViewController(searchController, animated: true)
    }
}

// MARK: - TableView DataSource

extension ListRecipesController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return viewModel.totalCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListRecipeCell.identifier, for: indexPath) as? ListRecipeCell else { return UITableViewCell() }

        if isOutOfRangeRecipesReceived(for: indexPath) {
            cell.configCell(with: .none)
        } else {
            let recipe = viewModel.recipe(at: indexPath.row)
            cell.configCell(with: recipe)
        }
        return cell
    }
}

// MARK: - TableView Delegate

extension ListRecipesController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: DetailRecipeController.identifier, bundle: Bundle.main)

        guard let detailRecipe = storyboard.instantiateViewController(withIdentifier: DetailRecipeController.identifier) as? DetailRecipeController
        else { return }

        let selectedRecipe = viewModel.recipe(at: indexPath.row)
        detailRecipe.selectedRecipe = selectedRecipe
        self.navigationController?.pushViewController(detailRecipe, animated: true)
    }
}

// MARK: - TableView Prefetching - Get other recipes pages

extension ListRecipesController: UITableViewDataSourcePrefetching {

    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        /// check if any of indexPath are not loaded yet. If so, ask next page
        if indexPaths.contains(where: isOutOfRangeRecipesReceived) {
            viewModel.getRecipes()
        }
    }

    /// Determine if the cell at that index path is beyond the count of the recipe received so far
    private func isOutOfRangeRecipesReceived(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }

    /// Calculate the cells of the table view needed to reload when a new page is received
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = listRecipesTableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
}

// MARK: - Protocol ListViewModel

extension ListRecipesController: ListViewModelDelegate {

    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            listRecipesTableView.reloadData()
            return
        }
        /// newIndexPathsToReload is not nil (next pages), find the visible cells that needs reloading and reload only those
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        listRecipesTableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }

    func onFetchFailed(with error: RecipeError) {
        alertMessage = error
    }
}
