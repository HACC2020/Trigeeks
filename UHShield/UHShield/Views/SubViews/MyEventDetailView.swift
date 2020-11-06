//
//  MyEventDetailView.swift
//  UHShield
//
//  Created by weirong he on 11/6/20.
//

import SwiftUI

struct MyEventDetailView: View {
    var event: Event
    @StateObject var eventViewModel = EventViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    @State private var isTankingAttendance = false
    @State var eventTemp = Event(eventName: "", sponsor: "", guests: [], arrivedGuests: [], location: Location(building: "", roomID: ""), startTime: Date(), endTime: Date(), attendance: [])
    var body: some View {
        NavigationView {
            VStack {
                
                ScrollView {
                    // MARK: -Event Information
                    VStack {
                        HStack {
                            Text("\(event.eventName!)").font(.largeTitle).fontWeight(.bold)
                            Spacer()
                        }.padding(.horizontal)
                        
                        
                        HStack {
                            Text("\(getSponsorName())").font(.headline).fontWeight(.black).foregroundColor(.secondary)
                            Spacer()
                        }.padding(.horizontal)
                        
                        HStack {
                            Text("\(event.startTime!, style: .date)").font(.footnote).fontWeight(.black).foregroundColor(.secondary)
                            Spacer()
                        }.padding(.horizontal)
                        
                        HStack {
                            Text("\(event.startTime!, style: .time) to \(event.endTime!, style: .time)").font(.title2).fontWeight(.semibold)
                            Spacer()
                        }.padding()
                        
                        HStack {
                            Text("Location").font(.title2).fontWeight(.semibold).foregroundColor(.secondary)
                            Spacer()
                        }.padding(.horizontal)
                        
                        HStack {
                            Text("\(event.location!.building) \(event.location!.roomID)").font(.title2).fontWeight(.semibold)
                            Spacer()
                        }.padding(.horizontal)
                        
                        HStack {
                            Text("Guests").font(.title2).fontWeight(.semibold).foregroundColor(.secondary)
                            Spacer()
                            Button(action: {
                                isTankingAttendance.toggle()
                            }, label: {
                                if isTankingAttendance {
                                    Text("Done")
                                } else {
                                    Text("Take Attendance")
                                }
                            }).padding()
                        }.padding()
                    } // end of event information VStack
                    
                    // MARK: -Guests List
                    
                    LazyVStack {
                        ForEach(event.guests!, id: \.self) { guest in
                            ZStack {
                                Rectangle().foregroundColor( event.arrivedGuests!.contains(guest.email!) ? eventTemp.attendance!.contains(guest.email!) ? .green : .yellow : .gray).offset(x: -10)
                                HStack {
                                    Text("\(guest.name!)").font(.title2).fontWeight(.semibold)
                                    Text("\(guest.email!)").font(.title2).fontWeight(.semibold).foregroundColor(.secondary)
                                    Spacer()
                                    if isTankingAttendance {
                                        if event.arrivedGuests!.contains(guest.email!) {
                                            if eventTemp.attendance!.contains(guest.email!) {
                                                
                                                Image(systemName: "checkmark.circle.fill").font(.title).foregroundColor(.green)
                                                    .onTapGesture {
                                                        handleUnCheck(guest: guest)
                                                    }
                                                    .transition(.move(edge: .trailing)).animation(.linear(duration: 0.2))
                                            } else {
                                                Image(systemName: "checkmark.circle").font(.title2).foregroundColor(.gray)
                                                    .onTapGesture {
                                                        handleCheck(guest: guest)
                                                    }
                                                    .transition(.move(edge: .trailing)).animation(.linear(duration: 0.2))
                                            }
                                        }
                                    }
                                }.padding()
                                .background(Rectangle().foregroundColor(.white))
                            }
                            Divider()
                        }
                        
                    }
                    .padding(30)
                    .background(Color(#colorLiteral(red: 0.9284724593, green: 0.9312825799, blue: 0.9660671353, alpha: 1)))
                    
                    
                    
                }
            }.navigationBarItems(trailing: Button(action: { handleEdit() }, label: {
                Text("Edit")
            }))
            .onAppear {
                eventTemp = event
                profileViewModel.fetchData()
            }
        }
    }
    
    func handleCheck(guest: Guest) {
        eventTemp.attendance?.append(guest.email!)
        eventViewModel.updateEvent(event: eventTemp)
    }
    
    func handleUnCheck(guest: Guest) {
        var i = -1
        for index in eventTemp.attendance!.indices {
            if guest.email == eventTemp.attendance![index] {
                i = index
            }
        }
        if i != -1 {
            eventTemp.attendance?.remove(at: i)
            eventViewModel.updateEvent(event: eventTemp)
        }
    }
    
    func handleEdit() {
        
    }
    
    func getSponsorName() -> String {
        for profile in profileViewModel.profiles {
            if profile.email == event.sponsor {
                return "\(profile.firstName) \(profile.lastName)"
            }
        }
        return event.sponsor!
    }
}

struct MyEventDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MyEventDetailView(event: Event(eventName: "Test Event", sponsor: "wei@sponsor.com", guests: [Guest(name: "Wei", email: "wei@test.com"), Guest(name: "Rong", email: "rong@test.com")], arrivedGuests: ["wei@test.com"], location: Location(building: "POST", roomID: "101"), startTime: Date(), endTime: Date(), attendance: []))
    }
}
