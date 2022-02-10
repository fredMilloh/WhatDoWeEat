//
//  CoreDataStack.swift
//  Reciplease
//
//  Created by fred on 08/02/2022.
//

import Foundation
import CoreData

class CoreDataStack {

    // MARK: - Singleton

    static let sharedInstance = CoreDataStack()

    // MARK: - Public

    var viewContext: NSManagedObjectContext {
        return CoreDataStack.sharedInstance.persistentContainer.viewContext
      }

    // MARK: - Private

    private lazy var persistentContainer: NSPersistentContainer = {
      let container = NSPersistentContainer(name: "Reciplease")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        if let error = error as NSError? {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
      })
      return container
    }()

}
