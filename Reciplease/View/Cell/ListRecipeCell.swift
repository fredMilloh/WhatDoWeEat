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
        guard let recipe = recipe else { return }
        let yieldString = String(recipe.yield.withoutDecimal())
        let timeString = (recipe.totalTime * 60).convertToString(style: .abbreviated)
        listCellNameLabel.text = recipe.name
        listCellIngredientsLabel.text = recipe.ingredients
        listTimeView.yieldLabel.text = yieldString
        listTimeView.timeLabel.text = timeString
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
