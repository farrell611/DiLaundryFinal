//
//  ClothesModel.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/13/23.
//

import CoreData


class ClothesModel{
    private var context: NSManagedObjectContext
    
    init() {
        self.context = PersistenceController.shared.container.viewContext
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func deleteAllClothes() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Clothes")
        do {
            let clothes = try context.fetch(request) as? [NSManagedObject]
            for cloth in clothes ?? [] {
                context.delete(cloth)
            }
            try context.save()
        } catch {
            print("Error deleting all users")
        }
    }
    
    func fetchClothes() -> [Clothes]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Clothes")
        do {
            let result = try context.fetch(request) as? [Clothes]
            return result
        } catch {
            print("Error fetching data from Clothes entity")
            return nil
        }
    }
    
    func saveClothes(image: Data, category: String, status: String = "clean") -> Bool {
        let clothes = Clothes(context: context)
        clothes.id = UUID()
        clothes.image = image
        clothes.category = category
        clothes.status = status
        clothes.detail = ""
        do {
            try context.save()
            ClothesAPI(clothes: clothes).updateAPI()
            return true
        } catch {
            print("Error saving data to User entity")
        }
        return false
    }
    
    func filterClothes(byCategories category: [String]) -> [Clothes] {
        let request: NSFetchRequest<Clothes> = Clothes.fetchRequest()
        request.predicate = NSPredicate(format: "category IN %@", category)
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching Clothes with category filter: \(error)")
            return []
        }
    }
    
    func changeClothesStatus(clothes: Clothes, to status: String) {
        clothes.status = status
        do {
            try context.save()
            ClothesAPI(clothes: clothes).updateAPI()
        } catch {
            print("Error saving clothes status change")
        }
    }
    
    func deleteClothes(byClothes: [Clothes]) {
        for clothes in byClothes {
            context.delete(clothes)
        }
        do {
            try context.save()
        } catch {
            print("Error deleting clothes: \(error)")
        }
    }
    
    func countDirtyClothes() -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Clothes")
        request.predicate = NSPredicate(format: "status = %@", "dirty")
        do {
            let result = try context.fetch(request) as? [Clothes]
            return result?.count ?? 0
        } catch {
            print("Error fetching dirty clothes")
            return 0
        }
    }
    
    func countShirts() -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Clothes")
        request.predicate = NSPredicate(format: "category = %@", "Shirt")
        do {
            let result = try context.fetch(request) as? [Clothes]
            return result?.count ?? 0
        } catch {
            print("Error fetching shirts")
            return 0
        }
    }
    
    func countPants() -> Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Clothes")
        request.predicate = NSPredicate(format: "category = %@", "Pants")
        do {
            let result = try context.fetch(request) as? [Clothes]
            return result?.count ?? 0
        } catch {
            print("Error fetching shirts")
            return 0
        }
    }
    
    func fetchDirtyClothes() -> [Clothes] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Clothes")
        request.predicate = NSPredicate(format: "status = %@", "dirty")
        do {
            let result = try context.fetch(request) as! [Clothes]
            return result
        } catch {
            print("Error fetching dirty clothes")
            return []
        }
    }
    
    func laundryClothes(clothes: [Clothes], details: [String], initialDirtyClothes: [Clothes]) {
        var index: Int = -1
        for cloth in clothes {
            index += 1
            cloth.status = "on-laundry"
            guard let idx = initialDirtyClothes.firstIndex(of: cloth) else { return }
            
            cloth.detail = details[idx]
            ClothesAPI(clothes: cloth).updateAPI()
        }
        try? context.save()
    }
    
    
    
}
