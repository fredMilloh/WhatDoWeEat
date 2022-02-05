//
//  FavoriteController.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit

class FavoriteController: UIViewController {
    
    @IBOutlet weak var listRecipeTableView: UITableView!

    var listOfRecipes = ["tea", "eggs", "apple"]


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "Reciplease"
        listRecipeTableView.delegate = self
        listRecipeTableView.dataSource = self

    }
}

extension FavoriteController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfRecipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListRecipeCell else { return UITableViewCell() }

        let name = self.listOfRecipes[indexPath.row]
        cell.configCell(name: name)
        return cell
    }


}

extension FavoriteController: UITableViewDelegate {

}
