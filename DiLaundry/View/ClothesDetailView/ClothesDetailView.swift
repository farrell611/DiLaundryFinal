//
//  ClothesDetailView.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/13/23.
//

import SwiftUI

struct ClothesDetailView: View {
    @ObservedObject var viewModel: ClothesDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack{
            ScrollView{
                ForEach(viewModel.dirtyClothes, id: \.self) { clothes in
                    DetailCard(clothes: clothes, viewModel: viewModel)
                        .padding()
                }
                
            }
            
            VStack{
                Spacer()
                Button(action: {
                    if(viewModel.dirtyClothes.count > 0){
                        viewModel.showModal = true
                    } else {
                        viewModel.showAlertEmptyClothes()
                    }
                }){
                    HStack {
                        Text("Pakaian siap dilaundry")
                            .fontWeight(.medium)
                            .padding()
                            .foregroundColor(.white)
                            .font(.caption)
                        Spacer()
                        HStack{
                            Text("\(viewModel.dirtyClothes.count)")
                                .fontWeight(.medium)
                                .font(.caption)
                            Image(systemName: "xmark.bin")
                        }
                        .foregroundColor(.white)
                        .padding()
                    }
                    .background(Color(red: 0.51, green: 0.67, blue: 0.89))
                    .cornerRadius(8)
                    
                }
                
            }
            .padding()
        }
        .navigationTitle("Pakaian Kotor")
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessages), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $viewModel.showModal) {
            VStack(alignment: .leading) {
                Text("Judul Laundry")
                TextField("Name", text: $viewModel.name)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(red: 0.82, green: 0.82, blue: 0.82), lineWidth: 1))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 80, alignment: .topLeading)
                Text("Estimasi Harga")
                TextField("Price", text: $viewModel.price)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(red: 0.82, green: 0.82, blue: 0.82), lineWidth: 1))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 80, alignment: .topLeading)
                DatePicker(selection: $viewModel.selectedDate, in: Date()..., displayedComponents: .date) {
                    Text("Tanggal selesai laundry")
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 80, alignment: .topLeading)
                }
                
                
                Button(action: {
                    
                    let laundrySucceed = self.viewModel.doLaundry()
                    if(laundrySucceed){
                        self.presentationMode.wrappedValue.dismiss()
                        viewModel.showModal = false
                    } else {
                        viewModel.showAlertLaundryExist()
                    }
                }) {
                    Spacer()
                    Text("Lakukan Laundry")
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
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessages), dismissButton: .default(Text("OK")))
            }
        }
        
        .onAppear {
            viewModel.fetchDirtyClothes()
        }
        
    }
}

struct DetailCard: View {
    var clothes: Clothes
    @ObservedObject var viewModel: ClothesDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        HStack {
            Image(uiImage: UIImage(data: clothes.image!)!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120)
                .clipped()
                .cornerRadius(8)
            VStack(alignment: .leading) {
                Text(clothes.category ?? "Others")
                    .fontWeight(.bold)
                HStack{
                    TextField(clothes.detail ?? "", text: $viewModel.detailClothes[viewModel.getInitialClothIndex(cloth: clothes)])
                        .padding(4)
                    Spacer()
                }
                .frame(height: 80)
                .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(red: 0.82, green: 0.82, blue: 0.82), lineWidth: 1))
                HStack {
                    Spacer()
                    Button(action: {
                        //Delete action
                        viewModel.deleteDirtyClothes(cloth: clothes)
                        if(viewModel.dirtyClothes.count == 0){
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    })
                    .padding(.top, 8)
                }
                .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
            }
            .padding(EdgeInsets(top: 20, leading: 4, bottom: 20, trailing: 8))
        }
    }
}

struct ClothesDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ClothesDetailView(viewModel: ClothesDetailViewModel())
    }
}
