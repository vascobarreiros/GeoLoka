//
//  Progress.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 22/12/2020.
//

import Foundation



// This is the Class that will store the variable doneGettingData in order to be used in the Spinner

class GettingSingleMapData: ObservableObject {

@Published var doneGettingSingleMapData = false
    
}

class GettingAllMapData: ObservableObject {

@Published var doneGettingAllMapData = false
    
}

class GettingTempData: ObservableObject {

@Published var doneGettingTempData = false
    
}

class SendData: ObservableObject {

@Published var donesenddata = false
    
}

class DeviceRemoved : ObservableObject {
    
    @Published var deviceRemoved = false
        
    }

class Token : ObservableObject {
    
    @Published var token = ""
    
}

class GettingGeoFencingMap: ObservableObject {

@Published var doneGettingGeoFencingMap = false
    
}
