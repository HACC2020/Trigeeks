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
    @State var showWindow = false
    @State var tappedEvent = Event()
    
    var body: some View {
        NavigationView{
        ZStack{
            ScrollView{
                LazyVStack{
                    ForEach(self.eventVM.events) { event in
                        if (event.sponsor == getCurrentUser()) {
                            EventRowView(event: event).padding(.horizontal).onTapGesture {
                                self.showWindow = true
                                self.tappedEvent = event
                            }
                        Spacer().frame(height: 1).background(Color("bg2"))
                        }
                    }
                }
            }
            NavigationLink(destination: ArrivedGuestView(event: self.tappedEvent, guests: self.tappedEvent.guests ?? [Guest]()), isActive: $showWindow){
                Text("")
            }

        }
        .onAppear(){
            self.eventVM.fetchData()
            print("Fetching data in MyEvents View")
        }
        .navigationBarHidden(true)
    }
    }
}

func getCurrentUser() -> String {
    let userEmail : String = (Auth.auth().currentUser?.email)!
    print("current user email: \(userEmail)")
    return userEmail
}

struct ArrivedGuestView: View {
    //@Binding var showWindow: Bool
    @State var event: Event
    var guests: [Guest]
    
    @StateObject var eventVM = EventViewModel()
    @State var showConfirm = false
    var body: some View{
        
            ZStack{
                List{
                    ForEach(self.eventVM.events) { theEvent in
                        if(theEvent.id == event.id){
                            ForEach(self.guests.indices){ index in
                                if(theEvent.arrivedGuests!.contains(guests[index].email!)){
                                    HStack{
                                        Image(systemName: "person.circle.fill").font(.largeTitle).padding(.vertical, 10)
                                        Text("\(guests[index].name!)")
                                        Spacer()
                                        if((theEvent.attendance) != nil){
                                            if(theEvent.attendance!.contains(guests[index].email!)){
                                                Image(systemName: "checkmark.shield.fill").font(.system(size: 30, weight: .regular)).foregroundColor(.green)
                                            }
                                        }
                                    }
                                } else {
                                    HStack{
                                        Image(systemName: "person.circle.fill").font(.largeTitle).padding(.vertical, 10).foregroundColor(.gray)
                                        Text("\(guests[index].name!)").foregroundColor(.gray)
                                        Spacer()
                                    }
                            }
                        }
                    }
                }
                }
            }.navigationBarTitle("\(event.eventName!)", displayMode: .inline)
            .onAppear {
                self.eventVM.fetchData()
            }
        
    }
}

//                    ForEach(guests.indices, id: \.self){ index in
//                        if(event.arrivedGuests!.contains(guests[index].email!)){
//                        HStack{
//                            Image(systemName: "person.circle.fill").font(.largeTitle).padding(.vertical, 10)
//                            Text("\(guests[index].name!)")
//                            Spacer()
//                            ForEach(self.eventVM.events){ eventV in
//                                if(eventV.id == event.id){
//                                    if(eventV.arrivedGuests!.contains(guests[index].email!)&&(eventV.attendance!.contains(guests[index].email!))){
//                                Image(systemName: "checkmark.shield.fill").font(.system(size: 30, weight: .regular)).foregroundColor(.green)
//                            }
//                                }
//                            }
//                        }
//                        } else {
//                            HStack{
//                                Image(systemName: "person.circle.fill").font(.largeTitle).padding(.vertical, 10).foregroundColor(.gray)
//                                Text("\(guests[index].name!)").foregroundColor(.gray)
//                                Spacer()
//                            }
//                        }
//                    }
                
