//
//  WardrobeView.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/12/23.
//

import SwiftUI
import CoreData

struct WardrobeView: View {
    @ObservedObject var viewModel: WardrobeViewModel
    
    var body: some View {
        NavigationView{
            VStack {
                //MARK: Navigation
                HStack {
                    Button(action: {
                        // handle select button action
                        viewModel.deleteCheckShow = !viewModel.deleteCheckShow
                    }) {
                        Text(viewModel.deleteCheckShow ? "Cancel" : "Select")
                    }
                    Spacer()
                    Text("Pakaianku")
                    Spacer()
                    Button(action: {
                        viewModel.showModal = true
                    }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
                .padding()
                
                //MARK: Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(viewModel.categories, id: \.self) { category in
                            CapsuleButton(title: category, viewModel: viewModel) {
                                viewModel.toggleCategory(category: category)
                            }
                        }
                    }
                    
                    .padding()
                }
                .padding(0)
                
                //MARK: Content
                //MARK: Content - Empty State
                if viewModel.clothes.isEmpty {
                    Spacer()
                    Text(":(\nMaaf Lemari Kamu Kosong\nlanjutkan dengan klik tombol di ujung kanan atas")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.82, green: 0.82, blue: 0.82))
                        .padding()
                }
                
                //MARK: Content - Clothes List
                else {
                    ZStack{
                        ScrollView {
                            VStack (spacing: 20) {
                                ForEach(Array(viewModel.clothes.enumerated()), id: \.offset) { index, item in
                                    HStack(spacing: 20) {
                                        if index % 2 == 0 {
                                            ClothesCard(clothes: item, viewModel: viewModel)
                                                .onTapGesture {
                                                    viewModel.toggleDirtyStatus(cloth: item, index: index)
                                                }
                                            if index + 1 < viewModel.clothes.count {
                                                ClothesCard(clothes: viewModel.clothes[index + 1], viewModel: viewModel)
                                                    .onTapGesture {
                                                        viewModel.toggleDirtyStatus(cloth: viewModel.clothes[index + 1], index: index+1)
                                                    }
                                            }
                                        }
                                        if index == viewModel.clothes.count - 1 && viewModel.clothes.count % 2 != 0 {
                                            Spacer()
                                        }
                                    }
                                }
                            }
                        }
                        //MARK: Button do laundry
                        if (viewModel.dirtyClothesCount > 0){
                            VStack{
                                Spacer()
                                NavigationLink(destination: ClothesDetailView(viewModel: ClothesDetailViewModel()), isActive: $viewModel.navigation){
                                    HStack {
                                        Text("\(viewModel.dirtyClothesCount) Pakaian")
                                            .fontWeight(.medium)
                                            .padding()
                                            .foregroundColor(.white)
                                            .font(.caption)
                                        Spacer()
                                        Image("Dirty")
                                            .padding()
                                    }
                                    .background(Color(red: 0.51, green: 0.67, blue: 0.89))
                                    .cornerRadius(8)
                                    .onTapGesture {
                                        viewModel.navigation = true
                                    }
                                }
                                
                            }
                        }
                        if (viewModel.deleteCheckShow){
                            VStack{
                                Spacer()
                                Button(action: {
                                    viewModel.deleteClothes()
                                }){
                                    HStack {
                                        Spacer()
                                        Text("Delete")
                                            .fontWeight(.medium)
                                            .padding()
                                            .foregroundColor(viewModel.toDeleteClothes.count>0 ? .white : .black)
                                            .font(.caption)
                                        Spacer()
                                    }
                                    .background(viewModel.toDeleteClothes.count>0 ? Color(red: 0.91, green: 0.30, blue: 0.30) : Color(red: 0.93, green: 0.93, blue: 0.93))
                                    .cornerRadius(8)
                                }
                                
                            }
                        }
                    }
                    .padding()
                }
                
                Spacer()
            }
            //MARK: Sheet (add new Cloth)
            .sheet(isPresented: $viewModel.showModal, onDismiss: {
                viewModel.addClothViewModel.image = nil
                viewModel.addClothViewModel.selectedCategory = ""
            }){
                AddClothView(viewModel: viewModel.addClothViewModel)
            }
            .onAppear(){
                viewModel.fetchClothes()
            }
            .alert(isPresented: $viewModel.showAlert){
                Alert(title: Text("Pakaian sedang dilaundry"))
            }
            
        }
        
    }
    
}


struct ClothesCard: View {
    @ObservedObject var clothes: Clothes
    @ObservedObject var viewModel: WardrobeViewModel

    var body: some View {
        VStack {
            if clothes.image != nil {
                Image(uiImage: UIImage(data: clothes.image!)!)
                    .resizable()
                    .frame(width: 172, height: 120)
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(8)
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 200)
            }
            HStack{
                Text(clothes.category ?? "Others")
                    .padding(.top, 10)
                Spacer()
    
                Image(clothes.status == "dirty" ? "Dirty" : "NotDirty")
                    .foregroundColor(clothes.status == "dirty" ? .blue : .gray)
                    .padding(.top, 10)
                
            }
        }
        .frame(width: 172)
        .shadow(color: Color(red: 0.91, green: 0.91, blue: 0.91), radius: 4, x: 0, y: 4)
        .cornerRadius(8)
        .opacity(clothes.status == "on-laundry" ? 0.5 : 1)
        .overlay{
            if(viewModel.deleteCheckShow){
                Button(action: {
                    self.viewModel.toggleToDeleteClothes(clothes: clothes)
                }) {
                    VStack{
                        HStack{
                            Spacer()
                            Image(systemName: self.viewModel.toDeleteClothes.contains(clothes) ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .padding(8)
                        }
                        Spacer()
                        
                    }
                }
                
            }
        }

    }
}

struct CapsuleButton: View {
    let title: String
    @ObservedObject var viewModel: WardrobeViewModel
    var action: (() -> ())?

    var body: some View {
        Button(action: {
            self.action?()
        }) {
            
            Text(title)
                .font(.caption)
                .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                .foregroundColor(viewModel.filterCategories.contains(title) ? .white : Color(red: 0.51, green: 0.67, blue: 0.89))
                .background(viewModel.filterCategories.contains(title) ? Color(red: 0.51, green: 0.67, blue: 0.89) : Color.clear)
                .cornerRadius(100)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
                        .stroke(Color.blue, lineWidth: 1)
                )
        }
    }
}


struct WardrobeView_Previews: PreviewProvider {
    static var previews: some View {
        WardrobeView(viewModel: WardrobeViewModel())
    }
}
