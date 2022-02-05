//
//  UIColor+.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import Foundation
import UIKit

extension UIColor {

    static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }

    static let appColor = rgbColor(red: 56, green: 51, blue: 50, alpha: 1)
    static let addGreen = rgbColor(red: 20, green: 153, blue: 86, alpha: 1)
    static let clearStack = rgbColor(red: 139, green: 139, blue: 139, alpha: 1)
    static let searchButton = rgbColor(red: 13, green: 151, blue: 87, alpha: 1)
}
