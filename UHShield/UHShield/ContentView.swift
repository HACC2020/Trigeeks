//
//  ContentView.swift
//  UHShield
//
//  Created by weirong he on 10/27/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var session: SessionStore
    var body: some View {
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
