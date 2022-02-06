//
//  ListRecipeCell.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit

class ListRecipeCell: UITableViewCell {

    @IBOutlet weak var listTimeView: TimeView!
    @IBOutlet weak var listCellImageView: UIImageView!
    @IBOutlet weak var listCellNameLabel: UILabel!
    @IBOutlet weak var listCellIngredients: UILabel!

    override func layoutSubviews() {
        listCellImageView.makeGradient(to: listCellImageView)
    }

    func configCell(name: String, ingredients: String, yields: Double, time: Double) {
        let yieldsString = String(yields.withoutDecimal())
        let timeString = (time * 60).convertToString(style: .abbreviated)
        listCellNameLabel.text = name
        listCellIngredients.text = ingredients
        listTimeView.yieldLabel.text = yieldsString
        listTimeView.timeLabel.text = timeString

    }
}
