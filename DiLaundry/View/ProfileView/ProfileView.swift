//
//  ProfileView.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/12/23.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    var body: some View {
        VStack {
            Text("Profile")
                .padding()
            
            VStack{
                HStack{
                    Text("Nama")
                        .fontWeight(.bold)
                    Spacer()
                }
                TextField("Nama", text: $viewModel.name)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(red: 0.82, green: 0.82, blue: 0.82), lineWidth: 1))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 80, alignment: .topLeading)
                
                HStack{
                    Text("Nomor Telepon")
                        .fontWeight(.bold)
                    Spacer()
                }
                TextField("Nomor Telepon", text: $viewModel.phoneNumber)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(red: 0.82, green: 0.82, blue: 0.82), lineWidth: 1))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 80, alignment: .topLeading)
                
                HStack{
                    Text("Alamat")
                        .fontWeight(.bold)
                    Spacer()
                }
                TextField("Alamat", text: $viewModel.address)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(red: 0.82, green: 0.82, blue: 0.82), lineWidth: 1))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 80, alignment: .topLeading)
                
              
                Button(action: {
                    UIApplication.shared.windows.first(where: { $0.isKeyWindow})?.endEditing(true)
                    self.viewModel.saveUser()
                }) {
                    Spacer()
                    Text("Simpan Pengaturan")
                        .fontWeight(.medium)
                    Spacer()
                }
                .foregroundColor(.white)
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
            
            Spacer()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Data berhasil diubah"))
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel())
    }
}
