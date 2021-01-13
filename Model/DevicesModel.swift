//
//  DevicesModel.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 08/01/2021.
//

import Foundation
import Combine
import SwiftUI

struct Device: Hashable, Decodable {
    var device_id: String
    var device_name: String
    var identifier: String
}

// Now conform to Identifiable we need to change the name of the variable to id
extension Device: Identifiable {
    var id: String { return device_id }
}


class GetDevices: ObservableObject {
    
    @Published var lokas_ids = [Device]()
    @Published var donefetchingData = true
   
    
    init() {
        let url = URL(string: "https://lokagetlocations-uyiltasaia-ew.a.run.app/get_devices.php")!
        URLSession.shared.dataTask(with: url) {(data, response, error) in
             do {
                 if let d = data {
                    let decodedData = try JSONDecoder().decode([Device].self, from: d)
                    DispatchQueue.main.async {
                        self.lokas_ids = decodedData
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



class GetDevices_by_identifier: ObservableObject {
    
    @Published var lokas_ids = [Device]()
    @Published var donefetchingData = true
    @Published var showRefreshView = true
   
    @Published var identifier: String = "" {
        didSet {
            fetchdevices()
        }
    }
   
    func fetchdevices() {
        let urlString = "https://lokagetlocations-uyiltasaia-ew.a.run.app/get_devices_identifier.php?identifier=\(identifier)"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil{
                    let decoder = JSONDecoder()
                    if let safeData = data{
                        do{
                            let results = try decoder.decode([Device].self, from: safeData)
                            DispatchQueue.main.async {
                                self.lokas_ids = results
                                self.donefetchingData = false
                                self.showRefreshView = false
                                print("Numero de devices = \(results.count)")
                            }
                        } catch{
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}


struct Device_unique: Hashable, Decodable {
    var device: String
}

// Now conform to Identifiable we need to change the name of the variable to id
extension Device_unique: Identifiable {
    var id: String { return device }
}



class GetUniqueDevices: ObservableObject {
    
    @Published var lokas_ids = [Device_unique]()
    @Published var deviceFound = false
   
    @Published var device: String = "" {
        didSet {
            fetchdevice()
        }
    }
   
    func fetchdevice() {
        let urlString = "https://lokagetlocations-uyiltasaia-ew.a.run.app/get_devices_unique.php?device=\(device)"
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil{
                    let decoder = JSONDecoder()
                    if let safeData = data{
                        do{
                            let results = try decoder.decode([Device_unique].self, from: safeData)
                            DispatchQueue.main.async {
                                print("Numero de devices unicos é de = \(results.count)")
                                self.lokas_ids = results
                                if self.lokas_ids.count == 1 {
                                    self.deviceFound = true
                                }else
                                {
                                    self.deviceFound = false
                                }
                                print("O estado da variavel de devices é de \(self.deviceFound)")
                            }
                        } catch{
                            print(error)
                        }
                    }
                }
            }
            task.resume()
        }
    }
}




 





