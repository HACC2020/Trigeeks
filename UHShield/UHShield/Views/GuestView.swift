//
//  GuestView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/11/4.
//

import SwiftUI

import SwiftUI

struct GuestView: View {
    @EnvironmentObject var session: SessionStore
    @Binding var selection: Int
    
    var body: some View {
        VStack {
            TopBar3(selection: $selection)
            TabView {
                
                MeView()
                    .tabItem {
                        VStack {
                            Image(systemName: "person.fill")
                            Text("Me")
                        }
                }.tag(0)
                
            }.background(Color(.gray))
        }
    }
    
}

struct TopBar3: View {
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
                
            }
        }
        .padding()
        .background(Color("bg1").edgesIgnoringSafeArea(.top))
    }
}
