//
//  SendUser.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 08/01/2021.
//
//

import Foundation
import SwiftUI
import UIKit

func loadUserToServer(identifier:String,name:String,familyname:String,email:String) {

let url = URL(string: "https://lokagetlocations-uyiltasaia-ew.a.run.app/put_identifier.php")!
var request = URLRequest(url: url)
request.httpMethod = "POST"
    var dataString = "secret=44fdcv8jf3" // starting POST string with a secretWord
    dataString = dataString + "&identifier=\(identifier)"
    dataString = dataString + "&name=\(name)"
    dataString = dataString + "&familyname=\(familyname)"
    dataString = dataString + "&email=\(email)"
    let dataD = dataString.data(using: .utf8) // convert to utf8 string
    do
    {
        // the upload task, uploadJob, is defined here
        let uploadJob = URLSession.shared.uploadTask(with: request, from: dataD)
        {
                        data, response, error in
                        
                        if error != nil {
                            
        // display an alert if there is an error inside the DispatchQueue.main.async

                            DispatchQueue.main.async
                            {
                                    let alert = UIAlertController(title: "Upload Didn't Work?", message: "Looks like the connection to the server didn't work.  Do you have Internet access?", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                    //self.present(alert, animated: true, completion: nil)
                                   print(alert)
                            }
                        }
                        else
                        {
                            if let unwrappedData = data {
                                
                                let returnedData = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue) // Response from web server hosting the database
                                
                                if returnedData == "1" // insert into database worked
                                {

        // display an alert if no error and database insert worked (return = 1) inside the DispatchQueue.main.async

                                    DispatchQueue.main.async
                                    {
                                        let alert = UIAlertController(title: "Upload OK?", message: "Looks like the upload and insert into the database worked.", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                       // self.present(alert, animated: true, completion: nil)
                                        print(alert)
                                    }
                                }
                                else
                                {
        // display an alert if an error and database insert didn't worked (return != 1) inside the DispatchQueue.main.async

                                    DispatchQueue.main.async
                                    {

                                    let alert = UIAlertController(title: "Upload Didn't Work", message: "Looks like the insert into the database did not worked.", preferredStyle: .alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                   // self.present(alert, animated: true, completion: nil)
                                    print(alert)
                                    }
                                }
                            }
                        }
                    }
                    uploadJob.resume()
                }
    

}
