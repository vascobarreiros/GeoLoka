//
//  BatteryView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 10/01/2021.
//

import SwiftUI

struct BatteryView: View {
    
    @State var progressValue: Float = 0.2
    @State var device : String
    @State var results = [loka_result]()
    @State var battery_perc : Float = 100.0
    
    var body: some View {
        ZStack {
            Color(.black).edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Text(NSLocalizedString("Battery Usage",comment: ""))
                    .foregroundColor(Color.white)
                ProgressBar(progress: $battery_perc)
                    .frame(width: 150.0, height: 150.0)
                    .padding(40.0)
                
                Spacer()
            }
        }.onAppear(perform: {
            load_Specific_Loka_Data(escolha: device,time: 24) { vb in
                
                for j in vb {
                    if j.battery != nil {
                        
                        battery_perc = (j.battery!)/100
                        
                    }
                    
                    
                }
            }
        })
    }
    
    func load_Specific_Loka_Data(escolha:String, time:Int, completion: ([loka_result]) -> ())

    {
        
        guard
                let url = URL(string: "https://lokaiosapp-k4sm7ymkwq-ew.a.run.app/get_locations_with_double_entry.php?device=\(escolha)&hours=\(time)"),
                let data = try? Data(contentsOf: url)
                else { return }
        
        let json_loka = try? JSONDecoder().decode([loka_result].self, from: data)
        guard let loka_data = json_loka else { return }
        completion(loka_data)
    }
    
}

struct ProgressBar: View {
    @Binding var progress: Float
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.red)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
            Text(String(format: "%.0f %%", min(self.progress, 1.0)*100.0))
                .font(.title)
                .foregroundColor(Color.white)
                .bold()
                
        }
    }
}

struct BatteryView_Previews: PreviewProvider {
    
    
    
    static var previews: some View {
        BatteryView(device: "7B07E7")
    }
}
