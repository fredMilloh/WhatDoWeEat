//
//  UITextField+.swift
//  Reciplease
//
//  Created by fred on 08/02/2022.
//

import Foundation
import UIKit

extension UITextField {

  func setBottomBorder() {
    borderStyle = .none
    layer.backgroundColor = UIColor.white.cgColor

    layer.masksToBounds = false

      layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
    layer.shadowOpacity = 1.0
    layer.shadowRadius = 0.0
  }
}
