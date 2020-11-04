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
        
        
        VStack {
            Group {
                if selection == 0{
                    UserView(selection: $selection)
                } else if selection == 1 {
                    SearchView(selection: $selection)
                } else if selection == 11{
                    // change to QR code scanner view
                    ScannerLayoutView(selection: $selection)
                } else if selection == 21 {
                    AddEventView(selection: $selection).transition(.slide)
                }
            }
        }.onAppear {
            profileViewModel.fetchData()
        }
    }
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView().environmentObject(SessionStore())
    }
}

