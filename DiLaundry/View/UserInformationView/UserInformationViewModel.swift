//
//  UserInformationViewModel.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/11/23.
//

import CoreData
import SwiftUI

class UserInformationViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var address: String = ""
    @Published var phoneNumber: String = ""
    var onSave: (() -> Void)?
    
    var isFormValid: Bool {
        return !name.isEmpty && !address.isEmpty && !phoneNumber.isEmpty
    }
    
    func saveUser() {
        let userModel = UserModel()
        userModel.saveUser(name: name, address: address, phoneNumber: phoneNumber)
        onSave?()
    }
}

