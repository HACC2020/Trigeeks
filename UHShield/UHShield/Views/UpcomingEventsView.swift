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
    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    ScrollView{
                        LazyVStack{
                            
                            ForEach(self.eventVM.events) { event in
                                if (isTheDateToday(event: event)){
                                EventRowView(event: event).padding(.horizontal).onTapGesture {
                                    print("An event is tapped!")
                                    self.showGuestList = true
                                    self.tappedEvent = event
                                }
                                
                                 }
                            }
                        }
                    }
                }
                .onAppear(){
                    self.eventVM.fetchData()
                    print("Fetching data in Events View")
                }

                NavigationLink(destination: GuestListView(guests: self.tappedEvent.guests ?? [Guest](), event: tappedEvent), isActive: self.$showGuestList) {
                    Text("")
                }
            }.navigationBarHidden(true)
                
            
        }
    }
    
    func isTheDateToday(event: Event) -> Bool{
        // return true if the event starts or ends around the current time ( 1 hour )
        let currentTime = Date()
        print("Current time is: \(currentTime)")
        print("data time is: \(event.startTime!)")
        if (event.startTime! < currentTime + 36000 && event.endTime! > currentTime - 36000) {
            return true
        }
        return false
    }
    
    func test(){
        print("The passing data:")
        print(self.tappedEvent)
    }
}

struct GuestListView: View {
    
    
    var guests: [Guest]
    @State var event: Event
    @State var guestName = ""
    @State var guestEmail = ""
    @State var showCheckin = false
    @StateObject var eventVM = EventViewModel()
    @State var theEve = Event()
    
    var body: some View {
        ZStack{
            List{
            ForEach(guests.indices, id: \.self){ index in
                HStack{
                    Image(systemName: "person.circle.fill").font(.largeTitle).padding(.vertical, 10)
                    Text("\(guests[index].name!)")
                    Spacer()
                    ForEach(self.eventVM.events){ eventV in
                        if(eventV.id == event.id){
                            if(eventV.attendance!.contains(guests[index].email!)){
                                Image(systemName: "hand.thumbsup.fill").font(.system(size: 30, weight: .regular)).foregroundColor(.yellow)
                            }
                            if(eventV.arrivedGuests!.contains(guests[index].email!)){
                        Image(systemName: "checkmark.shield.fill").font(.system(size: 30, weight: .regular)).foregroundColor(.green)
                    }
                        }
                    }
                    
                }.onTapGesture {
                    self.showCheckin = true
                    self.guestName = guests[index].name!
                    self.guestEmail = guests[index].email!

                }

            }
            }.onAppear {
                
            }

            NavigationLink(destination: CheckInView(details: [event.id!, guestName, guestEmail], isShowCheckInView: $showCheckin), isActive: self.$showCheckin) {
                Text("")
            }
            
        }.navigationBarTitle("\(event.eventName!)", displayMode: .inline)
        .onAppear {
           // self.test()
            self.eventVM.fetchData()
            
        }
    }
    
    
}
