//
//  EditEventView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//

import SwiftUI

struct EditEventView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var eventViewModel = EventViewModel()
    @Binding var event: Event
    @State var isShowAlert =  false
    @State var isOpenGuestTextField =  false
    @Binding var isDelete: Bool
    @State var guestEmail: String = ""
    @State var guestName: String = ""
    
    @State private var eventName = ""
    @State private var guests: [Guest] = []
    @State private var building = ""
    @State private var roomID = ""
    @State private var date = Date()
    @State private var startTime = Date()
    @State private var endTime = Date()
    private let tempTime = Date()
    
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
                            
                            TextField("Building:", text: $building)
                                .textContentType(.location)
                                .padding(.horizontal).disableAutocorrection(true)
                            TextField("Room:", text: $roomID)
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
                
            }.navigationBarItems(leading: Button(action: { handleBackButton() }, label: {
                HStack {
                    Image(systemName: "chevron.down")
                    Text("Back")
                }.font(.system(size: 20))
            }), trailing: Button(action: { handleSaveButton() }, label: {
                    Text("Save").font(.system(size: 20))
            }))
            .navigationTitle("Edit Event")
            
            
        }.onAppear {
            getEventInformation()
        }
    }
    
    // MARK: -Button functions
    func handleBackButton() {
        presentationMode.wrappedValue.dismiss()
    }
    
    func handleSaveButton() {
        
        event.eventName = eventName.trimmingCharacters(in: .whitespaces)
        event.guests = guests
        event.location?.building = building.trimmingCharacters(in: .whitespaces)
        event.location?.roomID = roomID.trimmingCharacters(in: .whitespaces)
        event.startTime = startTime
        event.endTime = endTime
        
        eventViewModel.updateEvent(event: event)
        presentationMode.wrappedValue.dismiss()
        
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
}

struct EditEventView_Previews: PreviewProvider {
    static var previews: some View {
        EditEventView(event: .constant(Event(eventName: "Test Event", sponsor: "wei@sponsor.com", guests: [Guest(name: "Wei", email: "wei@test.com"), Guest(name: "Rong", email: "rong@test.com")], arrivedGuests: ["wei@test.com"], location: Location(building: "POST", roomID: "101"), startTime: Date(), endTime: Date(), attendance: [])), isDelete: .constant(false))
    }
}
