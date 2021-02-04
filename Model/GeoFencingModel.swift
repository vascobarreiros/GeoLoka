//
//  GeoFencingModel.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 30/01/2021.
//

import Foundation


struct GeoFence: Hashable, Decodable {
    var name: String
    var radius: String
    var latitude: String
    var longitude: String
    var identifier: String
}

// Now conform to Identifiable we need to change the name of the variable to id
extension GeoFence: Identifiable {
    var id: String { return identifier }
}
