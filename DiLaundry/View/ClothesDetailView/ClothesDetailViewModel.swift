//
//  ClothesDetailViewModel.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/13/23.
//

import SwiftUI
import CoreData

class ClothesDetailViewModel: ObservableObject {
    @Published var initialDirtyClothes: [Clothes] = [Clothes]()
    @Published var dirtyClothes: [Clothes] = [Clothes]()
    
    @Published var showModal: Bool = false
    @Published var showAlert: Bool = false
    @Published var shouldNavigateBack: Bool = false
    
    @Published var alertTitle: String = ""
    @Published var alertMessages: String = ""
    
    @Published var name: String = ""
    @Published var price: String = ""
    @Published var selectedDate: Date = Date()
    
    @Published var detailClothes: [String] = []
    
    private var clothesModel: ClothesModel = ClothesModel()
    private var laundryModel: LaundryModel = LaundryModel()
    
    init(){
        fetchDirtyClothes()
    }
    
    var isFormValid: Bool {
        return !name.isEmpty && !price.isEmpty
    }
    
    func deleteDirtyClothes(cloth: Clothes){
        self.dirtyClothes.removeAll(where: { $0 == cloth })
        clothesModel.changeClothesStatus(clothes: cloth, to: "clean")
//        guard let index = dirtyClothes.firstIndex(of: cloth) else { return }
//        detailClothes.remove(at: index)
//        dirtyClothes.remove(at: index)
//        detailClothes[index] = nil

        
//        dirtyClothes = self.clothesModel.fetchDirtyClothes()
    }
    
    func doLaundry() -> Bool{
        let success = laundryModel.saveLaundry(name: name, date: selectedDate, price: price, clothes: dirtyClothes)
        if(success){
            clothesModel.laundryClothes(clothes: dirtyClothes, details: detailClothes, initialDirtyClothes: initialDirtyClothes)
            scheduleNotification()
        }
        return success
//        onSave?()
    }
    
    func showAlertEmptyClothes(){
        self.showAlert = true
        self.alertTitle = "Belum ada pakaian kotor"
        self.alertMessages = "Tambahkan pakaian kotor untuk melakukan laundry"
        
    }
    
    func getClothIndex(cloth: Clothes) -> Int{
        var index: Int = -1
        for dirty in dirtyClothes {
            index+=1
            if(dirty == cloth) { return index }
        }
        
        return -1
    }
    
    func getInitialClothIndex(cloth: Clothes)->Int{
        
        var index: Int = -1
        for dirty in initialDirtyClothes {
            index+=1
            if(dirty == cloth) { return index }
        }
        
        return -1
    }
    
    func showAlertLaundryExist(){
        self.showAlert = true
        self.alertTitle = "Sedang ada laundry berjalan"
        self.alertMessages = "Kamu hanya bisa melakukan satu laundry dalam satu waktu"
    }
    
    func fetchDirtyClothes(){
        self.dirtyClothes = self.clothesModel.fetchDirtyClothes()
        self.initialDirtyClothes = self.clothesModel.fetchDirtyClothes()
        
        self.detailClothes = []
        for c in dirtyClothes{
            self.detailClothes.append(c.detail ?? "")
        }
    }
    
    private func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = name
        content.body = "Estimasi Harga : \(price)"
        content.sound = .default
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                // permission granted
                // create the trigger as 8AM of the selected date
                var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self.selectedDate)
                dateComponents.hour = 8
                dateComponents.minute = 0
//                dateComponents.timeZone = TimeZone(abbreviation: "GMT+7")
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

                // create the request
                let request = UNNotificationRequest(identifier: "laundry_notification", content: content, trigger: trigger)

                // schedule the notification
                center.add(request) { (error) in
                    if error != nil {
                        print("Error scheduling notification: \(error?.localizedDescription ?? "Unknown error")")
                    } else {
                        // notification scheduled successfully
                        print("Notification scheduled successfully")
//                        print(request)
                    }
                }
            } else {
                // permission not granted
                print("No premission")
            }
        }
//        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
//            for request in requests {
//                if request.identifier == "laundry_notification" {
//                    print(request)
//                }
//            }
//        }

    }

    
}
