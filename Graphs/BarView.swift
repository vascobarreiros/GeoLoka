//
//  BarView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 04/01/2021.
//

import SwiftUI


struct BarView: View{

    var value: CGFloat
    var xvalue: String
    var cornerRadius: CGFloat
    
    var body: some View {
        VStack {

            ZStack (alignment: .bottom) {
                Text(String(xvalue))
                    .foregroundColor(Color.white)
                    .offset(x:-55)
                    .zIndex(2)
                    .rotationEffect(.degrees(-90))
                    .frame(width:50.0, height: 50.0)
                RoundedRectangle(cornerRadius: cornerRadius)
                    .frame(width: 30, height: 200).foregroundColor(.black)
                RoundedRectangle(cornerRadius: cornerRadius).fill(LinearGradient(gradient: Gradient(colors: [.purple, .red, .blue]), startPoint: .top, endPoint: .bottom))
                    .frame(width: 30, height: value)
                Text("\(Int((value-50)/3))")
                    .foregroundColor(Color.white)
                    .frame(width: 30, height: value)
                
               
                
            }.padding(.bottom, 8)
        }
        
    }
}

struct BarView_Previews: PreviewProvider {
    static var previews: some View {
        BarView(value: 120, xvalue: "12:44:00", cornerRadius: 12)
    }
}

