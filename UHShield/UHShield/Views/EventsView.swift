//
//  EventsView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//

import SwiftUI

struct EventsView: View {
    @EnvironmentObject var eventVM: EventViewModel
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

struct EventsView_Previews: PreviewProvider {
    static var previews: some View {
        EventsView()
    }
}

/*
 struct ProfileView: View {
     @EnvironmentObject var projects: ProjectViewModel
     @EnvironmentObject var profiles: ProfileViewModel
     @Binding var forceReload: Bool
     @Binding var showedProject: Project
     @Binding var isOpenProject: Bool
     
     var body: some View {
         ZStack{
             ScrollView{
                 LazyVStack{
                     ForEach(self.profiles.profiles) { profile in
                         ProfileRowView(profile: profile, showedProject: $showedProject, isOpenProject: $isOpenProject).padding(.horizontal)
                         Spacer().frame(height: 12).background(Color("bg5"))
                     }
                 }
                 .onAppear {
                     self.profiles.fetchData()
                     self.projects.fetchData()
                 }
             }

         }
     }
     
 }
 */
