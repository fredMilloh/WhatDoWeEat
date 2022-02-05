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
        UITabBar.appearance().tintColor = .systemGray2
        UITabBar.appearance().unselectedItemTintColor = .white

        let tabbarAppearance = UITabBarItem.appearance()
        tabbarAppearance.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Chalkduster", size: 20) as Any], for: .normal)
    }

}
