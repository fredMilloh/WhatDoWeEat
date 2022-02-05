//
//  ListRecipeCell.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit

class ListRecipeCell: UITableViewCell {


    @IBOutlet weak var listCellNameLabel: UILabel!

    override func layoutSubviews() {
    }

    func configCell(name: String) {
        listCellNameLabel.text = name

    }
}
