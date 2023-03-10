//
//  ClothesAPI.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/21/23.
//

import Foundation

struct ClothesAPI: Encodable, Decodable {
    let cloth_id: String
    let detail: String
    let category: String
    let status: String
    let image: Data

    init(clothes: Clothes) {
        self.cloth_id = clothes.id?.uuidString ?? ""
        self.detail = clothes.detail ?? ""
        self.category = clothes.category ?? ""
        self.status = clothes.status ?? ""
        self.image = clothes.image!
    }
    
    func updateAPI(){
        let api = APIMiddleware(baseURL: "https://laundry.umkmbedigital.com/public/api")
        api.send(object: self, to: "/cloth/add-cloth")
    }

}
