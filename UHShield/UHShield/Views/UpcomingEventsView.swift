//
//  UpcomingEventsView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/11/2.
//

import SwiftUI
import Foundation

struct UpcomingEventsView: View {
    
    @StateObject var eventVM = EventViewModel()
    @State var showGuestList = false 
    @State var tappedEvent = Event()
    @State var showEndedEvents = false
    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    Toggle(isOn: $showEndedEvents) {
                        Text("Show ended events")
                    }.padding()
                    ScrollView{
                        LazyVStack{
                            
                            ForEach(self.eventVM.events
                                        .filter{Calendar.current.isDate($0.startTime!, inSameDayAs:Date())}.filter{showEndedEvents ? true : $0.endTime! >= Date()}
                                        .sorted {(lhs:Event, rhs:Event) in
                                            return lhs.startTime! < rhs.startTime!
                                        }) { event in
                                    EventRowView(event: event).padding(.horizontal).onTapGesture {
                                        print("An event is tapped!")
                                        self.showGuestList = true
                                        self.tappedEvent = event
                                    }
                                    
                                
                            }
                        }
                    }
                }.navigationBarHidden(true)
                .onAppear(){
                    self.eventVM.fetchData()
                    print("Fetching data in Events View")
                }

                NavigationLink(destination: GuestListView(event: tappedEvent), isActive: self.$showGuestList) {
                    Text("")
                }
            }
                
            
        }
    }
//
//    func isTheDateToday(event: Event) -> Bool{
//        // return true if the event starts or ends around the current time ( 1 hour )
//        let currentTime = Date()
//        print("Current time is: \(currentTime)")
//        print("data time is: \(event.startTime!)")
//        if (event.startTime! < currentTime + 3600 && event.endTime! > currentTime - 3600) {
//            return true
//        }
//        return false
//    }
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
                        CheckInView(details: [event.id!, guest.name!, guest.email!], isShowCheckInView: $showCheckin)
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
