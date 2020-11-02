//
//  EventRowView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/11/1.
//

import SwiftUI

struct EventRowView: View {
    var event: Event
    var body: some View {
        VStack{
            HStack{
                Text("Room\(String(event.location.roomID))")
                    .font(.system(size: 20, weight: .bold))
                Spacer()
                Text("\(event.startTime, style: .time) to \(event.endTime, style: .time)")
            }
            HStack{
                Text(event.sponsor)
                Spacer()
                Text("\(String(event.arrivedGuests.count)) / \(String(event.guests.count)) Guests Arrived")
            }
        }.padding(.vertical, 10)
    }
}



/*
 struct ProjectRowView: View {
     var project: Project
     @EnvironmentObject var profiles: ProfileViewModel
     @Binding var showedProfile: Profile
     @Binding var isOpenProfile: Bool
     
     // filter the profileData to get profiles that in the given project
     func getParticipants(project: String) -> [Profile] {
         
         var participants = [Profile]()
         for profile in profiles.profiles {
             if profile.projects.contains(project) {
                 
                 participants.append(profile)
             }
         }
         return participants
     }
     
     var body: some View {
         VStack(alignment: .leading) {
             HStack {
                 WebImage(url: URL(string: self.project.picture)).renderingMode(.original)
                     .resizable()
                     .cornerRadius(50)
                     .frame(width: 60, height:60)
                 Text(self.project.name)
                     .font(.system(size: 20, weight: .bold))
             }
             
             Text(self.project.description)
                 .fixedSize(horizontal: false, vertical: true)
             
             ScrollView(.horizontal, showsIndicators: false) {
                 HStack(spacing: 10) {
                     ForEach(self.project.interests, id: \.self) {interest in
                         Text("  \(interest)  ")
                             
                             .fontWeight(.semibold)
                             .padding(5)
                             .background(LinearGradient(gradient: Gradient(colors: [Color("bg2"), Color("bg1")]), startPoint: .leading, endPoint: .trailing))
                             .foregroundColor(Color.white)
                             .cornerRadius(5)
                             
                         
                     }
                 }
             }
             Divider()
             
             ScrollView(.horizontal, showsIndicators: false) {
                 HStack(spacing: 10) {
                     ForEach(getParticipants(project: project.name) , id: \.self) { participant in
                         
                         WebImage(url: URL(string: participant.picture))
                             .renderingMode(.original)
                             .resizable()
                             .frame(width: 50, height: 50)
                             .cornerRadius(50)
                             .onTapGesture {
                                 self.showedProfile = participant
                                 self.isOpenProfile = true
                             }
                         
                     }
                 }
             }
         }.padding(.vertical, 10)
     }
 }
 */
