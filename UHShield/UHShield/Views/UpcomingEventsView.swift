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
    var body: some View {
        ZStack{
            ScrollView{
                LazyVStack{
                    
                    ForEach(self.eventVM.events) { event in
                        //if (isTheDateToday(event: event)){
                            EventRowView(event: event).padding(.horizontal)
                            
                       // }
                    }
                }
            }
            
        }
        .onAppear(){
            self.eventVM.fetchData()
            print("Fetching data in Events View")
        }
    }
    
    func isTheDateToday(event: Event) -> Bool{
        // return true if the event starts or ends around the current time ( 1 hour )
        let currentTime = Date()
        print("Current time is: \(currentTime)")
        print("data time is: \(event.startTime)")
        if (event.startTime < currentTime + 3600 && event.endTime > currentTime - 3600) {
            return true
        }
        return false
    }
}
