//
//  SelectionView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//

import SwiftUI

struct SelectionView: View {
    @EnvironmentObject var session: SessionStore
    @State var selection: Int = 10
    var body: some View {
        Group {
            if selection == 0{
                UserView()
                
            } else if selection == 1 {
                BadgesView()
            } else if selection == 10 {
                ReceptionistView(selection: $selection)
            } else if selection == 11{
                // change to QR code scanner view
                ScannerLayoutView(selection: $selection)
            } else if selection == 20 {
                SponsorView(selection: $selection)
            } else if selection == 21 {
                // change to add event view

                AddEventView(selection: $selection).transition(.slide)

            }
        }
    }
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView().environmentObject(SessionStore())
    }
}

