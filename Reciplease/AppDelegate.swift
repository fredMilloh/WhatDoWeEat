//
//  AppDelegate.swift
//  Reciplease
//
//  Created by fred on 05/02/2022.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let appearance = TabBarAppearance()
        appearance.setTabBarAppearance()
        return true
    }

    // MARK: - Core Data stack

    static let persistentContainerName = "Reciplease"

//    static var persistentContainer: NSPersistentContainer {
//        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
//    }

    static var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
      }

    static var persistentContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: AppDelegate.persistentContainerName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
}
