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
        ZStack {
        NavigationView {
            
            
                VStack {
                    Form {
                        
                        // event section
                        Section(header: Text("Event")) {
                        
                        TextField("describe event", text: $eventName)
                            .padding(.horizontal)
                            .disableAutocorrection(true)
                        TextField(getCurrentUser(), text: $sponsor)
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
                                    ForEach(guests, id: \.self) { guest in
                                        Text("\(guest.email!)")
                                        Button(action: {
                                            handleSendButton(guest: guest)
                                            
                                        }, label: {
                                            HStack {
                                                Image(systemName: "paperplane")
                                                Text("Send")
                                            }.padding().background(Color("bg1")).foregroundColor(.white).cornerRadius(25)
                                        })
                                    }
                                }
                            }
                            
                        }.padding()
                        .background(Color.white)
                    }.background(Color.white.ignoresSafeArea())
                    .transition(.move(edge: .bottom)).animation(.linear)
                    
                } else {
                    AlertView(showAlert: $isShowingSendView, alertMessage: .constant("Event created Successful! But this device is simulator or it does not have Mail App, so we skip that step.")).onDisappear {
                        selection = 20
                    }
                }
            }
            
            
            //MARK: - Mail Composer View
            if(isShowingMailView) {
                EmailComposer(result: self.$result, isShowing: $isShowingMailView ,eventName: eventName, guest: guestHolder, location: Location(building: building, roomID: room), sponsor: getCurrentUser(), startTime: startTime, endTime: endTime, qrCode: resizeImage(image: generateQRCode(from: "\(eventName)\n\(getCurrentUser())\n\(building)\n\(room)\n\(startTime)\n\(endTime)\n\(guestHolder.name ?? "user")\n\(guestHolder.email ?? "")"), targetSize: CGSize(width: 200.0, height: 200.0))

                )
                    .transition(.move(edge: .bottom)).animation(.linear)
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
        event = Event(eventName: eventName.trimmingCharacters(in: .whitespaces), sponsor: getCurrentUser(), guests: guests, arrivedGuests: [], location: Location(building: building.trimmingCharacters(in: .whitespaces), roomID: room.trimmingCharacters(in: .whitespaces)), startTime: startTime, endTime: endTime)
        eventViewModel.addEvent(event: event)
            isShowingSendView = true
    }
    
    func handleSendButton(guest: Guest) {
        guestHolder = guest
        self.isShowingMailView = true
    }
    
    func handleXButton() {
        isShowingSendView = false
        selection = 20
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


}


struct AddEventView_Previews: PreviewProvider {
    static var previews: some View {
        AddEventView(selection: .constant(21))
    }
}
