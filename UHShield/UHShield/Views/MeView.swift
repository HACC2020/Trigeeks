//
//  MeView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/11/2.
//

import SwiftUI
import FirebaseFirestore
import Firebase
import FirebaseFirestoreSwift

struct MeView: View {
    @EnvironmentObject var session: SessionStore
    
    func getCurrentUser() -> String {
        var userEmail = ""
        if self.session.session != nil {
            userEmail = (Auth.auth().currentUser?.email)!
        }
        return userEmail
    }
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
                VStack (spacing: 20){
                    Spacer()
                    Text("Hello, \(getCurrentUser())!")
                    
                    NavigationLink(destination: EditProfileView()) {
                        Text("Edit your Profile")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                            .background(LinearGradient(gradient: Gradient(colors: [Color("blue4"), Color("bg1")]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(5)
                    }
                    
                    // leave for other buttons
                    Button(action: session.signOut) {
                        Text("Another Sign Out")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                            .background(LinearGradient(gradient: Gradient(colors: [Color("blue4"), Color("bg1")]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(5)
                        
                    }
                    
                    Spacer()
                    
                    Button(action: session.signOut) {
                        Text("Sign Out")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                            .background(LinearGradient(gradient: Gradient(colors: [Color("blue3"), Color("bg1")]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(5)
                        
                    }
                    
                    Spacer()
                }.padding(.horizontal, 32)
                
                
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}
