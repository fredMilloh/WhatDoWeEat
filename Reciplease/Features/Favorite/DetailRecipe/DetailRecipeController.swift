//
//  DetailRecipeController.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit

class DetailRecipeController: UIViewController {

    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var detailRecipeImageView: UIImageView!
    @IBOutlet weak var detailRecipeNameLabel: UILabel!

    var selectedRecipe: Recipe!
    var selectedImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.delegate = self
        detailTableView.dataSource = self
    }
    
    @IBAction func getDirectionsButton(_ sender: UIButton) {
    }
    
}

extension DetailRecipeController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedRecipe.ingredientLines.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? IngredientCell else {
            return UITableViewCell()
        }
        detailRecipeImageView.image = selectedImage != UIImage() ? selectedImage : UIImage(named: "DefaultImage")
        detailRecipeNameLabel.text = selectedRecipe.name

        let ingredient = selectedRecipe.ingredientLines[indexPath.row]

        cell.configCell(withIngredient: ingredient)

        return cell
    }


}
extension DetailRecipeController: UITableViewDelegate {

}
