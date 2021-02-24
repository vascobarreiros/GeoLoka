//
//  DeviceDetailsView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 23/02/2021.
//

import SwiftUI

struct DeviceDetailsView: View {
    
    
    @State private var data = [Device_Details]()
    var escolha : String
    
    
    var body: some View {
        
        VStack  {
          Text ("Device Details").font(.headline)
            List {
                ForEach (data, id: \.device) { item in
                    
                      Text("Device = \(String(Int(escolha , radix: 16)!))")
                      Text("")
                    HStack {
                        Text("Last update = \(item.date)")
                        Text(item.hour)
                    }
                      Text("Device Type = \(item.type)")
                      Text("Firmware Version = \(item.ver1 ?? "N/A") . \(item.ver2)")
                    Text("Location check interval [minutes] = \(item.scanInterval ?? 0)")
                        let loka_reset_interval = (item.resetInterval ?? 0)/60
                        Text("Reset/Resend interval [hours] = \(loka_reset_interval)")
                    switch item.program {
                    
                    case "1":
                            Text("Configuration Program = Tracker")
                    case "2":
                             Text("Configuration Program = Movement Sensor")
                    case "3":
                             Text("Configuration Program = N/A")
                    case "4":
                             Text("Configuration Program = Temperature Sensor")
                    case "5":
                             Text("Configuration Program = Tracker & Temperature")
                    default:
                        Text("Unknown")
                        }
                    if item.gps == 1 {
                        Text("GPS its Enabled")
                    } else {
                    Text("GPS its not Enabled")
                    }
                        
                            }
           
            
            }.onAppear(perform: {
            loadData()
    })
        }
        
        
    }
}


extension DeviceDetailsView
{
    func loadData() {
        
        guard let url = URL(string:  "https://lokaiosapp-k4sm7ymkwq-ew.a.run.app/get_devices_details.php?device=\(escolha)")
        else {
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                if let response_obj = try? JSONDecoder().decode([Device_Details].self, from: data) {
                    
                    DispatchQueue.main.async {
                        self.data = response_obj
                    }
                }
            }
            
        }.resume()
    }
}





struct DeviceDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceDetailsView(escolha: "38122F")
    }
}
