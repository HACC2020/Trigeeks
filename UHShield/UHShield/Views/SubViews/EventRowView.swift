//
//  EventRowView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/11/1.
//

import SwiftUI

struct EventRowView: View {
    var event: Event
    @StateObject var profileViewModel = ProfileViewModel()
    var body: some View {
        VStack{
            ZStack{
                if event.startTime! > Date() {
                    RoundedRectangle(cornerRadius: 10).offset(x: -8).foregroundColor(.blue)
                } else if event.endTime! < Date() {
                    RoundedRectangle(cornerRadius: 10).offset(x: -8).foregroundColor(.gray)
                } else if event.startTime! <= Date() && event.endTime! >= Date() {
                    RoundedRectangle(cornerRadius: 10).offset(x: -8).foregroundColor(.red)
                }
                Rectangle().fill(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 5, x: 1, y: 1)
                VStack{
                    HStack{
                        
                        // event name and sponsor
                        VStack(alignment: .leading, spacing: 2){
                            Text(self.event.eventName!).font(.system(size: 25, weight: .bold))
                            Text("\(getSponsorName())").font(.system(size: 16, weight: .regular)).foregroundColor(.secondary)
                        }.padding()
                        Spacer()
                        
                        // location and arrived guest
                        VStack(alignment: .leading){
                            
                            if event.startTime! > Date() {
                                HStack {
                                    Circle().frame(width: 10, height: 10).foregroundColor(.blue)
                                    Text("Comming").foregroundColor(.blue)
                                }
                            } else if event.endTime! < Date() {
                                HStack {
                                    Circle().frame(width: 10, height: 10).foregroundColor(Color(.gray))
                                    Text("Ended").foregroundColor(Color(.gray))
                                }
                            } else if event.startTime! <= Date() && event.endTime! >= Date() {
                                HStack {
                                    Circle().frame(width: 10, height: 10).foregroundColor(Color(.red))
                                    Text("On").foregroundColor(Color(.red))
                                }
                            }
                            
                            HStack{
                                Text(event.location!.building).font(.system(size: 20, weight: .semibold))
                                Text(event.location!.roomID).font(.system(size: 20, weight: .semibold))
                            }
                            Text("\(String(event.arrivedGuests!.count)) / \(String(event.guests!.count)) Guests Arrived")
                        }.padding(.trailing, 10)
                        
                    }
                    
                    // time
                    Divider().background(Color("bg7"))
                    HStack {
                        VStack(alignment: .leading) {
                            Text("\(event.startTime!, style: .date)").foregroundColor(.white)
                            Text("Time: \(event.startTime!, style: .time) ~ \(event.endTime!, style: .time)").font(.system(size: 20, weight: .regular)).foregroundColor(.white)
                        }.padding()
                        Spacer()
                    }.background(LinearGradient(gradient: Gradient(colors: [Color("bg1"), Color("blue3")]), startPoint: .leading, endPoint: .trailing))
                }
            } // end of ZStack
            
        }//Vstack 1
        .padding(.vertical, 5)
        .onAppear {
            profileViewModel.fetchData()
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
}

struct EventRowView_Previews: PreviewProvider {
    static var previews: some View {
        EventRowView(event: Event(eventName: "Test Event", sponsor: "wei@sponsor.com", guests: [Guest(name: "Wei", email: "wei@test.com"), Guest(name: "Rong", email: "rong@test.com")], arrivedGuests: ["wei@test.com"], location: Location(building: "POST", roomID: "101"), startTime: Date(), endTime: Date(), attendance: []))
    }
}

