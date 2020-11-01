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
            if selection == 0 {
                ReceptionistView(selection: $selection)
            } else if selection == 1{
                SearchView()
            } else if selection == 2{
                // change to scanner view
                SearchView()
            } else if selection == 10 {
                SponsorView(selection: $selection)
            } else if selection == 11 {
                // change to add event view
                EditEventView()
            } else if selection == 12 {
                EditEventView()
            }
        }
    }
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView().environmentObject(SessionStore())
    }
}

