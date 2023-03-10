//
//  UserInformationView.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/11/23.
//

import SwiftUI

struct UserInformationView: View {
    @ObservedObject var viewModel: UserInformationViewModel
    
    var body: some View {
        VStack {
            Text("Isi Data Pribadi")
                .font(.largeTitle)
                .fontWeight(.medium)
                .padding()
            Spacer()
            
            VStack{
                TextField("Nama", text: $viewModel.name)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(red: 0.82, green: 0.82, blue: 0.82), lineWidth: 1))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 80, alignment: .topLeading)
                
                TextField("Nomor Telepon", text: $viewModel.phoneNumber)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(red: 0.82, green: 0.82, blue: 0.82), lineWidth: 1))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 80, alignment: .topLeading)
                
                TextField("Alamat", text: $viewModel.address)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(red: 0.82, green: 0.82, blue: 0.82), lineWidth: 1))
            }
            
            Spacer()
            Button(action: {
                UIApplication.shared.windows.first(where: { $0.isKeyWindow})?.endEditing(true)
                self.viewModel.saveUser()
            }) {
                Spacer()
                Text("Next")
                    .fontWeight(.medium)
                Spacer()
            }
            .padding()
            .disabled(viewModel.isFormValid == false)
            .background(
                viewModel.isFormValid == false ?
                Color(red: 0.51, green: 0.67, blue: 0.89) : .blue
            )
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding()
    }
    
    init(onSave: @escaping () -> Void) {
        viewModel = UserInformationViewModel()
        viewModel.onSave = onSave
    }
}

struct UserInformationView_Previews: PreviewProvider {
    static var previews: some View {
        UserInformationView{
            
        }
    }
}
