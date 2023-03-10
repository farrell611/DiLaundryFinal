//
//  LaundryAPI.swift
//  DiLaundry
//
//  Created by Theodorus Farrell on 1/21/23.
//

import Foundation

struct LaundryAPI: Encodable, Decodable {
    var laundry_id: String = ""
    var name: String = ""
    var finish_date: String
    var status: String = ""
    var price: String = ""
    var clothes: [String] = []
    var customer_name: String = ""
    var customer_address: String = ""
    var customer_phone_number: String = ""
    
    init(laundry_id: String){
        self.laundry_id = laundry_id
        self.finish_date = ""
    }

    init(laundry: Laundry, user: User) {
        self.laundry_id = laundry.id?.uuidString ?? ""
        self.name = laundry.name ?? ""
        self.finish_date = laundry.dateString ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.finish_date = dateFormatter.string(from: laundry.date ?? Date())
        
        self.status = laundry.status ?? ""
        self.price = laundry.price ?? ""
        
        self.clothes = []
        
        let clothes = laundry.clothesList?.allObjects as! [Clothes]
        for c in clothes{
            let clothesAPI = ClothesAPI(clothes: c)
            self.clothes.append(clothesAPI.cloth_id)
        }
        
        
        self.customer_name = user.name ?? ""
        self.customer_address = user.address ?? ""
        self.customer_phone_number = user.phoneNumber ?? ""
    }

    func updateAPI(){
        let api = APIMiddleware(baseURL: "https://laundry.umkmbedigital.com/public/api")
        api.send(object: self, to: "/laundry/add-laundry")
    }
    
    func fetchAPI(completion: @escaping (String) -> Void) {
        let url = URL(string: "https://laundry.umkmbedigital.com/public/api/laundry/get-date")!
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let json: [String: Any] = ["laundry_id": laundry_id]
        let jsonData = try! JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print(error)
                } else {
                    if let data = data {
                        let json = try? JSONSerialization.jsonObject(with: data, options: [])
                        if let dictionary = json as? [String: Any] {
                            if let status = dictionary["status"] as? Int, status == 200 {
                                if let date = dictionary["data"] as? String {
                                    completion(date)
                                }
                            }
                        }
                    }
                }
            }
        }.resume()
    }
    
}
