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
    @State var datepicked = Date()
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        
                        DatePicker("", selection: $datepicked, displayedComponents: .date).padding(.horizontal).datePickerStyle(DefaultDatePickerStyle())
                        
                        Spacer()
                        
                    }.padding(.horizontal)
                    
                    if (self.eventVM.events.filter{$0.sponsor!.contains((Auth.auth().currentUser?.email) ?? "")}.filter{Calendar.current.isDate($0.startTime!, inSameDayAs:datepicked)}.count > 0) { // check if there is event for user
                        ScrollView {
                            LazyVStack(alignment: .leading) {
                                ForEach(self.eventVM.events.filter{$0.sponsor!.contains((Auth.auth().currentUser?.email)!)}.filter{Calendar.current.isDate($0.startTime!, inSameDayAs:datepicked)} ) { event in
                                    HStack(alignment: .top) {
                                        // start time
                                        Text("\(event.startTime!, style: .time)").fontWeight(.semibold).frame(width: 80)
                                        
                                        // dot and line
                                        VStack {
                                            
                                            Circle().frame(width: 10, height: 10).foregroundColor(Color(#colorLiteral(red: 0.4647484422, green: 0.6298647523, blue: 1, alpha: 1)))
                                            HStack {
                                                Rectangle().foregroundColor(Color(#colorLiteral(red: 0.4647484422, green: 0.6298647523, blue: 1, alpha: 1))).frame(width: 5).frame(minHeight: 80)
                                            }
                                        }
                                        
                                        // event information
                                        HStack {
                                            VStack(alignment: .leading) {
                                                Text("\(event.eventName!)").font(.title3).fontWeight(.semibold)
                                                VStack(alignment: .leading) {
                                                    Text("\((event.location?.building)!) \(event.location!.roomID)").font(.footnote).fontWeight(.semibold)
                                                    Text("\(String(event.arrivedGuests!.count)) / \(String(event.guests!.count)) Guests Arrived").font(.footnote).fontWeight(.semibold)
                                                    Spacer()
                                                    
                                                }.padding(.leading, 20)
                                                Text("end at: \(event.endTime! , style: .time)").font(.footnote).fontWeight(.semibold).foregroundColor(.gray)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right").padding(.horizontal)
                                        }.padding().background(Color(#colorLiteral(red: 0.9080156684, green: 0.9026180506, blue: 0.9121648669, alpha: 1)))
                                        .onTapGesture {
                                            self.showWindow = true
                                            self.tappedEvent = event
                                        }
                                        
                                        
                                    }
                                    
                                }
                                
                            }
                            
                        }
                    } else {
                        Spacer()
                        Text("You don't have event in this day.")
                        Spacer()
                    }
                    
                }.onAppear {
                    eventVM.fetchData()
                }
                .navigationBarHidden(true)
                
                NavigationLink(destination: ArrivedGuestView(event: self.tappedEvent, guests: self.tappedEvent.guests ?? [Guest]()), isActive: $showWindow){
                    Text("")
                }
            }
            
        }
    }
    func getCurrentUser() -> String {
        let userEmail : String = (Auth.auth().currentUser?.email) ?? ""
        print("current user email: \(userEmail)")
        return userEmail
    }
}

struct MyEventsView_Previews: PreviewProvider {
    static var previews: some View {
        MyEventsView()
    }
}



struct ArrivedGuestView: View {
    //@Binding var showWindow: Bool
    @State var event: Event
    var guests: [Guest]
    
    @StateObject var eventVM = EventViewModel()
    @State var showConfirm = false
    @State var tappedGuest = Guest()
    var body: some View{
        
            ZStack{
                List{
                    ForEach(self.eventVM.events) { theEvent in
                        if(theEvent.id == event.id){
                            ForEach(self.guests.indices){ index in
                                if(theEvent.arrivedGuests!.contains(guests[index].email!)){
                                    
                                        if((theEvent.attendance) != nil){
                                            if(theEvent.attendance!.contains(guests[index].email!)){
                                                HStack{
                                                Image(systemName: "person.circle.fill").font(.largeTitle).padding(.vertical, 10)
                                                Text("\(guests[index].name!)")
                                                Spacer()
                                                Image(systemName: "checkmark.shield.fill").font(.system(size: 30, weight: .regular)).foregroundColor(.green)
                                                }
                                            } else {
                                                HStack{
                                                Image(systemName: "person.circle.fill").font(.largeTitle).padding(.vertical, 10)
                                                Text("\(guests[index].name!)")
                                                Spacer()
                                                }.onTapGesture {
                                                    self.showConfirm = true
                                                    self.tappedGuest = guests[index]
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
                if(showConfirm){
                    AttendanceWindow(showWindow: $showConfirm, eventVM: self.eventVM, event: event, guest: self.tappedGuest)
                }
            }.navigationBarTitle("\(event.eventName!)", displayMode: .inline)
            .onAppear {
                self.eventVM.fetchData()
            }
        
    }
}

struct AttendanceWindow: View {
    
    @Binding var showWindow: Bool
    var eventVM: EventViewModel
    var event: Event
    var guest: Guest
    
    @State var tempEvent = Event()
    var body: some View{
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
            
            //            Rectangle().fill(Color.white)
            //                .cornerRadius(10)
            //                .shadow(color: .gray, radius: 5, x: 1, y: 1)
            VStack(spacing: 25){
                Image("check-mark-badge").resizable().cornerRadius(10).frame(width:100, height: 100)
                
                Text("Take Attendance").font(.title).foregroundColor(.black)
                Divider()
                Text("Guest Name: \(guest.name!)")
                Text("Guest ID: \(guest.email!)")
                Divider()
                Text("Are you sure the information is correct?")
                HStack{
                    Button(action: {
                        self.showWindow.toggle()
                        for eachEvent in self.eventVM.events{
                            if(self.event.id! == eachEvent.id!){
                                tempEvent = eachEvent
                            }
                        }
                        tempEvent.attendance?.append(guest.email!)
                        self.eventVM.updateEvent(event: tempEvent)
                    }) {
                        Text("Confirm").foregroundColor(Color.white).fontWeight(.bold).padding(.vertical, 10).padding(.horizontal, 25).background(Color("button1")).clipShape(Capsule())
                    }
                    
                    Button(action: {
                        self.showWindow.toggle()
                    }) {
                        Text("Cancel").foregroundColor(Color.white).fontWeight(.bold).padding(.vertical, 10).padding(.horizontal, 25).background(Color("button2")).clipShape(Capsule())
                    }
                }
            }
            .padding(.vertical, 25).padding(.horizontal, 30).background(BlurView()).cornerRadius(25)
//            .padding().background(Color.white).cornerRadius(20)
//            .animation(.interpolatingSpring(mass: 1, stiffness: 90, damping: 10, initialVelocity: 0))
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.primary.opacity(0.35))
    }
}

