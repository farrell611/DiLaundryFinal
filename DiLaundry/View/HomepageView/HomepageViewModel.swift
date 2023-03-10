//
//  HomepageViewModel.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/12/23.
//

import CoreData
import SwiftUI

class HomepageViewModel: ObservableObject {
    @Published var bajuCount: Int = 0
    @Published var celanaCount: Int = 0
    @Published var dirtyCount: Int = 0
    
    @Published var status: String = "tidak ada laundry"
    @Published var name: String = ""
    
    @Published var showModal: Bool = false
    
    let addClothViewModel: AddClothViewModel = AddClothViewModel()
    private var laundryModel: LaundryModel = LaundryModel()
    private var clothesModel: ClothesModel = ClothesModel()
    private var userModel: UserModel = UserModel()
    
    init() {
        self.fetch()
        
        self.addClothViewModel.addedStatus = "dirty"
        self.addClothViewModel.onSave = { [weak self] in
            self?.showModal = false
        }
    }
    
    func fetchOngoing() -> Laundry?{
        return laundryModel.fetchOngoingLaundry() ?? nil
    }
    
    func fetch(){
        
        if(laundryModel.isOnGoingLaundryExist()){
            self.status = "laundry berjalan"
            if (!laundryModel.isOngoingLaundryRetrieved()) {
                self.status = "laundry siap diambil"
            }
        } else {
            self.status = "tidak ada laundry"
        }
        
        self.bajuCount = clothesModel.countShirts()
        self.celanaCount = clothesModel.countPants()
        self.dirtyCount = clothesModel.countDirtyClothes()
        
        if let user = self.userModel.fetchFirstUser(){
            self.name = user.name!
        }
    }
}
