//
//  Homepage.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/6/23.
//

import SwiftUI

struct HomepageView: View {
    @ObservedObject var viewModel: HomepageViewModel
    @ObservedObject var wardrobeViewModel: WardrobeViewModel = WardrobeViewModel()
    @Binding var selectedTab: Int
    
    private var statusColor: Color {
        switch viewModel.status {
        case "tidak ada laundry":
            return Color(red: 0.80, green: 0.80, blue: 0.80)
        case "laundry berjalan":
            return Color(red: 0.34, green: 0.58, blue: 0.93)
        case "laundry siap diambil":
            return Color(red: 0.93, green: 0.73, blue: 0.34)
        default:
            return Color.gray
        }
    }
    
    var body: some View {
        VStack {
            //MARK: Welcoming Title
            HStack {
                Text("Halo, \(viewModel.name)")
                    .font(.largeTitle)
                    .fontWeight(.medium)
                Spacer()
            }
            .padding()
            
            //MARK: Laundry
            VStack{
                NavigationLink(destination: viewModel.fetchOngoing() != nil ? LaundryDetailView(viewModel: LaundryDetailViewModel(laundry: viewModel.fetchOngoing())) : nil){
                    VStack{
                        HStack {
                            Text("Laundry Berjalan")
                                .fontWeight(.medium)
                                .font(.caption)
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 4, trailing: 20))
                        HStack {
                            Text("\(viewModel.status)")
                                .font(.title)
                                .fontWeight(.bold)
                            Spacer()
                        }
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                        
                        
                    }
                    .padding(EdgeInsets(top: 4, leading: 0, bottom: 20, trailing: 0))
                    .background(statusColor)
                    .cornerRadius(4)
                    .foregroundColor(.white)
                }
            }
            .padding()
            
            //MARK: Wardrobe
            VStack{
                //MARK: Wardrobe - Title
                HStack {
                    Text("Pakaian Wardrobe")
                        .fontWeight(.medium)
                        .font(.title3)
                    Spacer()
                    Button(action: {
                        selectedTab = 2
                        wardrobeViewModel.filterCategories = ["Shirt", "Pants"]
                        wardrobeViewModel.fetchClothes()
                    }){
                        Text("View All")
                            .fontWeight(.medium)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                }
                //MARK: Wardrobe - Content
                HStack{
                    ZStack{
                        VStack{
                            HStack {
                                Text("Jumlah Baju")
                                    .fontWeight(.medium)
                                    .font(.caption)
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 20, leading: 20, bottom: 4, trailing: 20))
                            HStack {
                                Text("\(viewModel.bajuCount)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text("Baju")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                            
                            
                        }
                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 20, trailing: 0))
                        .background(Color(red: 0.34, green: 0.58, blue: 0.93))
                        .cornerRadius(4)
                        .foregroundColor(.white)
                        
                        Image("Shirt")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.trailing)
                            .padding(.bottom)
                            .offset(x: 72, y: 36)
                            .zIndex(1)
                        
                    }
                    Spacer()
                    ZStack{
                        VStack{
                            HStack {
                                Text("Jumlah Celana")
                                    .fontWeight(.medium)
                                    .font(.caption)
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 20, leading: 20, bottom: 4, trailing: 20))
                            HStack {
                                Text("\(viewModel.celanaCount)")
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text("Celana")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                Spacer()
                            }
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                            
                            
                        }
                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 20, trailing: 0))
                        .background(Color(red: 0.34, green: 0.58, blue: 0.93))
                        .cornerRadius(4)
                        .foregroundColor(.white)
                        
                        Image("Short")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(.trailing)
                            .padding(.bottom)
                            .offset(x: 72, y: 36)
                            .zIndex(1)
                        
                    }
                    
                }
                
            }
            .padding()
            
            //MARK: Dirty
            VStack{
                //MARK: Dirty - Title
                HStack {
                    Text("Pakaian Kotormu")
                        .fontWeight(.medium)
                        .font(.title3)
                    Spacer()
                    Button(action: {
                        selectedTab = 2
                        wardrobeViewModel.navigation = true
                    }){
                        Text("View All")
                            .fontWeight(.medium)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                }
                //MARK: Dirty - Content
                VStack{
                    HStack {
                        Text("Jumlah Pakaian Kotor")
                            .fontWeight(.medium)
                            .font(.caption)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 4, trailing: 20))
                    HStack {
                        Text("\(viewModel.dirtyCount)")
                            .font(.title)
                            .fontWeight(.bold)
                        Text("Pakaian")
                            .font(.caption)
                            .fontWeight(.medium)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 24, bottom: 0, trailing: 24))
                    
                    
                }
                .padding(EdgeInsets(top: 4, leading: 0, bottom: 20, trailing: 0))
                .background(Color(red: 0.51, green: 0.67, blue: 0.89))
                .cornerRadius(4)
                .foregroundColor(.white)
                
                Spacer()
                
                //MARK: Add Dirty Button
                Button(action: {
                    // Add outfit action goes here
                    viewModel.showModal = true
                }) {
                    Spacer()
                    Text("Tambah Pakaian Kotor")
                        .fontWeight(.medium)
                    Spacer()
                }
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                
            }
            .padding()
            
            Spacer()
        }
        .sheet(isPresented: $viewModel.showModal, onDismiss: {
            viewModel.addClothViewModel.image = nil
            viewModel.addClothViewModel.selectedCategory = ""
        }){
            AddClothView(viewModel: self.viewModel.addClothViewModel)
        }
        .onAppear(){
            viewModel.fetch()
        }
        
    }
}


struct Homepage_Previews: PreviewProvider {
    @State static var selectedTab = 0
    static var previews: some View {
        HomepageView(viewModel: HomepageViewModel(), selectedTab: $selectedTab)
    }
}

