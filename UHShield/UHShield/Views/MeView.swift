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
    @StateObject var profileVM = ProfileViewModel()
    @State var profile = Profile(email: "", firstName: "User", lastName: "User", role: "guest")
    
    func getCurrentUserProfile(){
        if self.session.session != nil && self.profileVM.profiles.count != 0 {
            let i = self.profileVM.profiles.firstIndex(where: {$0.email == self.session.session?.email ?? "nil@nil.com"}) ?? -1
            if (i == -1) {
                // if no such a profile in the database
                self.profile.email = self.session.session?.email ?? "nil@nil.com"
            } else {
                self.profile =  self.profileVM.profiles[i]
            }
        }
    }
    
    func getCurrentUserName() -> String {
        print("The current user profile is: \(self.profile)")
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
                    Text("Hello, \(self.profile.firstName)!")
                        .font(.system(size: 18, weight: .medium))
                    
                    NavigationLink(destination: EditProfileView(profile: $profile)) {
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
            .onAppear(){
                self.profileVM.fetchData()
                self.getCurrentUserProfile()
                print("Fetching profileVM for MeView")
            }
        }
    }
}

