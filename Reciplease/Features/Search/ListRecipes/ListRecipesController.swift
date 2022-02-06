//
//  ListRecipesController.swift
//  Reciplease
//
//  Created by fred on 06/02/2022.
//

import UIKit

class ListRecipesController: UIViewController {

    @IBOutlet weak var listRecipesTableView: UITableView!

    var listOfRecipes: [Recipe]!
    /// unwrapped list to allow deletion of a cell
    var list = [Recipe]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Reciplease"
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        listRecipesTableView.delegate = self
        listRecipesTableView.dataSource = self
        guard let list = listOfRecipes else { return }
        self.list = list
    }
}

// MARK: - TableView DataSource

extension ListRecipesController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListRecipeCell else { return UITableViewCell() }

        let recipe = self.list[indexPath.row]
        cell.listCellImageView.setImageFromURl(stringImageUrl: recipe.imageUrl)
        cell.configCell(name: recipe.name, ingredients: recipe.ingredients, yields: recipe.yield, time: recipe.totalTime)
        return cell
    }
}

//MARK: - TableView Delegate

extension ListRecipesController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = list[indexPath.row]
        guard let cell = listRecipesTableView.cellForRow(at: indexPath) as? ListRecipeCell,
              let imageSelectedRecipe = cell.listCellImageView.image
        else { return }

        guard let detailRecipe = self.storyboard?.instantiateViewController(withIdentifier: "DetailRecipeController") as? DetailRecipeController else { return }

        detailRecipe.selectedRecipe = selectedRecipe
        detailRecipe.selectedImage = imageSelectedRecipe
        self.navigationController?.pushViewController(detailRecipe, animated: true)
        
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            list.remove(at: indexPath.row)
            listRecipesTableView.deleteRows(at: [indexPath], with: .fade)
            listRecipesTableView.reloadData()
        }
    }

}
