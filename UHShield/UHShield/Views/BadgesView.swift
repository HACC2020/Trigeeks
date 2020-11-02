//
//  BadgesView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//

import SwiftUI
import Foundation

struct BadgesView: View {
    @StateObject var badges = BadgeViewModel()
    @State private var search = ""
    @State var showWindow = false
    
    var body: some View {
        NavigationView{
            ZStack{
            VStack{
                SearchBar(text: $search)
                ScrollView{
                    LazyVStack{
                        ForEach(self.badges.badges.filter{self.search.isEmpty ? true : $0.guestID.localizedCaseInsensitiveContains(self.search)})
                        { badge in
                            
                            BadgeRowView(badge: badge).padding(.horizontal).onTapGesture {
                                print("Tap me!")
                                self.showWindow = true
                            }
                            
                        }
                        
                    }.onAppear{
                        self.badges.fetchData()
                        


                    }
                }
            }.navigationBarTitle("Processing Badges", displayMode: .inline).navigationBarItems(trailing: EditButton())
                if(showWindow){
                    ConfirmWindow(showWindow: $showWindow)
                }
        }
    }
    }
}

struct ConfirmWindow: View {
    
    @Binding var showWindow: Bool
    
    var body: some View {
        VStack{
            Text("hi there")
            Button(action: {
                self.showWindow.toggle()
            }) {
                Text("OK").padding(.vertical).frame(width: UIScreen.main.bounds.width - 120).foregroundColor(Color.white)
                }.background(Color("bg1")).cornerRadius(20)
            }.padding().background(Color.white).cornerRadius(20)
        .animation(.interpolatingSpring(mass: 1, stiffness: 90, damping: 10, initialVelocity: 0))
        
    }
}
