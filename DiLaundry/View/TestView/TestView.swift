//
//  TestView.swift
//  OutfitTracker
//
//  Created by Ttaa on 1/11/23.
//

import SwiftUI
import CoreData

struct TestView: View {
    var body: some View {
        VStack {
            Text("All Users")
                .font(.title)
            
            List {
                ForEach(fetchUsers(), id: \.self) { user in
                    VStack(alignment: .leading) {
                        Text("Name: \(user.name ?? "")")
                        Text("Address: \(user.address ?? "")")
                        Text("Phone: \(user.phoneNumber ?? "")")
                    }
                }
            }
        }
    }
    
    func fetchUsers() -> [User] {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try PersistenceController.shared.container.viewContext.fetch(fetchRequest)
            return users
        } catch {
            print(error)
            return []
        }
    }
}


struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

