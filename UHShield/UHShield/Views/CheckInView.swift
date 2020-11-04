//
//  CheckInView.swift
//  UHShield
//
//  Created by weirong he on 11/2/20.
//

import SwiftUI

struct CheckInView: View {
    let details: [String]
    @Binding var isShowCheckInView: Bool
    @StateObject var eventViewModel = EventViewModel()
    
    let dateFormatter = DateFormatter()
    let dateFormatterPresent = DateFormatter()
    let timeFormatterPresent = DateFormatter()
    @State var startTime = ""
    @State var endTime = ""
    @State var date = ""
    @State var isShowAddBadge = false
    
    @State var event = Event(eventName: "", sponsor: "", guests: [], arrivedGuests: [], location: Location(building: "", roomID: ""), startTime: Date(), endTime: Date())
    
    var body: some View {
        
        ZStack {
            VStack {
                
                if checkEvent() {
                    Text("Please check ID with guest").fontWeight(.bold).font(.title).foregroundColor(Color("bg1"))
                    VStack {
                        HStack {
                            Text("Guest Information").fontWeight(.bold).font(.title)
                            Spacer()
                        }
                        HStack {
                            Text("Name:       ")
                            Text("\(details[6])").font(.title3)
                            Spacer()
                        }
                        HStack {
                            Text("Email:         ")
                            Text("\(details[7])").font(.title3)
                            Spacer()
                        }
                        HStack {
                            Text("Event:        ")
                            Text("\(details[0])").font(.title3)
                            Spacer()
                        }
                        HStack {
                            Text("Sponsor:    ")
                            Text("\(details[1])").font(.title3)
                            Spacer()
                        }
                        HStack {
                            Text("Date:          ")
                            Text("\(date)").font(.title3)
                            Spacer()
                        }
                        HStack {
                            Text("Start Time:")
                            Text("\(startTime)").font(.title3)
                            Spacer()
                        }
                        HStack {
                            Text("End Time:  ")
                            Text("\(endTime)").font(.title3)
                            Spacer()
                        }
                        HStack {
                            Text("Location:    ")
                            Text("\(details[2]) \(details[3])").font(.title3)
                            Spacer()
                        }
                        HStack {
                            Button(action: {handleConfirmButton()}, label: {
                                Text("Confirm").font(.title3).fontWeight(.semibold).foregroundColor(.white)
                            }).padding().buttonStyle(LongButtonStyle())
                            
                            Button(action: {handleCloseButton()}, label: {
                                Text("Deny").font(.title3).fontWeight(.semibold).foregroundColor(.white)
                            }).padding().buttonStyle(RedLongButtonStyle())
                        }
                    }.padding()
                    .background(
                        RoundedRectangle(cornerRadius: 25).foregroundColor(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)))
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 8, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -10, y: -10)
                    ).padding(30)
                } else {
                    VStack {
                        HStack {
                            Text("Access Denied!").fontWeight(.bold).font(.largeTitle).foregroundColor(.red)
                            Spacer()
                        }
                        Text("This is not a valid QR-Code. Please check with guest in other way!").font(.title3)
                        Button(action: {handleCloseButton()}, label: {
                            Text("Close").font(.title3).fontWeight(.semibold).foregroundColor(.white)
                        }).padding().buttonStyle(LongButtonStyle())
                    }.padding()
                    .background(
                        RoundedRectangle(cornerRadius: 25).foregroundColor(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)))
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 8, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -10, y: -10)
                    ).padding(30)
                }
                
            }.frame(maxWidth: .infinity ,maxHeight: .infinity)
            .background(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)).ignoresSafeArea())
            .onAppear {
                eventViewModel.fetchData()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
                dateFormatterPresent.dateFormat = "y-M-d"
                timeFormatterPresent.dateFormat = "H:m a"
                
                startTime = timeFormatterPresent.string(from: dateFormatter.date(from: "\(details[4])")!)
                date = dateFormatterPresent.string(from: dateFormatter.date(from: "\(details[4])")!)
                endTime = timeFormatterPresent.string(from: dateFormatter.date(from: "\(details[5])")!)
            }
            
            if isShowAddBadge {
                AddBadgeView(isShowAddBadge: $isShowAddBadge, guestName: details[6], guestEmail: details[7])
                    .transition(.move(edge: .bottom))
                    .animation(.linear)
                    .onDisappear {
                    handleCloseButton()
                }
            }
        }
        
    }
    
    func checkEvent() -> Bool {
        for event in eventViewModel.events {
            if event.eventName == details[0] && event.sponsor == details[1] && event.location == Location(building: details[2], roomID: details[3]) {
                return true
            }
        }
        return false
    }
    
    func handleCloseButton() {
        isShowCheckInView = false
    }
    
    func handleConfirmButton() {
        
        for event in eventViewModel.events {
            if event.eventName == details[0] && event.sponsor == details[1] && event.location == Location(building: details[2], roomID: details[3]) {
                self.event = Event(id: event.id, eventName: event.eventName, sponsor: event.sponsor, guests: event.guests, arrivedGuests: event.arrivedGuests, location: event.location, startTime: event.startTime, endTime: event.endTime)
            }
        }
        
        if !self.event.arrivedGuests!.contains(details[7]) {
            self.event.arrivedGuests!.append(details[7])
            eventViewModel.updateEvent(event: self.event)
        }
        isShowAddBadge = true
    }
}

struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView(details: ["Test", "John", "POST", "101", "2020-11-03 02:39:18 +0000", "2020-11-03 02:39:18 +0000", "Weir", "heweiron@hawaii.edu"], isShowCheckInView: .constant(false))
    }
}
