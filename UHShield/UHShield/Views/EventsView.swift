//
//  EventsView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//

import SwiftUI

struct EventsView: View {
    @StateObject var eventVM = EventViewModel()
    @State var showEndedEvents = false
    var body: some View {
        VStack{
            Toggle(isOn: $showEndedEvents) {
                Text("Show ended events")
            }.padding()
            ScrollView{
                LazyVStack{
                    ForEach(self.eventVM.events.filter{showEndedEvents ? true : $0.endTime! >= Date()}.sorted {(lhs:Event, rhs:Event) in
                        return lhs.startTime! < rhs.startTime!
                    }) { event in 
                        EventRowView(event: event).padding(.horizontal)
                            .animation(.interactiveSpring())
                        Spacer().frame(height: 1)
                    }
                }
            }

        }
        .onAppear(){
            self.eventVM.fetchData()
            print("Fetching data in Events View")
        }
    }
}
