//
//  AddClothView.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/22/23.
//

import SwiftUI

struct AddClothView: View {
    @ObservedObject var viewModel: AddClothViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text("Masukan foto dan kategori pakaian")
                .bold()
            HStack {
                if viewModel.image == nil {
                    Image(systemName: "plus")
                        .foregroundColor(Color(red: 0.85, green: 0.85, blue: 0.85))
                } else {
                    Image(uiImage: viewModel.image!)
                        .resizable()
                        .scaledToFill()
                }
            }
            .onTapGesture {
                viewModel.showSelectionSheet.toggle()
            }
            .frame(width: 120, height: 84)
            .clipped()
            .overlay(RoundedRectangle(cornerRadius: 4).stroke(Color(red: 0.82, green: 0.82, blue: 0.82), lineWidth: 1))
            .padding()
            
            VStack {
                ForEach(0..<3) { row in
                    HStack {
                        ForEach(0..<3) { col in
                            
                            Button(action: {
                                viewModel.selectedCategory = viewModel.categories[(row * 3) + col]
                            }) {
                                Text(viewModel.categories[(row * 3) + col])
                                    .frame(width: 80, height: 28)
                                    .font(.caption)
                                    .padding()
                                    .background(Color(red: 0.91, green: 0.91, blue: 0.91))
                                    .cornerRadius(8)
                                    .foregroundColor(viewModel.selectedCategory == viewModel.categories[(row * 3) + col] ? Color.blue : Color.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(viewModel.selectedCategory == viewModel.categories[(row * 3) + col] ? Color.blue : Color.clear, lineWidth: 1)
                                    )
                            }
                        }
                    }
                }
            }
            .padding()
            
            Spacer()
            Button(action: {
                viewModel.saveClothes()
            }) {
                Spacer()
                Text("Confirm")
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
        .actionSheet(isPresented: $viewModel.showSelectionSheet) {
            ActionSheet(title: Text("Select Image"), buttons: [
                .default(Text("Camera")) {
                    // camera action here
                    viewModel.sourceType = .camera
                    viewModel.showSheet = true
                },
                .default(Text("Use File")) {
                    // use file action here
                    viewModel.sourceType = .photoLibrary
                    viewModel.showSheet = true
                },
                .cancel()
            ])
        }
        //MARK: Image Picker Sheet
        .sheet(isPresented: $viewModel.showSheet) {
            ImagePicker(image: $viewModel.image, isShown: $viewModel.showSheet, sourceType: viewModel.sourceType)
        }
    }
}

struct AddClothView_Previews: PreviewProvider {
    static var previews: some View {
        AddClothView(viewModel: AddClothViewModel())
    }
}
