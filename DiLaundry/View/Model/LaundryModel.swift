//
//  LaundryModel.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/13/23.
//

import CoreData

class LaundryModel{
    private var context: NSManagedObjectContext
    private var dateFormatter = DateFormatter()
    
    init() {
        self.context = PersistenceController.shared.container.viewContext
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func deleteAllLaundries() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Laundry")
        do {
            let laundries = try context.fetch(request) as? [NSManagedObject]
            for laundry in laundries ?? [] {
                context.delete(laundry)
            }
            try context.save()
        } catch {
            print("Error deleting all users")
        }
    }
    
    func fetchOngoingLaundry() -> Laundry?{
        let fetchRequest: NSFetchRequest<Laundry> = Laundry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "status == %@", "ON PROGRESS")
        do {
            let onProgressLaundries = try context.fetch(fetchRequest)
            return onProgressLaundries.first
        } catch {
            print("Error fetching laundries: \(error)")
            return nil
        }
        
    }
    
    func isOnGoingLaundryExist() -> Bool{
        let fetchRequest: NSFetchRequest<Laundry> = Laundry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "status == %@", "ON PROGRESS")
        do {
            let onProgressLaundries = try context.fetch(fetchRequest)
            return !onProgressLaundries.isEmpty
        } catch {
            print("Error fetching laundries: \(error)")
            return false
        }
        
    }
    
    func isOngoingLaundryRetrieved() -> Bool {
        let today = Date()
        let request: NSFetchRequest<Laundry> = Laundry.fetchRequest()
        request.predicate = NSPredicate(format: "status == %@ AND date <= %@", "ON PROGRESS", today as NSDate)
        do {
            let laundry = try context.fetch(request)
            return laundry.isEmpty
        } catch {
            print("Error fetching laundry: \(error)")
            return false
        }
    }

    
    func saveLaundry(name: String, date: Date, price: String, clothes: [Clothes]) -> Bool {
        let fetchRequest: NSFetchRequest<Laundry> = Laundry.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "status == %@", "ON PROGRESS")
        
        do {
            let onProgressLaundries = try context.fetch(fetchRequest)
            if onProgressLaundries.count == 0 {
                // There's no laundry with "ON PROGRESS" status, save the new laundry
                let laundry = Laundry(context: context)
                
                laundry.id = UUID()
                laundry.name = name
                
                laundry.date = date
                dateFormatter.dateFormat = "d/M/yy"
                laundry.dateString = dateFormatter.string(from: date)
                
                laundry.price = price
                laundry.status = "ON PROGRESS"
                laundry.clothesList = NSSet(array: clothes)

                do {
                    try context.save()
                    
                    let userModel: UserModel = UserModel()
                    
                    if let user = userModel.fetchFirstUser(){
                        LaundryAPI(laundry: laundry, user: user).updateAPI()
                        return true
                    }

                } catch {
                    print("Error saving laundry: \(error)")
                }
            }
        } catch {
            print("Error fetching laundries: \(error)")
        }
        return false
    }
    
    func fetchLaundry() -> [Laundry] {
        let request: NSFetchRequest<Laundry> = Laundry.fetchRequest()
        do {
            let result = try context.fetch(request) as [Laundry]
            print(result.count)
            return result
        } catch {
            print("Error fetching Laundry")
            return []
        }
    }
    
    func changeLaundryStatus(laundry: Laundry, to status: String) {
            laundry.status = status
            do {
                
                let userModel: UserModel = UserModel()
                
                if let user = userModel.fetchFirstUser(){
                    LaundryAPI(laundry: laundry, user: user).updateAPI()
                }
                
                try context.save()
            } catch {
                print("Error saving laundry status change")
            }
        }

    func changeLaundryDate(laundry: Laundry, dateString: String){
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)
        laundry.date = date
        
        dateFormatter.dateFormat = "d/M/yy"
        laundry.dateString = dateFormatter.string(from: date ?? Date())
        do {
            try context.save()
        } catch {
            print("Error saving laundry date change")
        }
        
    }
}
