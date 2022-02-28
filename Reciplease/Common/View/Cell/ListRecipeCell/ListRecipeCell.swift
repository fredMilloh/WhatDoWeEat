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
    @IBOutlet var contentListCellView: UIView!

    static let identifier = "ListCell"

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }

    private func loadXib() {
        Bundle.main.loadNibNamed("ListRecipeCell", owner: self, options: nil)
        addSubview(contentListCellView)
        contentListCellView.frame = self.bounds
        contentListCellView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        configCell(with: nil)
    }

    /// Called by layoutIfNeeded automatically
    override func layoutSubviews() {
        super.layoutSubviews()
        listCellImageView.makeGradient()
    }

    func configCell(with recipe: Recipe?) {
        guard let recipe = recipe else { return }

        let yieldString = recipe.yield.withoutDecimal()
        let timeString = (recipe.totalTime * 60).convertToString(style: .abbreviated)
        listCellNameLabel.text = recipe.name
        listCellIngredientsLabel.text = recipe.ingredients
        listTimeView.yieldLabel.text = yieldString
        listTimeView.timeLabel.text = timeString

        if let url = recipe.imageUrl {
            listCellImageView.setImageFromURL(stringImageUrl: url)
        } else {
            listCellImageView.image = UIImage(named: "DefaultImage")
        }
        /// Lays out the subviews immediately - Allows to have the gradient from the first display
        self.layoutIfNeeded()
    }
}
