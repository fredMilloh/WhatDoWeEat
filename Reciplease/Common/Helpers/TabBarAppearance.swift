//
//  TabBarAppearance.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit

class TabBarAppearance: UITabBarAppearance {

    func setTabBarAppearance() {

        UITabBar.appearance().backgroundColor = .appColor
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .systemGray2

        let tabbarAppearance = UITabBarItem.appearance()
        tabbarAppearance.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Chalkduster", size: 20) as Any], for: .normal)
    }

}
