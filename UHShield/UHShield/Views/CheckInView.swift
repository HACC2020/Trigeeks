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
    @StateObject var profileViewModel = ProfileViewModel()
    
    @State var isShowAddBadge = false
    @State var isShowWarning = false
    
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
                        }.padding()
                        HStack {
                            Text("Name:").frame(width: 90, alignment: .leading)
                            Text("\(details[1])").font(.headline)
                            Spacer()
                        }
                        HStack {
                            Text("Email:").frame(width: 90, alignment: .leading)
                            Text("\(details[2])").font(.headline)
                            Spacer()
                        }
                        HStack {
                            Text("Event:").frame(width: 90, alignment: .leading)
                            Text("\(event.eventName!)").font(.headline)
                            Spacer()
                        }
                        HStack {
                            Text("Sponsor:").frame(width: 90, alignment: .leading)
                            Text("\(getSponsorName())").font(.headline)
                            Spacer()
                        }
                        HStack {
                            Text("Date:").frame(width: 90, alignment: .leading)
                            Text("\(event.startTime!, style: .date)").font(.headline)
                            Spacer()
                        }
                        HStack {
                            Text("Start Time:").frame(width: 90, alignment: .leading)
                            Text("\(event.startTime!, style: .time)").font(.headline)
                            Spacer()
                        }
                        HStack {
                            Text("End Time:").frame(width: 90, alignment: .leading)
                            Text("\(event.endTime!, style: .time)").font(.headline)
                            Spacer()
                        }
                        HStack {
                            Text("Location:").frame(width: 90, alignment: .leading)
                            Text("\(event.location!.building) \(event.location!.roomID)").font(.headline)
                            Spacer()
                        }
                        HStack {
                            Button(action: {handleConfirmButton()}, label: {
                                Text("Confirm").font(.headline).fontWeight(.semibold).foregroundColor(.white)
                            }).padding().buttonStyle(LongButtonStyle())
                            
                            Button(action: {handleCloseButton()}, label: {
                                Text("Cancel").font(.headline).fontWeight(.semibold).foregroundColor(.white)
                            }).padding().buttonStyle(RedLongButtonStyle())
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 25).foregroundColor(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)))
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 4, y: 5)
                            .shadow(color: Color.white.opacity(0.4), radius: 5, x: -5, y: -5)
                    ).padding(30)
                    .onAppear {
                        getEvent()
                    }
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
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 4, y: 5)
                            .shadow(color: Color.white.opacity(0.4), radius: 5, x: -5, y: -5)
                    ).padding(30)
                }
                
            }.frame(maxWidth: .infinity ,maxHeight: .infinity)
            .background(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)).ignoresSafeArea())
            //Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1))
            .onAppear {
                eventViewModel.fetchData()
                profileViewModel.fetchData()
            }
            
            if isShowAddBadge {
                AddBadgeView(isShowAddBadge: $isShowAddBadge, guestName: details[1], guestEmail: details[2], building: details[3])
                    .transition(.move(edge: .bottom))
                    .animation(.linear)
                    .onDisappear {
                    handleCloseButton()
                }
            }
            
            if isShowWarning {
                AlertView(showAlert: $isShowWarning, alertMessage: .constant("Attention! This Guest has already checked in! Please be careful on assigning badge!"), alertTitle: "WARNING")
            }
        }
        
    }
    
    func checkEvent() -> Bool {
        if details.count == 4 {
            for event in eventViewModel.events {
                if event.id == details[0] {
                    return true
                }
            }
        }
        return false
    }
    
    func getEvent() {
        for event in eventViewModel.events {
            if event.id == details[0] {
                self.event = event
            }
        }
    }
    
    func getSponsorName() -> String {
        for profile in profileViewModel.profiles {
            if profile.email == event.sponsor {
                return "\(profile.firstName) \(profile.lastName)"
            }
        }
        return event.sponsor!
    }
    
    func handleCloseButton() {
        isShowCheckInView = false
    }
    
    func handleConfirmButton() {
        
        if !self.event.arrivedGuests!.contains(details[2]) {
            self.event.arrivedGuests!.append(details[2])
            eventViewModel.updateEvent(event: self.event)
        } else {
            isShowWarning = true
        }
        isShowAddBadge = true
    }
}

struct CheckInView_Previews: PreviewProvider {
    static var previews: some View {
        CheckInView(details: ["F2B9C6A5-2B8C-47E8-BAF5-DA5DEE058607", "Wei", "heweiron@hawaii.edu"], isShowCheckInView: .constant(true))
    }
}
