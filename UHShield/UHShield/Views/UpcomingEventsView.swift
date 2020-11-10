//
//  UpcomingEventsView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/11/2.
//

import SwiftUI
import Foundation
import FirebaseAuth

struct UpcomingEventsView: View {
    
    @StateObject var eventVM = EventViewModel()
    @StateObject var profileVM = ProfileViewModel()
    @State var showGuestList = false 
    @State var tappedEvent = Event()
    @State var showEndedEvents = false
    @State var showAlert = false
    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    Toggle(isOn: $showEndedEvents) {
                        Text("Show ended events")
                    }.padding()
                    HStack {
                        Text("Your workplace:")
                        Spacer()
                        if getProfileBuilding() == "" {
                            Text("Please go to setting and select your workplace").foregroundColor(.red)
                        } else {
                            Text("\(getProfileBuilding())")
                        }
                    }.padding(.horizontal)
                    
                    if self.eventVM.events
                        .filter{Calendar.current.isDate($0.startTime!, inSameDayAs:Date())}.filter{showEndedEvents ? true : $0.endTime! >= Date()}.filter{$0.location!.building == getProfileBuilding()}.count > 0 {
                        ScrollView{
                            LazyVStack{
                                
                                
                                
                                ForEach(self.eventVM.events
                                            .filter{Calendar.current.isDate($0.startTime!, inSameDayAs:Date())}.filter{showEndedEvents ? true : $0.endTime! >= Date()}.filter{$0.location!.building == getProfileBuilding()}
                                            .sorted {(lhs:Event, rhs:Event) in
                                                return lhs.startTime! < rhs.startTime!
                                            }) { event in
                                    EventRowView(event: event).padding(.horizontal).onTapGesture {
                                        if event.endTime! > Date() {
                                            self.showGuestList = true
                                            self.tappedEvent = event
                                        } else {
                                            self.showAlert = true
                                        }
                                    }
                                    
                                    
                                }
                            }
                        }
                    } else {
                        // if no event
                        Spacer()
                        Text("There is no upcoming event right now in your workplace!")
                        Spacer()
                    }
                }.navigationBarHidden(true)
                .background(Color.white)
                .onAppear(){
                    self.eventVM.fetchData()
                    self.profileVM.fetchData()
                    print("Fetching data in Events View")
                }

                NavigationLink(destination: GuestListView(event: tappedEvent), isActive: self.$showGuestList) {
                    Text("")
                }
                
                if showAlert {
                    AlertView(showAlert: $showAlert, alertMessage: .constant("You can only access TODAY's UPCOMING events!"), alertTitle: "Deny").transition(.move(edge: .trailing))
                }
            }
                
            
        }
    }
    
    func getProfileBuilding() -> String {
        for profile in profileVM.profiles {
            if profile.email == Auth.auth().currentUser?.email {
                return profile.building
            }
        }
        return ""
    }

}

struct GuestListView: View {
    
    var event: Event
    @State var showCheckin = false
    @StateObject var eventViewModel = EventViewModel()
    
    var body: some View {
        ZStack{
            List{
                ForEach(event.guests!, id: \.self){ guest in
                    
                    
                    ZStack {
                        Rectangle().foregroundColor( checkArrived(guest: guest) ? checkAttendance(guest: guest) ? .green : .yellow : .gray).offset(x: -10)
                        HStack {
                            Text("\(guest.name!)").font(.title2).fontWeight(.semibold)
                            Text("\(guest.email!)").font(.title2).fontWeight(.semibold).foregroundColor(.secondary)
                            Spacer()
                            Image(systemName: "chevron.right").padding(.horizontal)
                        }.padding()
                        .background(Rectangle().foregroundColor(.white))
                    }.onTapGesture {
                        self.showCheckin = true
                    }
                    .fullScreenCover(isPresented: $showCheckin, content: {
                        CheckInView(details: [event.id!, guest.name!, guest.email!, event.location!.building], isShowCheckInView: $showCheckin)
                    })
                    
                }
            }
           
            
//            NavigationLink(destination: CheckInView(details: [event.id!, guestName, guestEmail], isShowCheckInView: $showCheckin), isActive: self.$showCheckin) {
//                Text("")
//            }
            
        }.navigationBarTitle("Guest List")
        .onAppear {
            eventViewModel.fetchData()
        }
    }
    
    func checkArrived(guest: Guest) -> Bool {
        for event in eventViewModel.events {
            if event.id == self.event.id {
                if event.arrivedGuests!.contains(guest.email!) {
                    return true
                } else {
                    return false
                }
            }
        }
        return false
    }
    
    func checkAttendance(guest: Guest) -> Bool {
        for event in eventViewModel.events {
            if event.id == self.event.id {
                if event.attendance!.contains(guest.email!) {
                    return true
                } else {
                    return false
                }
            }
        }
        return false
    }
}
