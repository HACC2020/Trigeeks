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


/*
 import SwiftUI

 struct UserView: View {
     @EnvironmentObject var session: SessionStore
     @EnvironmentObject var profiles: ProfileViewModel
     @Binding var selection: Int
     @State var profile = Profile()
     
     func getCurrentUser() {
         if self.session.session != nil && self.profiles.profiles.count != 0 {
             let i = self.profiles.profiles.firstIndex(where: {$0.id == self.session.session?.uid ?? "007"}) ?? 0
             self.profile = self.profiles.profiles[i]
         }
     }
     
     var body: some View {
         NavigationView{
             VStack(spacing: 20) {
                 VStack (spacing: 20){
                     HStack {
                         Text("User Settings")
                             .font(.system(size: 22, weight: .semibold))
                             .foregroundColor(.white)
                         
                         Spacer()
                     }
                 }
                 .padding()
                 .padding(.top, (UIApplication.shared.windows.last?.safeAreaInsets.top)! + 10)
                 .background(Color("bg1"))
                 
                 VStack (spacing: 20){
                     Spacer()
                     Text("Hello, \(self.profile.name)")
                     
                     NavigationLink(destination: EditView(profile: self.$profile)) {
                         Text("Edit your Profile")
                             .frame(minWidth: 0, maxWidth: .infinity)
                             .frame(height: 50)
                             .foregroundColor(.white)
                             .font(.system(size: 14, weight: .bold))
                             .background(LinearGradient(gradient: Gradient(colors: [Color("bg3"), Color("bg2")]), startPoint: .leading, endPoint: .trailing))
                             .cornerRadius(5)
                     }
                     
                     Button(action: session.signOut) {
                         Text("Sign Out")
                             .frame(minWidth: 0, maxWidth: .infinity)
                             .frame(height: 50)
                             .foregroundColor(.white)
                             .font(.system(size: 14, weight: .bold))
                             .background(LinearGradient(gradient: Gradient(colors: [Color("bg3"), Color("bg2")]), startPoint: .leading, endPoint: .trailing))
                             .cornerRadius(5)
                         
                     }
                     
                     Spacer()
                     
                     Button(action: {
                         self.selection = 0
                     }) {
                         Text("Back")
                             .frame(minWidth: 0, maxWidth: .infinity)
                             .frame(height: 50)
                             .foregroundColor(.white)
                             .font(.system(size: 14, weight: .bold))
                             .background(LinearGradient(gradient: Gradient(colors: [Color("bg2"), Color("bg1")]), startPoint: .leading, endPoint: .trailing))
                             .cornerRadius(5)
                         
                     }
                     
                     Spacer()
                 }.padding(.horizontal, 32)
                 
                 
             }
             .edgesIgnoringSafeArea(.top)
             .onAppear(perform: getCurrentUser)
         }
     }
 }


 struct UserView_Previews: PreviewProvider {
     static var previews: some View {
         PreviewWrapper()
     }
     
     struct PreviewWrapper: View {
         @State(initialValue: 0) var selection: Int
         
         var body: some View {
             UserView(selection: $selection).environmentObject(SessionStore()).environmentObject(ProfileViewModel())
         }
     }
 }
 */
