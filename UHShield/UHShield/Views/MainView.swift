//
//  MainView.swift
//  UHShield
//
//  Created by weirong he on 10/27/20.
//

import SwiftUI

struct MainView: View {
    @State private var presentViewIndex = 0
    @State var isShowAddEventView = false
    
    var body: some View {
        ZStack {
            VStack {
                if presentViewIndex == 0 {
                    HomeView(isShowAddEventView: $isShowAddEventView)
                } else {
                    // TODO: change to actual View
//                    AddEventView(isShowAddEventView: $isShowAddEventView).transition(.slide)
                }
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], content: {
                    Button(action: {calendarButton()}, label: {
                        Image(systemName: "calendar").font(.system(size: presentViewIndex == 1 ? 40 : 30)).foregroundColor( presentViewIndex == 1 ? Color(#colorLiteral(red: 0.2302203178, green: 0.5502818823, blue: 1, alpha: 1)) : Color(#colorLiteral(red: 0.6329239607, green: 0.7881198525, blue: 1, alpha: 1)))
                    })
                    Button(action: {homeButton()}, label: {
                        Image(systemName: "house.fill").font(.system(size: presentViewIndex == 0 ? 40 : 30)).foregroundColor( presentViewIndex == 0 ? Color(#colorLiteral(red: 0.2302203178, green: 0.5502818823, blue: 1, alpha: 1)) : Color(#colorLiteral(red: 0.6329239607, green: 0.7881198525, blue: 1, alpha: 1)))
                    })
                    Button(action: {userButton()}, label: {
                        Image(systemName: "person.fill").font(.system(size: presentViewIndex == 2 ? 40 : 30)).foregroundColor(presentViewIndex == 2 ? Color(#colorLiteral(red: 0.2302203178, green: 0.5502818823, blue: 1, alpha: 1)) : Color(#colorLiteral(red: 0.6329239607, green: 0.7881198525, blue: 1, alpha: 1)))
                    })
                })
                .frame(height: 60)
                .background(Color(#colorLiteral(red: 0.9197699428, green: 0.9240266681, blue: 0.9344311953, alpha: 1)))
            }.ignoresSafeArea(edges: .bottom)
            if isShowAddEventView {
//                AddEventView(isShowAddEventView: $isShowAddEventView).transition(.slide)
            }
        }
    }
    
    //MARK: - Button Function
    func homeButton() {
        withAnimation(.spring()) {
            self.presentViewIndex = 0
        }
    }
    func calendarButton() {
        withAnimation(.spring()) {
            self.presentViewIndex = 1
        }
    }
    func userButton() {
        withAnimation(.spring()) {
            self.presentViewIndex = 2
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
