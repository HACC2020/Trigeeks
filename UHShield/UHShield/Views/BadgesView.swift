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
    @State var recycledBadge = Badge()
    var body: some View {
        ZStack {
            VStack{
                SearchBar(text: $search)
                //ScrollView{
                List{
                    ForEach(self.badges.badges.filter{self.search.isEmpty ? true : $0.guestID!.localizedCaseInsensitiveContains(self.search)}) { badge in
                        
                        BadgeRowView(badge: badge)
                        
                    }.onDelete(perform: { indexSet in
                        for i in indexSet {
                            print(self.badges.badges[i])
                            self.recycledBadge = self.badges.badges[i]

                                showWindow = true
                            
                        }
                    })
                    
                }.onAppear{
                    self.badges.fetchData()
                }
                
                
            }
            if showWindow {
                ConfirmWindow(showWindow: $showWindow, badge: recycledBadge).transition(.move(edge: .trailing))
            }
        }
    }
}

struct ConfirmWindow: View {
    
    @Binding var showWindow: Bool
    @StateObject var badgeVM = BadgeViewModel()
    var badge: Badge
    
    var body: some View {

            VStack {
                HStack {
                    Text("Attention").font(.title).bold().foregroundColor(Color.red.opacity(0.7))
                    Spacer()
                }.padding(.horizontal, 25)
                
                // error message
                Text("Are you sure to delete this Badge?").foregroundColor(Color.black.opacity(0.7)).padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 120)
                
                // confirm button
                HStack {
                    HStack {
                        Button(action: {handleConfirmDelete()}, label: {
                            Text("Confirm").font(.title3).fontWeight(.semibold).foregroundColor(.white)
                        }).padding().buttonStyle(RedLongButtonStyle())
                        
                        Button(action: {showWindow = false}, label: {
                            Text("Cancel").font(.title3).fontWeight(.semibold).foregroundColor(.white)
                        }).padding().buttonStyle(LongButtonStyle())
                    }
                }
            }.padding().background(Color.white).cornerRadius(20)
            .animation(.spring())
    }
    
    func handleConfirmDelete() {
        // delete from database
        badgeVM.deleteBadge(badge: badge)
        showWindow = false
    }
}
