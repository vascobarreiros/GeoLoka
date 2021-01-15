
//
//  TempChartView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 04/01/2021.
//

import SwiftUI

struct TempChartView: View {
    
    let count = 0
    var device : String
    @State var temperature_intervale : Double
    @State var searchText = ""
    @ObservedObject var getall = FetchAllLoka_Data()
           
       var body: some View {
           ZStack{
               Color(.black).edgesIgnoringSafeArea(.all)
               VStack{
                   Text(NSLocalizedString("Temperature (ºC)",comment: "")).foregroundColor(.white)
                   HStack(alignment: .center, spacing: 10)
                   {
                       ForEach(
                        getall.allLokas.filter({device.isEmpty ? true : $0.device.lowercased().contains(device.lowercased())  }),
                        id: \.unix_time){
                           data in
                        if data.unix_time >= Int(NSDate().timeIntervalSince1970)-(Int(temperature_intervale)*60*60) && data.temperature != nil
                        {
                            BarView(value: 50+CGFloat(data.temperature ?? 0.0)*3, xvalue: data.time, cornerRadius: CGFloat(integerLiteral: 10))
                        }
                       }
                   }.padding(.top, 24).animation(.default)
                Spacer()
               }
            Spinner(isAnimating: getall.donefetchingData, style: .large, color: .green)
           }
       }


      
   }

struct TempChartView_Previews: PreviewProvider {
    static var previews: some View {
        TempChartView(device: "3E5930", temperature_intervale: 12)  }
}
