//
//  DeleteDeviceView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 10/01/2021.
//
// This view will delete devices asscoiated with each user from the table devices within the GCP

import SwiftUI

struct DeleteDeviceView: View {
    
    @State var escolha : String
    @State private var showconfirmation = false
    @ObservedObject var getDevices_by_identifier = GetDevices_by_identifier()
    @EnvironmentObject var signInWithAppleMager: SignInWithAppleManager
    
    var body: some View {
        VStack{
            Text("Delete Device = \(escolha)")
                .font(.title2)
            Button(action: {
                print("I'm going to delete the Device")
                //removed.deviceRemoved = true
                deleteDevicefromServer(device_id: escolha)
                getDevices_by_identifier.fetchdevices()
                getDevices_by_identifier.identifier = UserDefaults.standard.string(forKey: signInWithAppleMager.userIdentifierKey)!
                }, label: {
                    HStack(spacing: 10) {
                            Image(systemName: "minus.circle.fill")
                            Text(NSLocalizedString("Delete Device", comment: "")).fontWeight(.bold)
                        }.padding()
                         .foregroundColor(.white)
                         .background(Color.red)
                         .cornerRadius(40)
                }).alert(isPresented: $showconfirmation) {
                    Alert(title: Text(NSLocalizedString("Device Deleted",comment: "")), message: Text("Device \(escolha) was deleted"), dismissButton: .default(Text("Ok")))
                    
                }
        }
        }
    
    func deleteDevicefromServer(device_id:String) {

    let url = URL(string: "https://lokagetlocations-uyiltasaia-ew.a.run.app/delete_device.php")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
        var dataString = "secret=44fdcv8jf3" // starting POST string with a secretWord
        dataString = dataString + "&device_id=\(device_id)"
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
                                
                                print("Upload 1")

                                }
                            }
                            else
                            {
                                if let unwrappedData = data {
                                    
                                    let returnedData = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue) // Response from web server hosting the database
                                    print("Return from server = \(returnedData ?? "vasco")")
                                    if returnedData == "1" // insert into database worked
                                    
                                    {
                                        print("All GOOD")
            // display an alert if no error and database insert worked (return = 1) inside the DispatchQueue.main.async

                                        DispatchQueue.main.async
                                        {
    //                                        let alert = UIAlertController(title: "Upload OK?", message: "Looks like the upload and insert into the database worked.", preferredStyle: .alert)
    //                                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    //                                       // self.present(alert, animated: true, completion: nil)
    //                                        print(alert)
                                            print("Upload 2")
                                           // senddata.donesenddata = true
                                        }
                                    }
                                    else
                                    {
            // display an alert if an error and database insert didn't worked (return != 1) inside the DispatchQueue.main.async

                                        DispatchQueue.main.async
                                        {

    //                                    let alert = UIAlertController(title: "Upload Didn't Work", message: "Looks like the insert into the database did not worked.", preferredStyle: .alert)
    //                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    //                                   // self.present(alert, animated: true, completion: nil)
    //                                    print(alert)
                                        print("Upload 3 - All Good")
                                        //donesendingdata = true
                                        //self.donesenddata = true
                                        self.showconfirmation = true
                                        }
                                    }
                                }
                            }
                        }
                        uploadJob.resume()
                    }
        

    }
    
    
    }


struct DeleteDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteDeviceView(escolha: "7B07E7")
    }
}
