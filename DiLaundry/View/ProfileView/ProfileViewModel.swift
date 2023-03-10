//
//  ProfileViewModel.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/12/23.
//
import CoreData
import SwiftUI

class ProfileViewModel: ObservableObject{
    @Published var name: String = ""
    @Published var address: String = ""
    @Published var phoneNumber: String = ""
    @Published var showAlert: Bool = false
    private var userModel: UserModel = UserModel()
    
    init() {
        if let user = userModel.fetchFirstUser(){
            self.name = user.name!
            self.address = user.address!
            self.phoneNumber = user.phoneNumber!
        }
    }
    
    var isFormValid: Bool {
        return !name.isEmpty && !address.isEmpty && !phoneNumber.isEmpty
    }
    
    func saveUser() {
        userModel.updateUser(name: self.name, address: self.address, phoneNumber: self.phoneNumber)
        showAlert = true
    }
}
