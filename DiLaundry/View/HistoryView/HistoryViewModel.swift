//
//  HistoryViewModel.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/13/23.
//

import CoreData

class HistoryViewModel: ObservableObject{
    //    laundry.clothesList?.allObjects as? [Clothes]
    @Published var laundries: [Laundry] = []
    private var laundryModel: LaundryModel = LaundryModel()
    private var dateFormatter: DateFormatter = DateFormatter()
    
    init() {
        fetchLaundry()
//        laundryModel.deleteAllLaundries()
    }
    
    func fetchLaundry(){
        if let laundry = laundryModel.fetchOngoingLaundry() {
//            print(laundry)
            if let id = laundry.id?.uuidString{
//                print(id)
                LaundryAPI(laundry_id: id).fetchAPI { date in
                    self.laundryModel.changeLaundryDate(laundry: laundry, dateString: date)
                }
            }
        }
        self.laundries = self.laundryModel.fetchLaundry()
    }
}
