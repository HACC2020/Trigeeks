//
//  ReceptionistView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//

import SwiftUI

struct ReceptionistView: View {
    @EnvironmentObject var session: SessionStore
    @Binding var selection: Int
    
    var body: some View {
        VStack {
            TopBar(selection: $selection)
            TabView {
                
                EventsView()
                    .tabItem {
                        VStack {
                            Image(systemName: "calendar")
                            Text("Upcoming events")
                        }
                }.tag(0)
                
                BadgesView()
                    .tabItem {
                        VStack {
                            Image(systemName: "folder.fill")
                            Text("Badges")
                        }
                }.tag(1)
            
                
            }.background(Color(.gray))
        }
    }
    
}

struct TopBar: View {
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
                    self.selection = 2
                }) {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .background(Color("bg1").edgesIgnoringSafeArea(.top))
    }
}

struct ReceptionistView_Previews: PreviewProvider {
    static var previews: some View {
      PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State(initialValue: 0) var selection: Int
        var body: some View {
            ReceptionistView(selection: $selection).environmentObject(SessionStore())
      }
    }
}
