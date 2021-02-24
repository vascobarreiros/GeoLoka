//
//  DevicesDetails.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 08/01/2021.
//

import Foundation

// This is the structure for the Devices Data commming from the API.

struct loka_result: Codable {
    var date: String
    var time: String
    var unix_time: Int
    var seqNumber : Int
    var lat: Double
    var lng: Double
    var device: String
    var accuracy: Double
    var info: String
    var temperature : Double?
    var battery : Float?
}


// Now conform to Identifiable
extension loka_result: Identifiable {
    public var id: Int { return unix_time }
}

var temp = ""

class GetAllDevicesDetails: ObservableObject {
    
    @Published var devices_details = [loka_result]()
    @Published var donefetchingData = true
    @Published var identifier : String = ""
    @Published var delta_hours : Int = 24
   
    
    init() {
        let url = URL(string: "https://lokaiosapp-k4sm7ymkwq-ew.a.run.app/get_locations_new.php?identifier=\(self.identifier)&hours=\(self.delta_hours)")!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
             do {
                 if let d = data {
                    let decodedData = try JSONDecoder().decode([loka_result].self, from: d)
                    DispatchQueue.main.async {
                        self.devices_details = decodedData
                        self.donefetchingData = false
                     }
                 } else {
                     print("No data")
                 }
             } catch {
                 print("Error Get lokas")
             }
         }.resume()
     }
 }


class SpecificDeviceDetails: ObservableObject {
    
    @Published var devices_details = [loka_result]()
    @Published var donefetchingData = true
    @Published var device : String = ""
    @Published var delta_hours : Int = 24
   
    
    init() {
        let url = URL(string: "https://lokaiosapp-k4sm7ymkwq-ew.a.run.app/get_locations_with_double_entry.php?device=device\(self.device)&hours=\(self.delta_hours)")!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
             do {
                 if let d = data {
                    let decodedData = try JSONDecoder().decode([loka_result].self, from: d)
                    DispatchQueue.main.async {
                        self.devices_details = decodedData
                        self.donefetchingData = false
                     }
                 } else {
                     print("No data")
                 }
             } catch {
                 print("Error Get lokas")
             }
         }.resume()
     }
 }


class FetchAllLoka_Data: ObservableObject {
    
    @Published var allLokas = [loka_result]()
    @Published var donefetchingData = true

    init() {
        let url = URL(string: "https://lokaiosapp-k4sm7ymkwq-ew.a.run.app/get_locations.php")!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
             do {
                 if let d = data {
                    let decodedData = try JSONDecoder().decode([loka_result].self, from: d)
                    DispatchQueue.main.async {
                        self.allLokas = decodedData
                        self.donefetchingData = false
                     }
                 } else {
                     print("No data")
                 }
             } catch {
                 print("Error Get lokas")
             }
         }.resume()
     }
 }
