//
//  BadgesView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//

import SwiftUI
import Foundation
import FirebaseAuth

struct BadgesView: View {
    @StateObject var badges = BadgeViewModel()
    @StateObject var profileVM = ProfileViewModel()
    @State private var search = ""
    @State var showWindow = false
    @State var recycledBadge = Badge()
    var body: some View {
        ZStack {
            VStack{
                SearchBar(text: $search)
                
                ScrollView{
                    LazyVStack {
                        
                        HStack {
                            Text("Your workplace:")
                            Spacer()
                            if getProfileBuilding() == "" {
                                Text("Please go to setting and select your workplace").foregroundColor(.red)
                            } else {
                                Text("\(getProfileBuilding())")
                            }
                        }.padding()
                        
                        if self.badges.badges.filter{$0.building! == getProfileBuilding()}.count == 0 {
                            // if no event
                            Spacer()
                            Text("There is no assigned badges right now in your workplace!")
                            Spacer()
                        }
                        
                        ForEach(self.badges.badges
                                    .filter{$0.building! == getProfileBuilding()}
                                    .filter{self.search.isEmpty ? true : $0.badgeID!.localizedCaseInsensitiveContains(self.search) || $0.guestID!.localizedCaseInsensitiveContains(self.search)}.sorted {(lhs:Badge, rhs:Badge) in
                                        return lhs.assignedTime! > rhs.assignedTime!
                                    }) { badge in
                            BadgeRowView(badge: badge)
                        }
                        

                        
                        //                        ForEach(self.badges.badges.filter{self.search.isEmpty ? true : $0.guestID!.localizedCaseInsensitiveContains(self.search)}.sorted {(lhs:Badge, rhs:Badge) in
                        //                            return lhs.assignedTime! > rhs.assignedTime!
                        //                        }) { badge in
                        //                            BadgeRowView(badge: badge)
                        //                        }
                    }
                }.onAppear{
                    self.badges.fetchData()
                    self.profileVM.fetchData()
                }
                
                
            }
            //            if showWindow {
            //                ConfirmWindow(showWindow: $showWindow, badge: recycledBadge).transition(.move(edge: .trailing))
            //            }
        }
    }
    
    func getProfileBuilding() -> String {
        for profile in profileVM.profiles {
            if profile.email == Auth.auth().currentUser?.email {
                return profile.building
            }
        }
        return ""
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
