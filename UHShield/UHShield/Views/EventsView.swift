//
//  EventsView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//

import SwiftUI

struct EventsView: View {
    @StateObject var eventVM = EventViewModel()
    var body: some View {
        ZStack{
            ScrollView{
                LazyVStack{
                    ForEach(self.eventVM.events) { event in 
                        EventRowView(event: event).padding(.horizontal)
                        Spacer().frame(height: 12).background(Color("bg2"))
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
