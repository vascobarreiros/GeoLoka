//
//  DeviceDetailsView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 23/02/2021.
//

import SwiftUI

struct BatteryView_new: View {
    
    
    @State private var data = [battery_result]()
    var escolha : String
    
    
    var body: some View {
        
        VStack  {
          Text ("Device Details").font(.headline)
            List {
                ForEach (data, id: \.unix_time) { item in
                    
                    Text(String(item.battery))
                    
                        
                            }
           
            
            }.onAppear(perform: {
            loadData()
    })
        }
        
        
    }
}


extension BatteryView_new
{
    func loadData() {
        
        guard let url = URL(string:  "https://lokaiosapp-cnkwoooqra-ew.a.run.app/get_battery.php?device=3805B2&hours=24")
        else {
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                if let response_obj = try? JSONDecoder().decode([battery_result].self, from: data) {
                    DispatchQueue.main.async {
                        self.data = response_obj
                    }
                }
            }
            
        }.resume()
    }
}





struct BatteryView_new_Previews: PreviewProvider {
    static var previews: some View {
        BatteryView_new(escolha: "7B07E7")
    }
}

