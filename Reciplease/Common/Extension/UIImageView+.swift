//
//  UIImageView+.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import Foundation
import UIKit

extension UIImageView {

    func setImageFromURl(stringImageUrl url: String){

      if let url = NSURL(string: url) {
         if let data = NSData(contentsOf: url as URL) {
            self.image = UIImage(data: data as Data)
         }
      }
    }

    func makeGradient(to image: UIImageView) {
        let gradientLayer = CAGradientLayer()
        let color = UIColor.black
        image.layer.sublayers?.removeAll()
        gradientLayer.removeFromSuperlayer()
        gradientLayer.frame = image.bounds
        gradientLayer.type = .axial
        gradientLayer.colors = [color.withAlphaComponent(0).cgColor, color.withAlphaComponent(0.6).cgColor]
        gradientLayer.locations = [0, 1]
        image.layer.addSublayer(gradientLayer)
    }
}
