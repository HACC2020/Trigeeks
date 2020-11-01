//
//  ReceptionistView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/10/31.
//

import SwiftUI

struct ReceptionistView: View {
    @EnvironmentObject var session: SessionStore
    
    var body: some View {
        VStack {
            TopBar()
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
        .edgesIgnoringSafeArea(.top)
    }
    
}

struct TopBar: View {
    var body: some View {
        VStack (spacing: 20){
            HStack {
                Text("UH Shield")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    // button action
                }) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }.padding(.trailing, 20)
                
                Button(action: {
                }) {
                    Image(systemName: "camera.viewfinder")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                }
            }
        }
        .padding()
        .padding(.top, (UIApplication.shared.windows.last?.safeAreaInsets.top)! + 10)
        .background(Color("bg1"))
    }
}

struct ReceptionistView_Previews: PreviewProvider {
    static var previews: some View {
      PreviewWrapper()
    }

    struct PreviewWrapper: View {
        @State(initialValue: 0) var selection: Int
        var body: some View {
            ReceptionistView().environmentObject(SessionStore())
      }
    }
}
