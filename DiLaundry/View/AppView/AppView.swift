//
//  AppView.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/12/23.
//

import SwiftUI
import CoreData

struct AppView: View {
    @ObservedObject var viewModel: AppViewModel = AppViewModel()
    @ObservedObject var wardrobeViewModel: WardrobeViewModel = WardrobeViewModel()
    @State private var selectedTab = 0
    @State private var currentPage = 0
    
    var body: some View {
        if viewModel.isUserExist{
            TabView(selection: $selectedTab) {
                HomepageView(viewModel: HomepageViewModel(), wardrobeViewModel: wardrobeViewModel, selectedTab: $selectedTab)
                    .tabItem {
                        Image(systemName: "house")
                        Text("Homepage")
                    }
                    .tag(0)
                
                
                HistoryView(viewModel: HistoryViewModel())
                    .tabItem {
                        Image(systemName: "clock")
                        Text("History")
                    }
                    .tag(1)
                
                WardrobeView(viewModel: wardrobeViewModel)
                    .tabItem {
                        Image(systemName: "xmark.bin")
                        Text("Wardrobe")
                    }
                    .tag(2)
                
                ProfileView(viewModel: ProfileViewModel())
                    .tabItem {
                        Image(systemName: "person")
                        Text("User")
                    }
                    .tag(3)
            }
        } else {
            VStack {
                if currentPage == 0 {
                    OnboardingPageView(title: "Kelola Pakaian Laundry", description: "Masukan pakaian kotor anda untuk membantu mengatur pakaian yang anda ingin cuci. ", image: "tshirt.fill")
                        .padding()
                } else if currentPage == 1 {
                    OnboardingPageView(title: "Ingat untuk mengambil laundry", description: "Membantu untuk mengingatkan anda untuk mengambil pakaian laundry yang telah selesai.", image: "clock.badge.checkmark.fill")
                        .padding()
                } else if currentPage == 2 {
                    OnboardingPageView(title: "Periksa catatan pakaian", description: "Membantu untuk memeriksa pakaian yang sudah diambil menghindari kehilangan pakaian .", image: "note.text")
                        .padding()
                } else {
                    UserInformationView{
                        viewModel.isUserExist = true
                    }
                }
                if currentPage <= 2 {
                    Spacer()
                    HStack {
                        if currentPage == 0 {
                            VStack{
                                Button(action: {
                                    self.currentPage += 1
                                }) {
                                    Spacer()
                                    Text("Next")
                                    Spacer()
                                }
                                .padding()
                                .background(Color(red: 0.51, green: 0.67, blue: 0.89))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                Button(action: {
                                    // skip to UserInformationView
                                    self.currentPage = 3
                                }) {
                                    Spacer()
                                    Text("Skip")
                                    Spacer()
                                }
                            }
                        } else if currentPage == 1 {
                            VStack{
                                Button(action: {
                                    self.currentPage += 1
                                }) {
                                    Spacer()
                                    Text("Next")
                                    Spacer()
                                }
                                .padding()
                                .background(Color(red: 0.51, green: 0.67, blue: 0.89))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                Button(action: {
                                    // skip to UserInformationView
                                    self.currentPage = 3
                                }) {
                                    Spacer()
                                    Text("Skip")
                                    Spacer()
                                }
                            }
                        } else{
                            Button(action: {
                                // go to UserInformationView
                                self.currentPage += 1
                            }) {
                                Spacer()
                                Text("Get Started")
                                Spacer()
                            }
                            .padding()
                            .background(Color(red: 0.51, green: 0.67, blue: 0.89))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                    }
                    .padding()
                    CarouselIndicator(currentPage: $currentPage, totalPages: 3)
                }
                
            }
        }
    }

    

}

struct OnboardingPageView: View {
    var title: String
    var description: String
    var image: String

    var body: some View {
        VStack {
            Spacer()
            HStack{
                Spacer()
                Image(systemName: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .padding()
                Spacer()
                
            }
            HStack{
                Text(title)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .padding()
                Spacer()
                
            }
            HStack{
                Text(description)
                    .padding()
                Spacer()
            }
        }
    }
}

struct CarouselIndicator: View {
    @Binding var currentPage: Int
    var totalPages: Int

    var body: some View {
        HStack {
            ForEach(0..<totalPages) { index in
                Circle()
                    .fill(index == self.currentPage ? Color.black : Color.gray)
                    .frame(width: 8, height: 8)
                    .onTapGesture {
                        currentPage = index
                    }
            }
        }
        .padding()
    }
}


struct AppView_Previews: PreviewProvider {
    static var previews: some View {
        AppView()
    }
}
