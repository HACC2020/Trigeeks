//
//  BadgeRowView.swift
//  UHShield
//
//  Created by Tianhui Zhou on 10/31/20.
//

import SwiftUI

struct BadgeRowView: View {
    
    var badge: Badge
    @EnvironmentObject var badges: BadgeViewModel
    
    
    var body: some View {
        VStack{
            Text("hihasdhasjkdhda")
            Text(self.badge.assignedTime)
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
