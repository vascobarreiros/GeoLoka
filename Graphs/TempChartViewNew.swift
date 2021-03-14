//
//  TempChartViewNew.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 25/02/2021.
//

import SwiftUI

struct TempChartViewNew: View {
    
    @State private var data = [temperature_result]()
    @ObservedObject var gettempFlag = GettingTemp()
    
    var escolha : String
    
    var body: some View {
        
        ZStack {
            Color(.black).edgesIgnoringSafeArea(.all)
            VStack  {
             Text(NSLocalizedString("Temperature (ºC)",comment: "")).foregroundColor(.white)
              
                HStack(alignment: .center, spacing: 10)
                {
                    ForEach (data, id: \.time) { item in
                        BarView(value: 50+CGFloat(item.temperature )*3, xvalue: item.time, cornerRadius: CGFloat(integerLiteral: 10))
                            
                                }
               
               
                
            }.padding(.top, 24).animation(.default)
            .onAppear(perform: {
            loadData()})
                Spacer()
            }
            Spinner(isAnimating: gettempFlag.doneGettingTemp, style: .large, color: .green)
        }
        
        
    }
}

extension TempChartViewNew
{
    
    func loadData() {
        gettempFlag.doneGettingTemp = true
        guard let url = URL(string:  "https://lokaiosapp-cnkwoooqra-ew.a.run.app/get_temperature.php?device=\(escolha)&hours=24")
        else {
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let data = data {
                if let response_obj = try? JSONDecoder().decode([temperature_result].self, from: data) {
                    DispatchQueue.main.async {
                        self.data = response_obj
                        gettempFlag.doneGettingTemp = false
                    }
                }
            }
            
        }.resume()
    }
}





struct TempChartViewNew_Previews: PreviewProvider {
    static var previews: some View {
        TempChartViewNew(escolha: "3E5930")
    }
}
