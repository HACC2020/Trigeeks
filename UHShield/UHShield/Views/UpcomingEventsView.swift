//
//  UpcomingEventsView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/11/2.
//

import SwiftUI

struct UpcomingEventsView: View {
    @StateObject var eventVM = EventViewModel()
    var body: some View {
        ZStack{
            ScrollView{
                LazyVStack{
                    ForEach(self.eventVM.events) { event in
                        if (isTheDateToday(event: event)){
                        EventRowView(event: event).padding(.horizontal)
                        Spacer().frame(height: 1).background(Color("bg2"))
                        }
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
        if (event.startTime < currentTime + 3600 && event.endTime > currentTime - 3600) {
            return true
        }
        return false
    }
}
