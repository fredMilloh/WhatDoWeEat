//
//  UIImageView+.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import Foundation
import UIKit

extension UIImageView {

    func setImageFromURL(stringImageUrl url: String) {
        if let url = NSURL(string: url),
           let data = NSData(contentsOf: url as URL) {
            self.image = UIImage(data: data as Data)
        }
    }

    func makeGradient() {
        let gradientLayer = CAGradientLayer()
        let color = UIColor.black
        self.layer.sublayers?.removeAll()
        gradientLayer.removeFromSuperlayer()
        gradientLayer.frame = self.bounds
        gradientLayer.type = .axial
        gradientLayer.colors = [color.withAlphaComponent(0).cgColor, color.withAlphaComponent(0.7).cgColor]
        gradientLayer.locations = [0, 1]
        self.layer.addSublayer(gradientLayer)
    }
}
