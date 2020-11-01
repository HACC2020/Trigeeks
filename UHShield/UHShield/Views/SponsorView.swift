//
//  SponsorView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//

import SwiftUI

struct SponsorView: View {
    @EnvironmentObject var session: SessionStore
    @Binding var selection: Int
    
    var body: some View {
        VStack {
            TopBar2(selection: $selection)
            TabView {
                
                EventsView()
                    .tabItem {
                        VStack {
                            Image(systemName: "calendar")
                            Text("Events")
                        }
                }.tag(0)
                
                MyEventsView()
                    .tabItem {
                        VStack {
                            Image(systemName: "eyeglasses")
                            Text("My Events")
                        }
                }.tag(1)
            
                UserView()
                    .tabItem {
                        VStack {
                            Image(systemName: "person.fill")
                            Text("Me")
                        }
                }.tag(2)
                
            }.background(Color(.gray))
        }
    }
    
}

struct TopBar2: View {
    @Binding var selection: Int
    var body: some View {
        VStack (spacing: 20){
            HStack {
                Text("UH Shield")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    self.selection = 1
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }.padding(.trailing, 20)
                
                Button(action: {
                    self.selection = 21
                }) {
                    Image(systemName: "plus.circle")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(Color("bg1").edgesIgnoringSafeArea(.top))
    }
}

struct SponsorView_Previews: PreviewProvider {
    static var previews: some View {
      PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State(initialValue: 0) var selection: Int
        var body: some View {
            SponsorView(selection: $selection).environmentObject(SessionStore())
      }
    }
}

