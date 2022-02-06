//
//  TimeView.swift
//  Reciplease
//
//  Created by fred on 06/02/2022.
//

import UIKit

class TimeView: UIView {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var yieldLabel: UILabel!
    @IBOutlet var contentTimeView: UIView!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }

    private func loadXib() {
        Bundle.main.loadNibNamed("TimeView", owner: self, options: nil)
        addSubview(contentTimeView)
        contentTimeView.frame = self.bounds
        contentTimeView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
