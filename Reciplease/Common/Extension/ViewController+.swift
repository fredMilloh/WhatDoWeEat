//
//  ViewController+.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import Foundation
import UIKit

extension UIViewController {

    func tabBarConfig() {
            guard let tabBarVC = self.tabBarController,
                let itemsTabBar = tabBarVC.tabBar.items else {
                    return
                }

            let bounds = tabBarVC.tabBar.bounds
            let frameHeight = tabBarVC.tabBar.frame.height
            let frameWidth = tabBarVC.tabBar.frame.width

            let boundsHeight = bounds.height
            let numItems = CGFloat(itemsTabBar.count)
            let itemSize = CGSize(
                width: frameWidth / numItems,
                height: frameHeight)

         /// horizontal separator
            let topSeparator = UIView(frame: CGRect(
                x: 0,
                y: 0,
                width: bounds.width,
                height: 2))
            topSeparator.backgroundColor = .white
            self.tabBarController?.tabBar.insertSubview(topSeparator, at: 1)

         /// vertical separator
            for (index,_) in itemsTabBar.enumerated() {
                if index > 0 {
                    let xPosition = itemSize.width * CGFloat(index)

                    let separator = UIView(frame: CGRect(
                        x: xPosition,
                        y: 0,
                        width: 2,
                        height: boundsHeight))
                    separator.backgroundColor = .white

                    self.tabBarController?.tabBar.insertSubview(separator, at: 1)
                }
            }

         }

}
