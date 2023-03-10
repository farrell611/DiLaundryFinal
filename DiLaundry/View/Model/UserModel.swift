//
//  UserModel.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/13/23.
//

import CoreData

class UserModel{
    private var context: NSManagedObjectContext
    
    init() {
        self.context = PersistenceController.shared.container.viewContext
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func deleteAllUsers() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let users = try context.fetch(request) as? [NSManagedObject]
            for user in users ?? [] {
                context.delete(user)
            }
            try context.save()
        } catch {
            print("Error deleting all users")
        }
    }
    
    func checkIfUsersExist() -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            let result = try context.fetch(request)
            if result.count > 1 {
                return true
            } else {
                return false
            }
        } catch {
            print("Error fetching data from User entity")
            return false
        }
    }
    
    func fetchFirstUser() -> User? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.fetchLimit = 1
        do {
            let result = try context.fetch(request) as? [User]
            return result?.first
        } catch {
            print("Error fetching data from User entity")
            return nil
        }
    }
    
    func saveUser(name: String, address: String, phoneNumber: String) {
        let user = User(context: context)
        user.name = name
        user.address = address
        user.phoneNumber = phoneNumber
        do {
            try context.save()
        } catch {
            print("Error saving data to User entity")
        }
    }
    
    func updateUser(name: String, address: String, phoneNumber: String) {
        let request: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try context.fetch(request)
            if let firstUser = users.first {
                firstUser.name = name
                firstUser.address = address
                firstUser.phoneNumber = phoneNumber
                try context.save()
            } else {
                print("No user found to update")
            }
        } catch {
            print(error)
        }
    }
}
