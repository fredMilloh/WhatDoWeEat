//
//  TextFieldWhiteView.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit

class TextFieldWhiteView: UIView {

    @IBOutlet weak var contentTextFieldView: UIView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadXib()
    }

    private func setTextField() {
        textField.placeholder = "Lemon, Cheese, Sausages..."
        textField.clearButtonMode = .whileEditing
    }


    override func layoutSubviews() {
        setTextField()
    }

    private func loadXib() {
        Bundle.main.loadNibNamed("TextFieldWhiteView", owner: self, options: nil)
        addSubview(contentTextFieldView)
        contentTextFieldView.frame = self.bounds
        contentTextFieldView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
