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
                    if j.battery_voltage != nil {
                        
                        switch  j.battery_voltage! {
                        
                        case  3.0...5.0 :
                            
                            battery_perc = 100/100
                        
                        case 2.9...3.0 :
                        
                            battery_perc = (Float(100 - ((3.0 - j.battery_voltage!)*58) / 100))/100
                        
                        case 2.740...2.9 :
                        
                            battery_perc = (Float(42 - ((2.9 - j.battery_voltage!)*24) / 160))/100
                            
                        case 2.440...2.740 :
                        
                            battery_perc = (Float(18 - ((2.740 - j.battery_voltage!)*12) / 300))/100
                         
                        case 2.110...2.440 :
                        
                            battery_perc = (Float(6 - ((2.440 - j.battery_voltage!)*6) / 340))/100
                            
                        default:
                            battery_perc = 0
                        }
                        
                    }
                    
                    
                }
            }
        })
    }
    
    func load_Specific_Loka_Data(escolha:String, time:Int, completion: ([loka_result]) -> ())

    {
        
        guard
                let url = URL(string: "https://lokagetlocations-uyiltasaia-ew.a.run.app/get_locations_with_double_entry.php?device=\(escolha)&hours=\(time)"),
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
