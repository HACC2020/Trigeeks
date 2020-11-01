//
//  BadgesView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//

import SwiftUI

struct BadgesView: View {
    @StateObject var badges = BadgeViewModel()
    
    var body: some View {
        ZStack{
            ScrollView{
                LazyVStack{
                    ForEach(self.badges.badges){ badge in
                        Text("hihihihih")
                    }.onAppear {
                        self.test()
                    }
                    
                }.onAppear{
                    self.badges.fetchData()
                    
                }
            }
        }
    }
    func test(){
        let a = self.badges.badges.count
        
        print("test")
        print(a)
    }
}

//struct BadgesView_Previews: PreviewProvider {
//    static var previews: some View {
//        BadgesView()
//    }
//}
