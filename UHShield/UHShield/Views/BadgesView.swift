//
//  BadgesView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//

import SwiftUI

struct BadgesView: View {
    @ObservedObject var badges = BadgeViewModel()
    
    var body: some View {
        ZStack{
            ScrollView{
                LazyVStack{
                    ForEach(self.badges.badges){ badge in
                        Text("hihihihih")
                    }
                }.onAppear{
                    self.badges.fetchData()
                }
            }
        }
    }
    func test(){
        print(self.badges)
        print("test")
    }
}

//struct BadgesView_Previews: PreviewProvider {
//    static var previews: some View {
//        BadgesView()
//    }
//}
