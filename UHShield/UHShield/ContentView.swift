//
//  ContentView.swift
//  UHShield
//
//  Created by weirong he on 10/27/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var eventVM: EventViewModel
    @State private var showView = false
    @State private var angle: Double = 720
    @State private var opacity: Double = 1
    @State private var scale: CGFloat = 1
    
    var body: some View {
        Group{
            if showView{
        Group{
            
            if session.session != nil {
                //user already logged in
//                MainView()
                SelectionView()
            } else {
                // no available loggin state
                SignInView()
            }
        }.onAppear {
            self.getUser()
        }
            } else {
                ZStack{
                    Color("color1").edgesIgnoringSafeArea(.all)
                    Image("logo1_modi").rotation3DEffect(.degrees(angle), axis: (x: 0.0, y: 1.0, z: 0.0)).opacity(opacity).scaleEffect(scale)
                }.onAppear{
                    withAnimation(.linear(duration: 1)){
                        angle = 0
                        scale = 1
                        opacity = 0
                    }
                    withAnimation(Animation.linear.delay(1.2)){
                        showView = true
                    }
                }
            }
    }
    }
    func getUser(){
        session.listen()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
