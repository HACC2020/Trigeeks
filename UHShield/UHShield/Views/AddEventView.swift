//
//  AddEventView.swift
//  UHShield
//
//  Created by weirong he on 10/27/20.
//

import CoreImage.CIFilterBuiltins
import SwiftUI
import MessageUI
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift


struct AddEventView: View {
    @StateObject var eventViewModel = EventViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    @StateObject var buildingViewModel = BuildingViewModel()
    
    @State var isOpenGuestTextField =  false
    @State var guestEmail: String = ""
    @State var guestName: String = ""
    
    @State var isShowingSendView = false
    @State var isShowingMailView = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var guestHolder = Guest(name: "", email: "")
    
    @State private var eventName = ""
    @State private var sponsor = ""
    @State private var guests: [Guest] = []
    @State private var building = ""
    @State private var room = ""
    @State private var rooms: [String] = []
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    private let tempTime = Date()
    
    @Binding var selection: Int
    @State var indexResArr = 0
    @State var theNum:[Int] = []
    @State var event = Event(eventName: "", sponsor: "", guests: [], arrivedGuests: [], location: Location(building: "", roomID: ""), startTime: Date(), endTime: Date(), attendance: [])
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    var body: some View {
        ZStack {
            NavigationView {
                
                
                VStack {
                    Form {
                        
                        // event section
                        Section(header: Text("Event")) {
                            
                            TextField("describe event", text: $eventName)
                                .padding(.horizontal)
                                .disableAutocorrection(true)
                        }
                        
                        // Location section
                        Section(header: Text("Location")) {
                            
                            Picker(selection: $building, label: Text("Building:")) {
                                ForEach(self.buildingViewModel.buildings) { building in
                                    Text(building.building).tag(building.building)
                                        .onTapGesture{
                                            self.room = ""
                                        }
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                            
                            Picker(selection: $room, label: Text("Room:")) {
                                ForEach(self.rooms, id:\.self) { room in
                                    Text(room).tag(room)
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                            .onAppear() {
                                self.getRooms()
                            }
                            
                        }
                        
                        // time section
                        Section(header: Text("Time")) {
                            
                            DatePicker("Start Time", selection: $startTime, in: tempTime...).padding(.horizontal).datePickerStyle(CompactDatePickerStyle())
                            
                            DatePicker("End Time", selection: $endTime, in: startTime..., displayedComponents: .hourAndMinute).padding(.horizontal)
                            
                        }
                        
                        // guest section
                        Section(header: Text("Guest")) {
                            // guest section label
                            HStack {
                                Text("Guests").padding(.horizontal)
                                Image(systemName: "plus.circle").onTapGesture(perform: {
                                    isOpenGuestTextField = true
                                })
                                Spacer()
                            }
                            
                            // guest text field
                            if isOpenGuestTextField {
                                HStack {
                                    TextField("name", text: $guestName, onCommit: {
                                        if guestEmail != "" {
                                            guests.append(Guest(name: guestName.trimmingCharacters(in: .whitespaces), email: guestEmail.trimmingCharacters(in: .whitespaces)))
                                            guestName = ""
                                            guestEmail = ""
                                            isOpenGuestTextField = false
                                        }
                                    }).disableAutocorrection(true)
                                    TextField("email", text: $guestEmail, onCommit: {
                                        if guestName != "" {
                                            guests.append(Guest(name: guestName.trimmingCharacters(in: .whitespaces), email: guestEmail.trimmingCharacters(in: .whitespaces)))
                                            guestName = ""
                                            guestEmail = ""
                                            isOpenGuestTextField = false
                                        }
                                    }).keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                }.padding(.horizontal)
                            }
                            
                            // guests present area
                            ForEach(guests, id: \.self) { guest in
                                HStack {
                                    Text("\(guest.name!)")
                                    Spacer()
                                    Text("\(guest.email!)")
                                }.padding(.horizontal)
                                .foregroundColor(.blue)
                            }.onDelete(perform: removeGuest)
                            
                        } // end of Guest section
                        
                    }
                    
                    // Back Button and Done Button
                    .navigationBarItems(
                        leading: Button(action: { handleBackButton() }, label: {
                            HStack {
                                Image(systemName: "chevron.backward")
                                Text("Back")
                            }.font(.system(size: 20))
                        }),
                        trailing: Button(action: { handleDoneButton() }, label: {
                            Text("Done")
                        }).disabled(
                                        eventName == "" ||
                                        building == "" ||
                                        room == "" ||
                                        startTime == tempTime ||
                                        endTime == tempTime ||
                                        endTime < startTime ||
                                        guests.isEmpty
                        )
                        
                    ).navigationTitle("Create Event")
                }.onAppear {
                    eventViewModel.fetchData()
                    profileViewModel.fetchData()
                    buildingViewModel.fetchData()
                }
                
            }
            // MARK: - sending email View
            if isShowingSendView {
                if MFMailComposeViewController.canSendMail() {
                    VStack {
                        
                        VStack {
                            HStack {
                                Text("Send Invitation").font(.largeTitle).fontWeight(.bold)
                                Spacer()
                                
                                Button(action: {handleXButton()}, label: {
                                    Image(systemName: "xmark.circle").font(.title)
                                })
                                
                            }
                            
                            ScrollView {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                    Text("Guests").font(.title2).fontWeight(.bold)
                                    Text("")
                                    ForEach(guests.indices) { index in
                                        Text("\(guests[index].email!)")
                                        if(theNum[index] == 2){
                                            HStack {
                                                Image(systemName: "checkmark")
                                                Text("Good")
                                                
                                            }.padding().background(Color("button1")).foregroundColor(.white).cornerRadius(25)
                                        } else {
                                        Button(action: {
                                            handleSendButton(guest: guests[index], index: index)
                                            
                                        }, label: {
                                            HStack {
                                                Image(systemName: "paperplane")
                                                Text("Send")
                                            }.padding().background(Color("bg1")).foregroundColor(.white).cornerRadius(25)
                                        })
                                        }
                                    }
                                }
                            }
                            
                        }.padding()
                        .background(Color.white)
                    }.background(Color.white.ignoresSafeArea())
                    .transition(.move(edge: .bottom)).animation(.linear)
                    
                } else {
                    AlertView(showAlert: $isShowingSendView, alertMessage: .constant("Event created Successful! But this device is simulator or it does not have Mail App, so we skip that step."), alertTitle: "Notification").onDisappear {
                        selection = 0
                    }
                }
            }
            
            
            //MARK: - Mail Composer View
            if(isShowingMailView) {
                EmailComposer(result: self.$result, isShowing: $isShowingMailView, outvalue: self.$theNum[indexResArr] ,eventName: eventName, guest: guestHolder, location: Location(building: building, roomID: room), sponsor: getSponsorName(), startTime: startTime, endTime: endTime, qrCode: resizeImage(image: generateQRCode(from: "\(event.id!)\n\(guestHolder.name ?? "user")\n\(guestHolder.email ?? "")"), targetSize: CGSize(width: 200.0, height: 200.0))
                              
                )
                .transition(.move(edge: .bottom)).animation(.linear)
            }
        }
    }
    
    
    // MARK: -Button functions
    func handleBackButton() {
        //        withAnimation(.spring()) {
        selection = 0
        //        }
    }
    
    func handleDoneButton() {
        // code here
        event = Event(eventName: eventName.trimmingCharacters(in: .whitespaces), sponsor: getCurrentUser(), guests: guests, arrivedGuests: [], location: Location(building: building.trimmingCharacters(in: .whitespaces), roomID: room.trimmingCharacters(in: .whitespaces)), startTime: startTime, endTime: endTime, attendance: [])
        eventViewModel.addEvent(event: event)
        for _ in guests {
            theNum.append(0)
        }
        isShowingSendView = true
    }
    
    func handleSendButton(guest: Guest, index: Int) {
        guestHolder = guest
        indexResArr = index
        self.isShowingMailView = true
    }
    
    func handleXButton() {
        isShowingSendView = false
        selection = 0
    }
    
    func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "InputMessage")
        
        if let outputImage = filter.outputImage {
            if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func removeGuest(at offsets: IndexSet) {
        guests.remove(atOffsets: offsets)
    }
    
    func getCurrentUser() -> String {
        let userEmail : String = (Auth.auth().currentUser?.email)!
        return userEmail
    }
    
    func getSponsorName() -> String {
        for profile in profileViewModel.profiles {
            if profile.email == getCurrentUser() {
                return "\(profile.firstName) \(profile.lastName)"
            }
        }
        return event.sponsor!
    }
    
    func getRooms() {
        self.rooms = []
        for building in buildingViewModel.buildings {
            if building.building == self.building {
                for room in building.rooms {
                    self.rooms.append(room)
                }
            }
        }
        self.rooms = rooms.sorted()
    }
    
}


struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView(selection: .constant(21))
    }
}
