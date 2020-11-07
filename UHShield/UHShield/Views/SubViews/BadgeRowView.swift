//
//  BadgeRowView.swift
//  UHShield
//
//  Created by Tianhui Zhou on 10/31/20.
//

import SwiftUI

struct BadgeRowView: View {
    
    var badge: Badge
    //@State var offset = CGSize.zero
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                HStack {
                    Image(systemName: "text.and.command.macwindow").font(.title)
                    Text("BadgeID: \(self.badge.badgeID!)")
                        .font(.system(size: 20, weight: .bold))
                }.padding([.horizontal, .top])
                HStack {
                    Text(self.badge.guestID!)
                        .font(.system(size: 15, weight: .bold)).foregroundColor(Color("bg1"))
                }.padding(.horizontal)
                
                HStack{
                    Text(self.badge.assignedTime!, style: .time).padding([.horizontal, .bottom])
                    Text(self.badge.assignedTime!, style: .date).padding(.bottom)
                }
            }
            Spacer()
            
        }.background(Rectangle().fill(Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 5, x: 1, y: 1))
    }
}

struct BadgeRowView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeRowView(badge: Badge(guestID: "wei@test.com", assignedTime: Date(), badgeID: "001"))
    }
}
