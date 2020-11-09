//
//  EditEventView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//
import CoreImage.CIFilterBuiltins
import SwiftUI
import MessageUI
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift

struct EditEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var eventViewModel = EventViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    @EnvironmentObject var buildingViewModel: BuildingViewModel
    @Binding var event: Event
    @State var isShowAlert =  false
    @State var isOpenGuestTextField =  false
    @Binding var isDelete: Bool
    @State var guestEmail: String = ""
    @State var guestName: String = ""
    @State var guestHolder = Guest(name: "", email: "")
    @State private var eventName = ""
    @State private var guests: [Guest] = []
    @State private var building = ""
    @State private var buildings: [String] = []
    @State private var roomID = ""
    @State private var rooms: [String] = []
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    private let tempTime = Date()
    
    @State var isShowingSendView = false
    @State var isShowingMailView = false
    @State var isShowingMailPlusView = false
    // @Binding var selection: Int
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @State var result: Result<MFMailComposeResult, Error>? = nil
    @State var result2: Result<MFMailComposeResult, Error>? = nil
    // @State var resArr: [Result<MFMailComposeResult, Error>?] = []
    @State var indexResArr = 0
    @State var theNum:[Int] = []
    @State var theNum2 = 0
    @State var newGuests: [Guest] = []
    @State var checkTimeConflict = false
    @State var timeConflictEvent: [Event] = []
    
    var body: some View {
        NavigationView {
            ZStack {
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
                                }
                            }
                            .pickerStyle(DefaultPickerStyle())
                            .onAppear() {
                                self.getBuildings()
                            }
                            .onChange(of: building) { _ in
                                self.roomID = ""
                            }
                            
                            Picker(selection: $roomID, label: Text("Room:")) {
                                ForEach(self.rooms, id:\.self) { room in
                                    Text(room).tag(room)
                                }
                            }.onChange(of: roomID, perform: { (value) in
                                self.checkTimeConflict = false
                                self.timeConflictEvent = []
                                for eachEvent in self.eventViewModel.events {
                                    if(eachEvent.location!.building == self.building && eachEvent.location!.roomID == value){
                                        if(eachEvent.startTime! <= startTime && startTime <= eachEvent.endTime!){
                                            checkTimeConflict = true
                                            self.timeConflictEvent.append(eachEvent)
                                        }
                                        if(eachEvent.startTime! > startTime && eachEvent.startTime! < endTime){
                                            checkTimeConflict = true
                                            self.timeConflictEvent.append(eachEvent)
                                        }
                                    }
                                }
                            })
                            .pickerStyle(DefaultPickerStyle())
                            .onAppear() {
                                self.getRooms()
                            }
                            
                        }
                        
                        // time section
                        Section(header: Text("Time")) {
                            
                            DatePicker("Start Time", selection: $startTime, in: tempTime...).padding(.horizontal).datePickerStyle(CompactDatePickerStyle()).onChange(of: startTime) { (value) in
                                self.checkTimeConflict = false
                                self.timeConflictEvent = []
                                for eachEvent in self.eventViewModel.events {
                                    if(eachEvent.location!.building == self.building && eachEvent.location!.roomID == roomID){
                                        if(eachEvent.startTime! <= startTime && startTime <= eachEvent.endTime!){
                                            checkTimeConflict = true
                                            self.timeConflictEvent.append(eachEvent)
                                        }
                                        if(eachEvent.startTime! > startTime && eachEvent.startTime! < endTime){
                                            checkTimeConflict = true
                                            self.timeConflictEvent.append(eachEvent)
                                        }
                                    }
                                }
                            }
                            
                            DatePicker("End Time", selection: $endTime, in: startTime..., displayedComponents: .hourAndMinute).padding(.horizontal).onChange(of: endTime) { (value) in
                                self.checkTimeConflict = false
                                self.timeConflictEvent = []
                                for eachEvent in self.eventViewModel.events {
                                    if(eachEvent.location!.building == self.building && eachEvent.location!.roomID == roomID){
                                        if(eachEvent.startTime! <= startTime && startTime <= eachEvent.endTime!){
                                            checkTimeConflict = true
                                            self.timeConflictEvent.append(eachEvent)
                                        }
                                        if(eachEvent.startTime! > startTime && eachEvent.startTime! < endTime){
                                            checkTimeConflict = true
                                            self.timeConflictEvent.append(eachEvent)
                                        }
                                    }
                                }
                            }
                            if(checkTimeConflict){
                                
                                ScrollView{
                                    LazyVStack{
                                        HStack {
                                            Image(systemName: "exclamationmark.circle.fill")
                                            Text("Time conflict with existing events in the room: ")
                                        }.padding().background(Color(.red)).foregroundColor(.white).cornerRadius(25)
                                        ForEach(self.timeConflictEvent){ eve in
                                            HStack{
                                                Text("\(eve.eventName!)").fontWeight(.bold).foregroundColor(.red)
                                                Spacer()
                                                Text("\(convertDateToTime(theDate: eve.startTime!)) ~ \(convertDateToTime(theDate: eve.endTime!))").fontWeight(.bold).foregroundColor(.red)
                                            }
                                        }
                                    }
                                }
                            }
                            
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
                        
                        Button(action: {handleDeleteButton()}, label: {
                            HStack {
                                Spacer()
                                Text("Delete").foregroundColor(.red)
                                Spacer()
                            }
                        })
                    }

                    // Navigation Buttons : Back and Done
                }
                if isShowAlert {
                    VStack {
                        VStack {
                            HStack {
                                Text("Attention").font(.title).bold().foregroundColor(Color.red.opacity(0.7))
                                Spacer()
                            }.padding(.horizontal, 25)
                            
                            // error message
                            Text("Are you sure to delete this event?").foregroundColor(Color.black.opacity(0.7)).padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 120)
                            
                            // confirm button
                            HStack {
                                HStack {
                                    Button(action: {handleConfirmDelete()}, label: {
                                        Text("Confirm").font(.title3).fontWeight(.semibold).foregroundColor(.white)
                                    }).padding().buttonStyle(RedLongButtonStyle())
                                    
                                    Button(action: {isShowAlert = false}, label: {
                                        Text("Cancel").font(.title3).fontWeight(.semibold).foregroundColor(.white)
                                    }).padding().buttonStyle(LongButtonStyle())
                                }
                            }
                        }.padding().background(Color.white).cornerRadius(20)
                        .animation(.interpolatingSpring(mass: 1, stiffness: 90, damping: 10, initialVelocity: 0))
                        
                        
                    }.padding()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    .background(Color.gray.opacity(0.5).ignoresSafeArea())
                }
                
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
                                            HStack{
                                                Text("\(guests[index].email!)")
                                                if(self.newGuests.contains(guests[index])){
                                                    Image(systemName: "person.crop.circle.fill.badge.plus").foregroundColor(Color("bg1"))
                                                }
                                            }
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
                                    
                                    VStack{
                                        Divider()
                                        Text("Group Sending").font(.title2).fontWeight(.bold)
                                        Text("If you just update the event information, you can do group sending without sending identity authentication QR-Code!").foregroundColor(.gray)
                                        
                                        if(theNum2 == 2){
                                            HStack {
                                                Image(systemName: "checkmark")
                                                Text("Good")
                                                
                                            }.padding().background(Color("button1")).foregroundColor(.white).cornerRadius(25)
                                        }else{
                                            Button(action: {
                                                handleGroupSendButton()
                                                
                                            }, label: {
                                                HStack {
                                                    Image(systemName: "paperplane")
                                                    Text("Group Send")
                                                    
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
                        AlertView(showAlert: $isShowingSendView, alertMessage: .constant("Event is edited Successful! But this device is simulator or it does not have Mail App, so we skip that step."), alertTitle: "Notification").onDisappear {
                            //selection = 0
                        }
                    }
                    
                }
                if(isShowingMailView) {
                    EmailComposer(result: self.$result, isShowing: $isShowingMailView, outvalue: $theNum[indexResArr] ,eventName: eventName, guest: guestHolder, location: Location(building: building, roomID: roomID), sponsor: getSponsorName(), startTime: startTime, endTime: endTime, qrCode: resizeImage(image: generateQRCode(from: "\(event.id!)\n\(guestHolder.name ?? "user")\n\(guestHolder.email ?? "")"), targetSize: CGSize(width: 200.0, height: 200.0))
                    )
                    .transition(.move(edge: .bottom)).animation(.linear)
                }
                
                if(isShowingMailPlusView) {
                    EmailComposerPlus(result: self.$result2, isShowing: $isShowingMailPlusView, outvalue: $theNum2, eventName: eventName, guests: guests, location: Location(building: building, roomID: roomID), sponsor: getSponsorName(), startTime: startTime, endTime: endTime)
                }
                
            }.navigationBarItems(leading: Button(action: { handleBackButton() }, label: {
                if !isShowingSendView {
                    HStack {
                        Image(systemName: "chevron.down")
                        Text("Back")
                    }.font(.system(size: 20))
                }
            }), trailing: Button(action: { handleSaveButton() }, label: {
                if !isShowingSendView {
                    Text("Save").font(.system(size: 20))
                }
            }).disabled(
                eventName == "" ||
                    building == "" ||
                    roomID == "" ||
                    startTime == tempTime ||
                    endTime == tempTime ||
                    endTime < startTime ||
                    guests.isEmpty || checkTimeConflict
            )
            )
            .navigationTitle("Edit Event")
            
            
        }.onAppear {
            getEventInformation()
            buildingViewModel.fetchData()
            eventViewModel.fetchData()
        }
    }
    
    // MARK: -Button functions
    func handleBackButton() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func handleGroupSendButton(){
        self.isShowingMailPlusView = true
    }
    
    func handleSaveButton() {
        
        if(eventName == event.eventName && (building.trimmingCharacters(in: .whitespaces)) == event.location?.building && (roomID.trimmingCharacters(in: .whitespaces)) == event.location?.roomID && startTime == event.startTime && endTime == event.endTime){
            if(event.guests != nil){
                for eachGuest in guests{
                    if(!event.guests!.contains(eachGuest)){
                        isShowingSendView = true
                        break;
                    }
                }
            }
        } else {
            isShowingSendView = true
        }
        
        if(event.guests != nil){
            for eachGuest in guests{
                if(!event.guests!.contains(eachGuest)){
                    newGuests.append(eachGuest)
                }
            }
        }
        
        event.eventName = eventName.trimmingCharacters(in: .whitespaces)
        event.guests = guests
        event.location?.building = building.trimmingCharacters(in: .whitespaces)
        event.location?.roomID = roomID.trimmingCharacters(in: .whitespaces)
        event.startTime = startTime
        event.endTime = endTime
        eventViewModel.updateEvent(event: event)
        
        if isShowingSendView == false {
            presentationMode.wrappedValue.dismiss()
        }
        for _ in guests {
            theNum.append(0)
        }
    }
    
    func handleXButton() {
        isShowingSendView = false
        presentationMode.wrappedValue.dismiss()
        // selection = 0
        print(self.theNum)
    }
    
    func handleSendButton(guest: Guest, index: Int) {
        guestHolder = guest
        indexResArr = index
        self.isShowingMailView = true
    }
    
    func handleDeleteButton() {
        isShowAlert = true
    }
    
    func handleConfirmDelete() {
        // delete from database
        isShowAlert = false
        isDelete = true
        eventViewModel.deleteEvent(event: event)
        handleBackButton()
    }
    
    func getEventInformation() {
        eventName = event.eventName!
        guests = event.guests!
        building = event.location!.building
        roomID = event.location!.roomID
        startTime = event.startTime!
        endTime = event.endTime!
    }
    
    func removeGuest(at offsets: IndexSet) {
        guests.remove(atOffsets: offsets)
    }
    
    func getSponsorName() -> String {
        for profile in profileViewModel.profiles {
            if profile.email == getCurrentUser() {
                return "\(profile.firstName) \(profile.lastName)"
            }
        }
        return event.sponsor!
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
    
    func getCurrentUser() -> String {
        let userEmail : String = (Auth.auth().currentUser?.email)!
        return userEmail
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
        self.rooms = self.rooms.sorted()
    }
    
    func getBuildings() {
        self.buildings = []
        for building in buildingViewModel.buildings {
            self.buildings.append(building.building)
        }
        self.buildings = self.buildings.sorted()
    }
    
    func convertDateToTime(theDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return (formatter.string(from: theDate))
    }
}

struct EditEventView_Previews: PreviewProvider {
    static var previews: some View {
        EditEventView(event: .constant(Event(eventName: "Test Event", sponsor: "wei@sponsor.com", guests: [Guest(name: "Wei", email: "wei@test.com"), Guest(name: "Rong", email: "rong@test.com")], arrivedGuests: ["wei@test.com"], location: Location(building: "POST", roomID: "101"), startTime: Date(), endTime: Date(), attendance: [])), isDelete: .constant(false))
    }
}
