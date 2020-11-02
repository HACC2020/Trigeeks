//
//  AddEventView.swift
//  UHShield
//
//  Created by weirong he on 10/27/20.
//

import CoreImage.CIFilterBuiltins
import SwiftUI
import MessageUI


struct AddEventView: View {
    @StateObject var eventViewModel = EventViewModel()
    
    @State var isOpenGuestTextField =  false
    @State var guestEmail: String = ""
    @State var guestName: String = ""
    
    @State var isShowingSendView = false
    @State var isShowingMailView = false
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var guestHoder = Guest(name: "", email: "")
    
    @State private var eventName = ""
    @State private var sponsor = ""
    @State private var guests: [Guest] = []
    @State private var building = ""
    @State private var room = ""
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    private let tempTime = Date()
    
    let formatter = DateFormatter()
    
    
    // selection of View: AddEvent=21, sponsor=20
    @Binding var selection: Int
    
    @State var event = Event(eventName: "", sponsor: "", guests: [], arrivedGuests: [], location: Location(building: "", roomID: ""), startTime: Date(), endTime: Date())
    
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
                        TextField("sponsor(should auto get):", text: $sponsor)
                            .textContentType(.name)
                            .padding(.horizontal)
                            .disableAutocorrection(true)
                        }
                        
                        // Location section
                        Section(header: Text("Location")) {
                            
                            TextField("Building:", text: $building)
                                .textContentType(.location)
                                .padding(.horizontal).disableAutocorrection(true)
                            TextField("Room:", text: $room)
                                //.keyboardType(.decimalPad)
                                .padding(.horizontal).disableAutocorrection(true)
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
                                    Text("\(guest.name)")
                                    Spacer()
                                    Text("\(guest.email)")
                                }.padding(.horizontal)
                                .foregroundColor(.blue)
                            }.onDelete(perform: removeGuest)
     
                        } // end of Guest section
                        
                        // generate qr code for each guest
                        ForEach(guests, id: \.self) { guest in
                            Image(uiImage: generateQRCode(from: "\(eventName)\n\(sponsor)\n\(building)\n\(room)\n\(formatter.string(from: startTime))\n\(formatter.string(from: endTime))\n\(guest.name)\n\(guest.email)"))
                                .interpolation(.none)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                        }
                        
                        
                        
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
                        }).disabled(sponsor == "" ||
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
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
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
                                Image(systemName: "xmark.circle").font(.title)
                            }
                            
                            ScrollView {
                                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                                    Text("Guests").font(.title2).fontWeight(.bold)
                                    Text("")
                                    ForEach(guests, id: \.self) { guest in
                                        Text("\(guest.email)")
                                        Button(action: {
                                            guestHoder = guest
                                            isShowingMailView = true
                                            print("guestHoder: \(guestHoder)")
                                            print("guest: \(guest)")
                                        }, label: {
                                            HStack {
                                                Image(systemName: "paperplane")
                                                Text("Send")
                                            }.padding().background(Color("bg1")).foregroundColor(.white).cornerRadius(25)
                                        })
                                    }
                                }.sheet(isPresented: $isShowingMailView) {
                                    EmailComposer(result: self.$result, isShowing: $isShowingMailView ,eventName: eventName, guest: guestHoder, location: Location(building: building, roomID: room), sponsor: sponsor, startTime: startTime, endTime: endTime)
                                }
                            }
                            
                        }.padding()
                        .background(Color.white)
                    }.background(Color.white.ignoresSafeArea())
                    
                } else {
                    AlertView(showAlert: $isShowingSendView, alertMessage: .constant("Event created Successful! But this device is simulator or it does not have Mail App, so we skip that step.")).onDisappear {
                        selection = 20
                    }
                }
            }
        }
    }
    
    
    // MARK: -Button functions
    func handleBackButton() {
        withAnimation(.spring()) {
            selection = 20
        }
    }
    
    func handleDoneButton() {
        // code here
        event = Event(eventName: eventName.trimmingCharacters(in: .whitespaces), sponsor: sponsor.trimmingCharacters(in: .whitespaces), guests: guests, arrivedGuests: [], location: Location(building: building.trimmingCharacters(in: .whitespaces), roomID: room.trimmingCharacters(in: .whitespaces)), startTime: startTime, endTime: endTime)
        eventViewModel.addEvent(event: event)
        withAnimation(.spring()) {
            isShowingSendView = true
        }
    }
    
    func handleSendButton(guest: Guest) {
        guestHoder = guest
        self.isShowingMailView = true
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


}


struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView(selection: .constant(21))
    }
}
