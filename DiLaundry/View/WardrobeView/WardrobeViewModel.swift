//
//  WardrobeViewModel.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/12/23.
//

import CoreData
import SwiftUI

class WardrobeViewModel: ObservableObject {
    @Published var clothes = [Clothes]()
    @Published var filterCategories: [String] = []
    @Published var toDeleteClothes: [Clothes] = []
    
    @Published var dirtyClothesCount: Int = 0
    
    @Published var showModal: Bool = false
    @Published var showAlert: Bool = false
    @Published var deleteCheckShow: Bool = false
    @Published var navigation: Bool = false
    
    let categories: [String] = ["Outer", "Shirt", "Jacket", "Dress", "Cardigan", "Pants", "Socks", "Underwear", "Others"]
    let addClothViewModel: AddClothViewModel = AddClothViewModel()
    private let clothesModel: ClothesModel = ClothesModel()

    init() {
//        clothesModel.deleteAllClothes()
        
        addClothViewModel.addedStatus = "clean"
        addClothViewModel.onSave = { [weak self] in
            self?.showModal = false
            self?.fetchClothes()
        }
        
        fetchClothes()
    }
    
    func fetchClothes() {
        
        if(filterCategories.count==0){
            clothes = clothesModel.fetchClothes() ?? []
        } else {
            clothes = clothesModel.filterClothes(byCategories: filterCategories)
        }
        
        dirtyClothesCount = clothesModel.countDirtyClothes()
    }
    
    func toggleCategory(category: String){
        if(self.filterCategories.contains(category)){
            self.filterCategories = self.filterCategories.filter{ !$0.contains(category) }

        } else {
            self.filterCategories.append(category)
        }
        fetchClothes()
        
    }
    
    func toggleToDeleteClothes(clothes: Clothes){
        if(self.toDeleteClothes.contains(clothes)){
            self.toDeleteClothes = self.toDeleteClothes.filter{ $0 != clothes }

        } else {
            self.toDeleteClothes.append(clothes)
        }
    }
    
    func deleteClothes(){
        clothesModel.deleteClothes(byClothes: toDeleteClothes)
        fetchClothes()
        deleteCheckShow = false
        toDeleteClothes = []
    }
    
    func toggleDirtyStatus(cloth: Clothes, index: Int){
        if(cloth.status == "clean"){
            clothesModel.changeClothesStatus(clothes: cloth, to: "dirty")
            clothes[index].status = "dirty"
        } else if (cloth.status == "dirty") {
            clothesModel.changeClothesStatus(clothes: cloth, to: "clean")
            clothes[index].status = "clean"
        } else {
            showAlert = true
        }
        dirtyClothesCount = clothesModel.countDirtyClothes()
    }
}
