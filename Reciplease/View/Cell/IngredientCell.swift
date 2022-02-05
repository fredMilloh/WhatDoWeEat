//
//  IngredientCell.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit

class IngredientCell: UITableViewCell {

    @IBOutlet weak var cellIngredientLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configCell(withIngredient: String) {
        cellIngredientLabel.text = withIngredient
    }

}
