//
//  MyEventsView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//

import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift

struct MyEventsView: View {
    @StateObject var eventVM = EventViewModel()
    var body: some View {
        ZStack{
            ScrollView{
                LazyVStack{
                    ForEach(self.eventVM.events) { event in
                        if (event.sponsor == getCurrentUser()) {
                        EventRowView(event: event).padding(.horizontal)
                        Spacer().frame(height: 1).background(Color("bg2"))
                        }
                    }
                }
            }

        }
        .onAppear(){
            self.eventVM.fetchData()
            print("Fetching data in MyEvents View")
        }
    }
}

func getCurrentUser() -> String {
    let userEmail : String = (Auth.auth().currentUser?.email)!
    return userEmail
}
