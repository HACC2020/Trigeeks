//
//  SelectionView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//

import SwiftUI
import FirebaseAuth

struct SelectionView: View {
    @EnvironmentObject var session: SessionStore
    @StateObject var profileViewModel = ProfileViewModel()
    @State var selection: Int = 0
    var body: some View {
        Group {
            if profileViewModel.profiles.count > 0 {
                VStack {
                    if selection == 0{
                        GuestView(selection: $selection)
                    } else if selection == 1 {
                        SearchView(selection: $selection).environmentObject(profileViewModel)
                    } else if selection == 10 {
                        ReceptionistView(selection: $selection)
                    } else if selection == 11{
                        // change to QR code scanner view
                        ScannerLayoutView(selection: $selection)
                    } else if selection == 20 {
                        SponsorView(selection: $selection)
                    } else if selection == 21 {
                        AddEventView(selection: $selection).transition(.slide)
                    }
                }.onAppear {checkRole()}
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
                    selection = 20
                } else if profile.role == "reception" {
                    selection = 10
                } else if profile.role == "guest" {
                    selection = 0
                }
            }
        }
    }
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView().environmentObject(SessionStore())
    }
}

