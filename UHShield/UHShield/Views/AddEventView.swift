//
//  AddEventView.swift
//  UHShield
//
//  Created by weirong he on 10/27/20.
//

import CoreImage.CIFilterBuiltins
import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift



struct AddEventView: View {
    @StateObject var eventViewModel = EventViewModel()
    
    @State var isOpenGuestTextField =  false
    @State private var guestEmail = ""
    @State private var guestName = ""
    
    @State private var eventName = ""
    @State private var sponsor = ""
    @State private var guests: [Guest] = []
    @State private var building = ""
    @State private var room = ""
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    private let tempTime = Date()
    
    // selection of View: AddEvent=21, sponsor=20
    @Binding var selection: Int
    
    @State var event = Event(eventName: "", sponsor: "", guests: [], arrivedGuests: [], location: Location(building: "", roomID: ""), startTime: Date(), endTime: Date())
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    var body: some View {
        NavigationView {
            
            VStack {
                Form {
                    
                    Section(header: Text("Event")) {
                    
                    TextField("describe event", text: $eventName)
                        .padding(.horizontal)
                    TextField(getCurrentUser(), text: $sponsor)
                        .textContentType(.name)
                        .padding(.horizontal)
                    }
                    
                    Section(header: Text("Location")) {
                        
                        TextField("Building:", text: $building)
                            .textContentType(.location)
                            .padding(.horizontal)
                        TextField("Room:", text: $room)
                            //.keyboardType(.decimalPad)
                            .padding(.horizontal)
                    }
                    
                    
                    Section(header: Text("Time")) {
                        
                        DatePicker("Start Time", selection: $startTime, in: tempTime...).padding(.horizontal).datePickerStyle(CompactDatePickerStyle())
                        
                        DatePicker("End Time", selection: $endTime, in: startTime..., displayedComponents: .hourAndMinute).padding(.horizontal)
                        
                    }
                    
                    
                    Section(header: Text("Guest")) {
                        
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
                                        guests.append(Guest(name: guestName, email: guestEmail))
                                        guestName = ""
                                        guestEmail = ""
                                        isOpenGuestTextField = false
                                    }
                                }).disableAutocorrection(true)
                                TextField("email", text: $guestEmail, onCommit: {
                                    if guestName != "" {
                                        guests.append(Guest(name: guestName, email: guestEmail))
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
                                Text("\(guest.name)")
                                Spacer()
                                Text("\(guest.email)")
                            }.padding(.horizontal)
                            .foregroundColor(.blue)
                        }.onDelete(perform: removeGuest)
 
                    } // end of Guest section
                    
                    
                    ForEach(guests, id: \.self) { guest in
                        Image(uiImage: generateQRCode(from: "\(eventName)\n\(getCurrentUser())\n\(building)\n\(room)\n\(startTime)\n\(endTime)\n\(guest.name)\n\(guest.email)"))
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                    }
                    
                }
                
                
                .navigationBarItems(
                    leading: Button(action: { handleBackButton() }, label: {
                        HStack {
                            Image(systemName: "chevron.backward")
                            Text("Back")
                        }.font(.system(size: 20))
                    }),
                    trailing: Button(action: { handleDoneButton() }, label: {
                        Text("Done")
                    }).disabled(sponsor == "" ||
                                    eventName == "" ||
                                    building == "" ||
                                    room == "" ||
                                    startTime == tempTime ||
                                    endTime == tempTime ||
                                    endTime < startTime ||
                                    guests.isEmpty
                                
                    )
                    
                )
                .navigationTitle("Create Event")
                
            }.onAppear {
                eventViewModel.fetchData()
            }
        }
    }
    
    func handleBackButton() {
        withAnimation(.spring()) {
            selection = 20
        }
    }
    
    func handleDoneButton() {
        // code here
        event = Event(eventName: eventName, sponsor: getCurrentUser(), guests: guests, arrivedGuests: [], location: Location(building: building, roomID: room), startTime: startTime, endTime: endTime)
        eventViewModel.addEvent(event: event)
        withAnimation(.spring()) {
            selection = 20
        }
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
    
    func removeGuest(at offsets: IndexSet) {
        guests.remove(atOffsets: offsets)
    }
    
    func getCurrentUser() -> String {
        let userEmail : String = (Auth.auth().currentUser?.email)!
        return userEmail
    }
    

}


struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView(selection: .constant(21))
    }
}
