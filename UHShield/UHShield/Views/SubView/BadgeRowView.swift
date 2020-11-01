//
//  BadgeRowView.swift
//  UHShield
//
//  Created by Tianhui Zhou on 10/31/20.
//

import SwiftUI

struct BadgeRowView: View {
    
    var badge: Badge
    
    var body: some View {
        VStack{
            Text("hihasdhasjkdhda")
            Text(self.badge.guestID)
                            .font(.system(size: 20, weight: .bold))
        }.onAppear{
            print("asas")
        }
    }
}

//struct BadgeRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        BadgeRowView()
//    }
//}
