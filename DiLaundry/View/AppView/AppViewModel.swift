//
//  AppViewModel.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 24/01/23.
//

import CoreData

class AppViewModel: ObservableObject {
    var userInformationViewModel: UserInformationViewModel = UserInformationViewModel()
    @Published var isUserExist: Bool = false
    
    init() {
        userInformationViewModel = UserInformationViewModel()
        userInformationViewModel.onSave = { [weak self] in
            self?.isUserExist = true
        }
        self.isUserExist = UserModel().checkIfUsersExist()
        
//        UserModel().deleteAllUsers()
    }
    
}
