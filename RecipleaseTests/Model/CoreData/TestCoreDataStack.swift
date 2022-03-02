//
//  TestCoreDataStack.swift
//  RecipleaseTests
//
//  Created by fred on 02/03/2022.
//


import CoreData
@testable import Reciplease

class TestCoreDataStack: AppDelegate {

   override init() {
      super.init()

      let persistentStoreDescription = NSPersistentStoreDescription()
      persistentStoreDescription.type = NSInMemoryStoreType

      let testPersistentContainer = NSPersistentContainer(name: AppDelegate.persistentContainerName)
      testPersistentContainer.persistentStoreDescriptions = [persistentStoreDescription]
      testPersistentContainer.loadPersistentStores { (_, error: Error?) in
         if let _ = error {
            fatalError()
         }
      }
      AppDelegate.persistentContainer = testPersistentContainer
   }

}
