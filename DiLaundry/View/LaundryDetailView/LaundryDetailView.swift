//
//  LaundryDetailView.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/15/23.
//

import SwiftUI

struct LaundryDetailView: View {
    @ObservedObject var viewModel: LaundryDetailViewModel
    
    var body: some View {
        ScrollView{
            //MARK: Logo
            HStack{
                Image("Logo")
                    .padding()
                Text("Dilaundry")
                    .bold()
                    .font(.title3)
                Spacer()
            }
            
            //MARK: Laundry Name
            HStack{
                Text("\(viewModel.laundry.name!)")
                    .font(.title2)
                    .bold()
                    .padding(EdgeInsets(top: 4, leading: 20, bottom: 4, trailing: 20))
                Spacer()
            }
            
            //MARK: User Name
            HStack{
                Text("\(viewModel.user.name!)")
                    .font(.caption)
                    .padding(EdgeInsets(top: 4, leading: 20, bottom: 2, trailing: 20))
                Spacer()
            }
            
            //MARK: Phone Number
            HStack{
                Text("\(viewModel.user.phoneNumber!)")
                    .font(.caption)
                    .padding(EdgeInsets(top: 2, leading: 20, bottom: 2, trailing: 20))
                Spacer()
            }
            
            //MARK: Laundry Price
            HStack{
                Text("\(viewModel.laundry.price!) IDR")
                    .font(.caption)
                    .padding(EdgeInsets(top: 2, leading: 20, bottom: 2, trailing: 20))
                Spacer()
            }
            
            //MARK: User Address
            HStack{
                Text("\(viewModel.user.address!)")
                    .font(.caption)
                    .bold()
                    .padding(EdgeInsets(top: 2, leading: 20, bottom: 20, trailing: 20))
                Spacer()
            }
            
            //MARK: Clothes List
            ForEach(viewModel.laundry.clothesList?.allObjects as! [Clothes], id: \.self) { clothes in
                DetailLaundryCard(clothes: clothes, viewModel: viewModel)
                    .padding()
            }
            
            //MARK: Retrieve Clothes
            Button(action: {
                viewModel.doneLaundry()
            }){
                HStack{
                    Spacer()
                    Text("Pakaian Sudah Diambil")
                    Spacer()
                }
                .padding()
                .foregroundColor(.white)
            }
            .background(Color(red: 0.51, green: 0.67, blue: 0.89))
            .cornerRadius(8)
            .padding(EdgeInsets(top: 20, leading: 20, bottom: 0, trailing: 20))
            
            //MARK: Send Report
            Button(action: {
                viewModel.showShareSheet = true
            }){
                HStack{
                    Spacer()
                    Text("Kirim Link Report")
                    Spacer()
                }
                .padding()
                .foregroundColor(.white)
            }
            .background(Color(red: 0.21, green: 0.83, blue: 0.40))
            .cornerRadius(8)
            .padding()
        }
        .navigationTitle("History")
        .sheet(isPresented: $viewModel.showShareSheet) {
            ActivityView(activityItems: ["https://laundry.umkmbedigital.com/public/report/\(viewModel.laundry.id?.uuidString ?? "")"])
        }
        .alert(isPresented: $viewModel.showAlert){
            Alert(title: Text("Berhasil Menerima Pakaian"))
        }
    }
}

struct DetailLaundryCard: View {
    var clothes: Clothes
    @ObservedObject var viewModel: LaundryDetailViewModel
    var body: some View {
        HStack {
            Image(uiImage: UIImage(data: clothes.image!)!)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120)
                .clipped()
                .cornerRadius(8)
            VStack(alignment: .leading) {
                HStack{
                    Text(clothes.category ?? "Others")
                        .fontWeight(.bold)
                    Spacer()
                    
                }
                
                Text(clothes.status == "on-laundry" ? "Belum diambil" : "Sudah diambil")
                    .font(.caption2)
                    .padding(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .foregroundColor(clothes.status == "on-laundry" ? Color(red: 0.47, green: 0.45, blue: 0.45) : .white)
                    .background(clothes.status == "on-laundry" ? Color(red: 0.93, green: 0.93, blue: 0.93) : Color(red: 0.21, green: 0.83, blue: 0.40))
                    .cornerRadius(100)
                HStack{
                    Text(clothes.detail ?? "")
                        .font(.caption2)
                        .foregroundColor(Color(red: 0.47, green: 0.45, blue: 0.45))
                    Spacer()
                }
                
                HStack {
                    Button(action: { 
                        if(clothes.status == "on-laundry"){
                            viewModel.toggleToRetrieveClothes(clothes: clothes)
                        }
                    }) {
                        Image(systemName: viewModel.toRetrieveClothes.contains(clothes) || clothes.status != "on-laundry" ? "checkmark.square" : "square")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.green)
                    }
                    Text("Tandai sudah diambil")
                        .foregroundColor(.black)
                        .font(.caption)
                }
                .padding(EdgeInsets(top: 12, leading: 0, bottom: 0, trailing: 0))
            }
            .padding(EdgeInsets(top: 20, leading: 4, bottom: 20, trailing: 8))
        }
    }
}


struct ActivityView: UIViewControllerRepresentable {
    var activityItems: [Any]

    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityView>) -> UIActivityViewController {
        
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        activityViewController.excludedActivityTypes = []
        
        return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ActivityView>) {
    }
}

struct LaundryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LaundryDetailView(viewModel: LaundryDetailViewModel(laundry: Laundry()))
    }
}
