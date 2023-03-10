//
//  UserModel.swift
//  OutfitTracker
//
//  Created by Ttaa on 1/11/23.
//

import CoreData

class UserModel {
    static let shared = PersistenceController()
    
    var container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "User")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    func saveContext () {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

