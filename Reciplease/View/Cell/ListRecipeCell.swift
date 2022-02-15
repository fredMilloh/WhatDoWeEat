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
    @IBOutlet weak var listCellIngredientsLabel: UILabel!
    @IBOutlet weak var listCellIndicatorView: UIActivityIndicatorView!
    @IBOutlet var contentListCellView: UIView!

    override func prepareForReuse() {
      super.prepareForReuse()
        configCell(with: .none)
    }

    func configCell(with recipe: Recipe?) {
        if let recipe = recipe {
            let yieldString = String(recipe.yield.withoutDecimal())
            let timeString = (recipe.totalTime * 60).convertToString(style: .abbreviated)
            listCellNameLabel.text = recipe.name
            listCellIngredientsLabel.text = recipe.ingredients
            listTimeView.yieldLabel.text = yieldString
            listTimeView.timeLabel.text = timeString
            listCellIndicatorView.startAnimating()
        } else {
            listTimeView.alpha = 0
            listCellImageView.alpha = 0
            listCellNameLabel.alpha = 0
            listCellIngredientsLabel.alpha = 0
            listCellIndicatorView.startAnimating()
        }
    }

    override func layoutSubviews() {
        listCellImageView.makeGradient(to: listCellImageView)
        listCellIndicatorView.hidesWhenStopped = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }

    private func loadXib() {
        Bundle.main.loadNibNamed("ListRecipeCellView", owner: self, options: nil)
        addSubview(contentListCellView)
        contentListCellView.frame = self.bounds
        contentListCellView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
