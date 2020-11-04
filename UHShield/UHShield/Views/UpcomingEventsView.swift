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
                                //if (isTheDateToday(event: event)){
                                EventRowView(event: event).padding(.horizontal).onTapGesture {
                                    print("An event is tapped!")
                                    self.showGuestList = true
                                    self.tappedEvent = event
                                }
                                
                                // }
                            }
                        }
                    }
                }
                .onAppear(){
                    self.eventVM.fetchData()
                    print("Fetching data in Events View")
                }
//                if(showGuestList) {
//                    GuestListView(showGuestList: $showGuestList, events: eventVM, event: tappedEvent)
//                }
                NavigationLink(destination: GuestListView(guests: self.tappedEvent.guests ?? [Guest](), event: tappedEvent), isActive: self.$showGuestList) {
                    Text("")
                }
            }
        }
    }
    
    func isTheDateToday(event: Event) -> Bool{
        // return true if the event starts or ends around the current time ( 1 hour )
        let currentTime = Date()
        print("Current time is: \(currentTime)")
        print("data time is: \(event.startTime!)")
        if (event.startTime! < currentTime + 3600 && event.endTime! > currentTime - 3600) {
            return true
        }
        return false
    }
}

struct GuestListView: View {
    
   // @Binding var showGuestList: Bool
    var guests: [Guest]
    var event: Event
    
    var body: some View {
        List(guests.indices, id: \.self){ index in
            HStack{
                Text("\(guests[index].name!)")
            }
            
        }
        
    }
    
}
