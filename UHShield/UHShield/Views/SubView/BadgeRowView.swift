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
        HStack{
            Image("check-mark-badge")
                .resizable().cornerRadius(10).frame(width:60, height: 60)
            Text(self.badge.guestID)
                .font(.system(size: 20, weight: .bold))
            Spacer()
            VStack{
    
                Text(self.badge.assignedTime, style: .time)
                Text(self.badge.assignedTime, style: .date)
            }
        }
            Divider().background(Color("bg7"))
        }
    }
}

//struct BadgeRowView_Previews: PreviewProvider {
//    static var previews: some View {
//        BadgeRowView()
//    }
//}
