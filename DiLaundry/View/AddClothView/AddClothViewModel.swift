//
//  AddClothViewModel.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/22/23.
//

import SwiftUI
import CoreData

class AddClothViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var showSheet: Bool = false
    @Published var showSelectionSheet: Bool = false
    @Published var selectedCategory: String = ""
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    let categories = ["Outer", "Shirt", "Jacket", "Dress", "Cardigan", "Pants", "Socks", "Underwear", "Others"]
    private let clothesModel = ClothesModel()
    
    var onSave: (() -> Void)?
    var addedStatus: String?
    
//    func selectImage() {
//        showSheet = true
//    }
    
    var isFormValid: Bool {
        return image != nil && !selectedCategory.isEmpty
    }
    
    func saveClothes() {
        if let image = image {
            let data = image.jpegData(compressionQuality: 0.1)
            if let data = data {
                let success = clothesModel.saveClothes(image: data, category: selectedCategory, status: addedStatus ?? "")
                if(success) { onSave?() }
            }
        }
    }
}
