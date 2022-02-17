//
//  ListRecipesController.swift
//  Reciplease
//
//  Created by fred on 06/02/2022.
//

import UIKit

class ListRecipesController: TabBarController {

    @IBOutlet weak var listRecipesTableView: UITableView!
    
    var viewModel = ListViewModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Reciplease"
        listRecipesTableView.delegate = self
        listRecipesTableView.dataSource = self
        listRecipesTableView.prefetchDataSource = self
    }
}

    // MARK: - TableView DataSource

extension ListRecipesController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.totalCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell",
                                                       for: indexPath) as? ListRecipeCell
        else { return UITableViewCell() }

        if isLoadingCell(for: indexPath) {
            cell.configCell(with: .none)
        } else {
            let recipe = viewModel.recipe(at: indexPath.row)
            if recipe.imageUrl != nil {
                guard let url = recipe.imageUrl else { return UITableViewCell() }
                cell.listCellImageView.setImageFromURl(stringImageUrl: url)
            } else {
                cell.listCellImageView.image = UIImage(named: "DefaultImage")
            }
            cell.configCell(with: recipe)
        }
        return cell
    }
}

    // MARK: - TableView Delegate

extension ListRecipesController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = viewModel.recipe(at: indexPath.row)
        guard let cell = listRecipesTableView.cellForRow(at: indexPath) as? ListRecipeCell,
              let imageSelectedRecipe = cell.listCellImageView.image
        else { return }

        let storyboard = UIStoryboard(name: "DetailRecipe", bundle: Bundle.main)
        guard let detailRecipe = storyboard.instantiateViewController(withIdentifier: "DetailRecipe") as? DetailRecipeController else { return }

        detailRecipe.selectedRecipe = selectedRecipe
        detailRecipe.selectedImage = imageSelectedRecipe
        self.navigationController?.pushViewController(detailRecipe, animated: true)
    }
}
    // MARK: - TableView Prefetching

extension ListRecipesController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

        /// check if any of indexPath are not loaded yet. If so, ask next page
        if indexPaths.contains(where: isLoadingCell) {

            guard let url = URL(string: viewModel.nextPageUrl) else { return }

            viewModel.getRecipes(with: url) { [self] recipePage, error in
                guard let recipes = recipePage else { return }

                let nextUrl = recipes.nextPage
                viewModel.nextPageUrl = nextUrl != nil ? nextUrl.orEmpty : ""
            }
        }
    }

    /// Determine if the cell at that index path is beyond the count of the recipe received so far
    private func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModel.currentCount
    }

    /// Calculate the cells of the table view needed to reload when a new page is received
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
      let indexPathsForVisibleRows = listRecipesTableView.indexPathsForVisibleRows ?? []
      let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
      return Array(indexPathsIntersection)
    }

}

extension ListRecipesController: ListVMDelegate {

    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            listRecipesTableView.reloadData()
            return
        }
        /// newIndexPathsToReload is not nil (next pages), find the visible cells that needs reloading and reload only those
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        listRecipesTableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }

    func onFetchFailed(with reason: String) {
        presentAlert(message: .fetchError)
    }
}
