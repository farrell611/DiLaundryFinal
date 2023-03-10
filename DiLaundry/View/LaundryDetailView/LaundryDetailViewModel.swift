//
//  LaundryDetailViewModel.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/15/23.
//

import CoreData
import SwiftUI

class LaundryDetailViewModel: ObservableObject{
    //    laundry.clothesList?.allObjects as? [Clothes]
    @Published var laundry: Laundry
    @Published var user: User = User()
    @Published var showShareSheet: Bool = false
    @Published var toRetrieveClothes: [Clothes] = []
    @Published var showAlert: Bool = false
    private var userModel: UserModel = UserModel()
    private var laundryModel: LaundryModel = LaundryModel()
    private var clothesModel: ClothesModel = ClothesModel()
    
    init(laundry: Laundry?) {
        self.laundry = laundry ?? Laundry()
        self.user = self.userModel.fetchFirstUser()!
    }
    
    func doneLaundry() {
        for cloth in toRetrieveClothes {
            clothesModel.changeClothesStatus(clothes: cloth, to: "clean")
        }
        showAlert = true
        for cloth in self.laundry.clothesList?.allObjects as! [Clothes] {
            if (cloth.status == "on-laundry"){
                laundryModel.changeLaundryStatus(laundry: laundry, to: "PROBLEM")
                return
            }
        }
        laundryModel.changeLaundryStatus(laundry: laundry, to: "DONE")
    }
    
    func toggleToRetrieveClothes(clothes: Clothes){
        if(self.toRetrieveClothes.contains(clothes)){
            self.toRetrieveClothes = self.toRetrieveClothes.filter{ $0 != clothes }

        } else {
            self.toRetrieveClothes.append(clothes)
        }
        
    }

}
