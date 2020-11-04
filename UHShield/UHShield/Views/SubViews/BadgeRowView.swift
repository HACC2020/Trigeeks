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
            ZStack{
                Rectangle().fill(Color.white)
                    .cornerRadius(10)
                    .shadow(color: .gray, radius: 5, x: 1, y: 1)
                
        HStack{
            Image(systemName: "person.circle.fill").font(.largeTitle).padding(.leading, 10)
            VStack{
                Text(self.badge.badgeID!)
                    .font(.system(size: 20, weight: .bold))
                Text(self.badge.guestID!)
                    .font(.system(size: 16, weight: .bold))
            }
            Spacer()
            VStack{
    
                Text(self.badge.assignedTime!, style: .time)
                Text(self.badge.assignedTime!, style: .date)
            }
            
            Image("check-mark-badge")
                .resizable().cornerRadius(10).frame(width:65, height: 65)
            
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
