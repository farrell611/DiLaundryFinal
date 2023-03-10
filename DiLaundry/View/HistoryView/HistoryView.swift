//
//  HistoryView.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/13/23.
//

import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    
    var body: some View {
        NavigationView{
            VStack{
                //MARK: History Title
                HStack {
                    Text("History")
                        .font(.largeTitle)
                        .fontWeight(.medium)
                    Spacer()
                }
                
                ScrollView{
                    
                    ForEach(viewModel.laundries, id: \.self) { laundry in
                        NavigationLink(destination: LaundryDetailView(viewModel: LaundryDetailViewModel(laundry: laundry))){
                            HistoryCard(laundry: laundry)
                        }
                    }
                    
                }

                
                Spacer()
            }
            .padding()
            .onAppear() {
                viewModel.fetchLaundry()
            }
            
        }
    }
}

//MARK: History Card
struct HistoryCard: View {
    
    @ObservedObject var laundry: Laundry
    
    private var statusColor: Color {
        switch laundry.status {
        case "ON PROGRESS":
            return Color(red: 0.98, green: 0.98, blue: 0.98)
        case "PROBLEM":
            return Color(red: 0.93, green: 0.73, blue: 0.34)
        case "DONE":
            return Color(red: 0.51, green: 0.67, blue: 0.89)
        default:
            return Color.gray
        }
    }
    
    private var statusForegroundColor: Color {
        switch laundry.status {
        case "DONE":
            return .white
        default:
            return .black
        }
    }
    
    var body: some View {
        VStack{
            HStack{
                VStack{
                    HStack {
                        Text("Tanggal Selesai, \(laundry.dateString ?? "")")
                            .fontWeight(.medium)
                            .font(.caption)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 4, trailing: 20))
                    HStack {
                        Text(laundry.name ?? "")
                            .font(.title)
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    
                }
                
                Image(systemName: "chevron.forward")
                    .resizable()
                    .frame(width: 16, height: 28)
                    .foregroundColor(.black)
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 20))

                
            }
            
            
        }
        .padding(EdgeInsets(top: 4, leading: 0, bottom: 20, trailing: 0))
        .background(statusColor)
        .cornerRadius(4)
        .foregroundColor(statusForegroundColor)
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView(viewModel: HistoryViewModel())
    }
}
