//
//  DetailsModel.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 23/02/2021.
//

import Foundation


struct Device_Details: Codable {
    var device: String
    var type: String
    var date: String
    var hour: String
    var reset  : Int?
    var fwType : String?
    var ver1: String?
    var ver2: String
    var longScan: Int?
    var ShortScan: Int?
    var program: String?
    var scanInterval : Int?
    var resetInterval : Int?
    var movement : Int?
    var gps : Int?
}

