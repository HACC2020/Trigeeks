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
    @State var showWindow = false
    @State var recycledBadge = Badge()
    var body: some View {
        NavigationView{
            ZStack{
            VStack{
                SearchBar(text: $search)
                ScrollView{
                    LazyVStack{
                        ForEach(self.badges.badges.filter{self.search.isEmpty ? true : $0.guestID!.localizedCaseInsensitiveContains(self.search)})
                        { badge in
                            
                            BadgeRowView(badge: badge).padding(.horizontal).onTapGesture {
                                print("Tap me!")
                                self.showWindow = true
                                self.recycledBadge = badge
                            }
                            
                        }
                        
                    }.onAppear{
                        self.badges.fetchData()
                    }
                    
                }
            }.navigationBarTitle("Processing Badges", displayMode: .inline).navigationBarItems(trailing: EditButton())
                if(showWindow){
                    ConfirmWindow(showWindow: $showWindow, badges: badges, badge: recycledBadge)
                }
        }
    }
    }
}

struct ConfirmWindow: View {
    
    @Binding var showWindow: Bool
    var badges: BadgeViewModel
    var badge: Badge
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .trailing, vertical: .top)){
            
            //            Rectangle().fill(Color.white)
            //                .cornerRadius(10)
            //                .shadow(color: .gray, radius: 5, x: 1, y: 1)
            VStack(spacing: 25){
                Image("check-mark-badge").resizable().cornerRadius(10).frame(width:100, height: 100)
                
                Text("Recycle Badge").font(.title).foregroundColor(.black)
                Text("Are you sure you the information is correct?")
                HStack{
                    Button(action: {
                        self.showWindow.toggle()
                        self.badges.deleteBadge(badge: badge)
                    }) {
                        Text("Confirm").foregroundColor(Color.white).fontWeight(.bold).padding(.vertical, 10).padding(.horizontal, 25).background(Color("button1")).clipShape(Capsule())
                    }
                    
                    Button(action: {
                        self.showWindow.toggle()
                    }) {
                        Text("Cancel").foregroundColor(Color.white).fontWeight(.bold).padding(.vertical, 10).padding(.horizontal, 25).background(Color("button2")).clipShape(Capsule())
                    }
                }
            }
            .padding(.vertical, 25).padding(.horizontal, 30).background(BlurView()).cornerRadius(25)
//            .padding().background(Color.white).cornerRadius(20)
//            .animation(.interpolatingSpring(mass: 1, stiffness: 90, damping: 10, initialVelocity: 0))
            
        }.frame(maxWidth: .infinity, maxHeight: .infinity).background(Color.primary.opacity(0.35))
        .onAppear{
            self.test()
        }
    }
    
    func test(){
        print("This is a message from popUp window: \(self.badge)")
    }
}

struct BlurView : UIViewRepresentable {
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThinMaterial))
        
        return blurView
    }
    
}
