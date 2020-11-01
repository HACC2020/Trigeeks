//
//  SelectionView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//

import SwiftUI

struct SelectionView: View {
    @EnvironmentObject var session: SessionStore
    @State var selection: Int = 0
    var body: some View {
        Group {
            if selection == 0 {
                ReceptionistView(selection: $selection)
            } else if selection == 1{
                SearchView()
            } else if selection == 2{
                // change to scanner view
                SearchView()
            }
        }
    }
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView().environmentObject(SessionStore())
    }
}

