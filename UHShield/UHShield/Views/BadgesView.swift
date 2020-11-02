//
//  BadgesView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//

import SwiftUI
import Foundation

struct BadgesView: View {
    @StateObject var badges = BadgeViewModel()
    @State private var search = ""
    
    var body: some View {
        NavigationView{
            VStack{
                SearchBar(text: $search)
                ScrollView{
                    LazyVStack{
                        ForEach(self.badges.badges.filter{self.search.isEmpty ? true : $0.guestID.localizedCaseInsensitiveContains(self.search)})
                        { badge in
                            
                            BadgeRowView(badge: badge).padding(.horizontal).onTapGesture {
                                print("Tap me!")
                            }
                            
                        }
                        
                    }.onAppear{
                        self.badges.fetchData()
                        
                    }
                }
            }.navigationBarTitle("Processing Badges", displayMode: .inline).navigationBarItems(trailing: EditButton())
            
        }
    }
    func deleteItem(at offsets: IndexSet){
        self.badges.badges.remove(atOffsets: offsets)
    }
}

//struct BadgesView_Previews: PreviewProvider {
//    static var previews: some View {
//        BadgesView()
//    }
//}
