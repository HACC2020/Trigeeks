//
//  BadgeRowView.swift
//  UHShield
//
//  Created by Tianhui Zhou on 10/31/20.
//

import SwiftUI

struct BadgeRowView: View {
    
    var badge: Badge
    @State var offset = CGSize.zero
    @State var showConfirm = false
    @StateObject var badgeVM = BadgeViewModel()
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                HStack {
                    Text("BadgeID: \(self.badge.badgeID!)")
                        .font(.title).fontWeight(.bold).foregroundColor(Color("bg1"))
                }.padding([.horizontal, .top])
                HStack {
                    Text(self.badge.guestID!)
                        .font(.system(size: 15, weight: .bold))
                }.padding(.horizontal)
                .padding(.leading, 20)
                
                HStack{
                    Text(self.badge.assignedTime!, style: .time).padding([.horizontal, .bottom])
                    Text(self.badge.assignedTime!, style: .date).padding(.bottom)
                }.padding(.leading, 20)
                
                Divider()
            }.frame(height: 100)
            .offset(x: offset.width)
            
            
            Spacer()
            if showConfirm {
                HStack {
                    Text("Confirm").fontWeight(.bold).foregroundColor(.white)
                }.frame(width: 100,height: 100).background(Color.orange)
                .onTapGesture(perform: {
                    badgeVM.deleteBadge(badge: badge)
                })
                .animation(.spring())

            } else {
                HStack {
                    Text("Detele").fontWeight(.bold).foregroundColor(.white)
                }.frame(width: abs(offset.width) < 10 ? 0 : abs(offset.width),height: 100).background(Color.red)
                .onTapGesture(perform: {
                    withAnimation(.spring()) {
                        showConfirm = true
                    }
                })
            }
            
        }
        .animation(.spring())
        .background(Rectangle().fill(Color.white))
        
        .gesture(DragGesture().onChanged { value in

            withAnimation(.spring()) {
                showConfirm = false
            }
            if offset.width <= -100 && value.translation.width > offset.width {
                offset = CGSize(width: value.translation.width - 100, height: offset.height)
            } else {
                if value.translation.width > 0 {
                    offset = CGSize.zero
                } else {
                    offset = value.translation
                }
            }

        }
        .onEnded { value in
            if offset.width <= -100 {
                offset = CGSize(width: -100, height: offset.height)
            } else {
                offset = CGSize.zero
            }
        }
        )
    }
}

struct BadgeRowView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeRowView(badge: Badge(guestID: "wei@test.com", assignedTime: Date(), badgeID: "001"))
    }
}
