//
//  AddDevicesView.swift
//  GeoLoka
//
//  Created by Vasco Barreiros on 08/01/2021.
//
// This View will add Loka devices to a table in GCP called devices
// each device will be associated with the user identifier, before adding the devices there will be a check if the device exists
// in a table loka within the GCP for this there is a cloudrun php called get_devices_unique.php that has all the devices being collected via callback. Another check that needs to be done is if the device allready exists not done yet


import SwiftUI
import Combine

enum ActiveAlert {
    case first, second
}

class NumbersOnly: ObservableObject {
    @Published var value = "" {
        didSet {
            let filtered = value.filter { $0.isNumber }
            
            if value != filtered {
                value = filtered
            }
        }
    }
}


struct AddDevicesView: View {
    
    @EnvironmentObject var signInWithAppleMager: SignInWithAppleManager
    @State var device_id: String = ""
    @State var device_name: String = ""
    @ObservedObject var input = NumbersOnly()
    @State private var keyboardOffset: CGFloat = 0
   // @State private var showingAlert = false
    @State private var showconfirmation = false
    @ObservedObject var getDevices_by_identifier = GetDevices_by_identifier()
   // @ObservedObject var getUniqueDevices = GetUniqueDevices()
   // @State var naoexiste : Bool = false
    @State private var showAlert = false
    @State private var activeAlert: ActiveAlert = .first
    @State var existe : Bool = false
    let textLimit = 7 //This is the limit of the Loka deviceID length
    
    //Function to keep text length in limits
        func limitText(_ upper: Int) {
            if input.value.count > upper {
                input.value = String(input.value.prefix(upper))
            }
        }
    
    
    var body: some View {
        ZStack {
            VStack {
              // NavigationView {
                    VStack {
                        //Spacer()
                        Text("")
                        Text("")
                        Text("")
                        Text("")
                        Text("")
                        Text("")
                        TextField(NSLocalizedString("Device ID (Decimal) ",comment: ""), text: $input.value)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .textCase(.uppercase)
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .colorInvert()
                            .onReceive(Just(input.value)) { _ in limitText(textLimit) }
                        TextField(NSLocalizedString("Device Name",comment: ""), text: $device_name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal)
                            .foregroundColor(.white)
                            .colorInvert()
                        Text("")
                        Section {
                        Button(action: {
                            print("Lets try to Add Device")
                            let device_id_int = Int(input.value)
                            device_id = String(NSString(format:"%2X", device_id_int!))
                            print ("Device ID in Hex = \(device_id)")
                            let urlString = "https://lokagetlocations-uyiltasaia-ew.a.run.app/get_devices_unique.php?device=\(device_id)"
                            if let url = URL(string: urlString){
                                let session = URLSession(configuration: .default)
                                let task = session.dataTask(with: url) { (data, response, error) in
                                    if error == nil{
                                        let decoder = JSONDecoder()
                                        if let safeData = data{
                                            do{
                                                let results = try decoder.decode([Device_unique].self, from: safeData)
                                                DispatchQueue.main.async {
                                                    print("Numero de devices unicos é de = \(results.count)")
                                                    if results.count == 1 {
                                                        existe = true
                                                        self.showAlert = true
                                                        self.activeAlert = .first
                                                    print("I'm adding the device")
                                                    loadDeviceToServer(device_id: device_id, device_name: device_name, identifier: UserDefaults.standard.string(forKey: signInWithAppleMager.userIdentifierKey)!)
                                                    }
                                                    else {
                                                        self.showAlert = true
                                                        self.activeAlert = .second
                                                     print("I'm not adding the device")
                                                    }
                                                    
                                                }
                                            } catch{
                                                print(error)
                                            }
                                        }
                                    }
                                }
                                task.resume()
                            }
                        }, label: {
                            VStack {
                                
                                HStack(spacing: 10) {
                                    Image(systemName: "car.2")
                                    Text(NSLocalizedString("Add Device",comment: ""))
                                }.padding()
                                
                            }.padding()
                        })
                    }
                       // .disabled(input.value.isEmpty || device_name.isEmpty)
                        .alert(isPresented: $showAlert) {
                            switch activeAlert {
                            case .first:
                                return Alert(title: Text(NSLocalizedString("Device added",comment: "")), message: Text("Device \(device_id) has been added"), dismissButton: .default(Text("Got it!")))
                            case .second:
                                return Alert(title: Text(NSLocalizedString("Device NOT added",comment: "")), message: Text("The device \(device_id) does not exist in the Sigfox Backend or has not been added to the proper Device Type"), dismissButton: .default(Text("Ok")))
                                
                            }
                        }
                        
                    }
                     
                    .background(Color.black)
                    .navigationBarTitle("Add a New Device")
                    .offset(y: -self.keyboardOffset)
                    .background(Color(UIColor.systemGray6))
                
                
                Text(NSLocalizedString("Note: Enter the Device ID exactly has it is in the Loka device label",comment: ""))
                    .font(.subheadline)
                    .foregroundColor(Color.white)
                Image("loka").scaledToFill()
                Spacer()
            }.background(Color.black)
        }.background(Color.black)
        
        
    }
    
    
    
    
    
   
    func loadDeviceToServer(device_id:String, device_name: String, identifier:String) {

    let url = URL(string: "https://lokagetlocations-uyiltasaia-ew.a.run.app/put_device.php")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
        var dataString = "secret=44fdcv8jf3" // starting POST string with a secretWord
        dataString = dataString + "&device_id=\(device_id)"
        dataString = dataString + "&device_name=\(device_name)"
        dataString = dataString + "&identifier=\(identifier)"
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

struct AddDevicesView_Previews: PreviewProvider {
    static var previews: some View {
        AddDevicesView()
    }
}
