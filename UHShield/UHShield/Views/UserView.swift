//
//  UserView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//

import SwiftUI
import FirebaseAuth

struct UserView: View {
    @EnvironmentObject var session: SessionStore
    @StateObject var profileViewModel = ProfileViewModel()
    @Binding var selection: Int
    @State var showSearch = false
    // if there is no profile or error occurs, by default the user is a guest
    // do not change this
    @State var viewSelection: String = "GuestView"
    var body: some View {
        
        Group {
            if profileViewModel.profiles.count > 0 {
                VStack {
                    // MARK: - Top Bar
                    
                    HStack {
                        Text("UH Shield")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            showSearch = true
                        }) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }.padding(.trailing, 20)
                        .fullScreenCover(isPresented: $showSearch, content: {
                            SearchView()
                        })
                        
                        if self.viewSelection == "SponsorView" {
                            
                            Button(action: {
                                withAnimation(.spring()) {
                                    self.selection = 21
                                }
                            }) {
                                Image(systemName: "plus.circle")
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        else if self.viewSelection == "ReceptionView" {
                            
                            Button(action: {
                                self.selection = 11
                            }) {
                                Image(systemName: "camera.viewfinder")
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        
                        
                    }
                    .padding()
                    .background(Color("bg1").edgesIgnoringSafeArea(.top))
                    // end of top bar
                    
                    // MARK: -Main Views: Sponsor or Reception View
                    if self.viewSelection == "GuestView" {
                        VStack{
                            TabView {
                                MeView().environmentObject(profileViewModel)
                                    .tabItem {
                                        VStack {
                                            Image(systemName: "person.fill")
                                            Text("Me")
                                        }
                                    }.tag(0)
                                
                            }.background(Color(.gray))
                        }
                    }
                    
                    else if self.viewSelection == "SponsorView" {
                        
                        VStack {
                            TabView {
                                EventsView()
                                    .tabItem {
                                        VStack {
                                            Image(systemName: "calendar")
                                            Text("Events")
                                        }
                                    }.tag(0)
                                
                                MyEventsView()
                                    .tabItem {
                                        VStack {
                                            Image(systemName: "eyeglasses")
                                            Text("My Events")
                                        }
                                    }.tag(1)
                                
                                MeView().environmentObject(profileViewModel)
                                    .tabItem {
                                        VStack {
                                            Image(systemName: "person.fill")
                                            Text("Me")
                                        }
                                    }.tag(2)
                            }.background(Color(.gray))
                        }
                    }
                    
                    else if self.viewSelection == "ReceptionView" {
                        VStack {
                            TabView {
                                UpcomingEventsView()
                                    .tabItem {
                                        VStack {
                                            Image(systemName: "calendar")
                                            Text("Upcoming events")
                                        }
                                    }.tag(0)
                                
                                BadgesView()
                                    .tabItem {
                                        VStack {
                                            Image(systemName: "folder.fill")
                                            Text("Badges")
                                        }
                                    }.tag(1)
                                
                                MeView().environmentObject(profileViewModel)
                                    .tabItem {
                                        VStack {
                                            Image(systemName: "person.fill")
                                            Text("Me")
                                        }
                                    }.tag(2)
                                
                            }.background(Color(.gray))
                        }
                    }
                    
                    
                }.onAppear {
                    checkRole()
                    print("viewSelection = \(self.viewSelection)")
                }
            } else {
                VStack {
                    Text("Loading...")
                }
            }
        }.onAppear {
            profileViewModel.fetchData()
        }
        
        
    }
    
    func checkRole() {
        for profile in profileViewModel.profiles {
            if profile.email == Auth.auth().currentUser?.email {
                if profile.role == "sponsor" {
                    self.viewSelection = "SponsorView"
                }
                if profile.role == "reception" {
                    self.viewSelection = "ReceptionView"
                }
            }
        }
        
    }
}
