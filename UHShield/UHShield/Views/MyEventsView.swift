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
                
                // date picker
                VStack {
                    HStack {
                        
                        Text("Show events on").padding()
                        Spacer()
                        DatePicker("", selection: $datepicked, displayedComponents: .date).padding(.horizontal).datePickerStyle(DefaultDatePickerStyle())
                    
                    }.padding(.horizontal)
                    
                    // events list
                    if (self.eventVM.events.filter{$0.sponsor!.contains((Auth.auth().currentUser?.email) ?? "")}.filter{Calendar.current.isDate($0.startTime!, inSameDayAs:datepicked)}.count > 0) { // check if there is event for user
                        ScrollView {
                            LazyVStack(alignment: .leading) {
                                ForEach(self.eventVM.events.filter{$0.sponsor!.contains((Auth.auth().currentUser?.email)!)}.filter{Calendar.current.isDate($0.startTime!, inSameDayAs:datepicked)}
                                            .sorted {(lhs:Event, rhs:Event) in
                                                return lhs.startTime! < rhs.startTime!
                                            } ) { event in
                                    
                                    MyEventRow(event: event, showWindow: $showWindow, tappedEvent: $tappedEvent)
                                }
                            }
                        } // end of scrollView
                    } else {
                        Spacer()
                        Text("You don't have event in this day.")
                        Spacer()
                    }
                    
                }.onAppear {
                    eventVM.fetchData()
                }
                .navigationBarHidden(true)
                
                NavigationLink(destination: MyEventDetailView(event: $tappedEvent), isActive: $showWindow){
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

struct MyEventRow: View {
    var event: Event
    @Binding var showWindow: Bool
    @Binding var tappedEvent : Event
    var body: some View {
        HStack(alignment: .top) {
            // start time
            Text("\(event.startTime!, style: .time)").fontWeight(.semibold).frame(width: 80)
            
            // dot and line
            VStack {
                if event.startTime! < Date() && event.endTime! > Date() {
                    Circle().frame(width: 10, height: 10).foregroundColor(Color(#colorLiteral(red: 0.9444511533, green: 0, blue: 0, alpha: 1)))
                    HStack {
                        Rectangle().foregroundColor(Color(#colorLiteral(red: 0.9444511533, green: 0, blue: 0, alpha: 1))).frame(width: 5).frame(minHeight: 80)
                    }
                } else if event.endTime! < Date() {
                    Circle().frame(width: 10, height: 10).foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)))
                    HStack {
                        Rectangle().foregroundColor(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))).frame(width: 5).frame(minHeight: 80)
                    }
                } else {
                    Circle().frame(width: 10, height: 10).foregroundColor(Color(#colorLiteral(red: 0.4647484422, green: 0.6298647523, blue: 1, alpha: 1)))
                    HStack {
                        Rectangle().foregroundColor(Color(#colorLiteral(red: 0.4647484422, green: 0.6298647523, blue: 1, alpha: 1))).frame(width: 5).frame(minHeight: 80)
                    }
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
