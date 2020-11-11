//
//  EditProfileView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/11/2.
//

import SwiftUI
import FirebaseFirestore
import Firebase

struct EditProfileView: View {
    @EnvironmentObject var session: SessionStore
    @Binding var profile: Profile
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @State var role: String = ""
    
    @State private var showPopUp = false
    
    func editProfile(){
        let db = Firestore.firestore()
        email = profile.email
        role = profile.role
        profile.firstName = self.firstName
        db.collection("Profiles").document(profile.email).setData(["email": email, "firstName": firstName, "lastName": lastName, "role": role], merge: true)
    }
    
    
    var body: some View {
        
        NavigationView {
            ZStack{
                VStack {
                    VStack{
                        Text("Change Profile")
                            .font(.system(size: 32, weight: .heavy))
                        Text("Edit your personal information")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, -130)
                    
                    VStack(spacing: 18) {
                        TextField("Role: \(profile.role.capitalized)", text: $role)
                            .disabled(true)
                            .font(.system(size: 18))
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(.gray), lineWidth: 0))
                        TextField("First Name", text: $firstName)
                            .font(.system(size: 14))
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(.gray), lineWidth: 1))
                            .disableAutocorrection(true)
                        TextField("Last Name", text: $lastName)
                            .font(.system(size: 14))
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(.gray), lineWidth: 1))
                            .disableAutocorrection(true)
                    }
                    .padding(.top, -40)
                    .padding(.bottom, 40)
                    
                    
                    Button(action: {
                        self.showPopUp = true
                    }) {
                        Text("Edit Profile")
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: 50)
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                            .background(LinearGradient(gradient: Gradient(colors: [Color("blue4"), Color("blue5")]), startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(5)
                        
                    }
                    
                    Spacer()
                    
                }
                .onAppear(){
                    print("The profile passed to edit view is: \(profile)")
                }
                .padding(.horizontal, 32)
                
                if $showPopUp.wrappedValue {
                    ZStack {
                        Color.white
                        
                        if firstName == "" || lastName == "" {
                            VStack {
                                Text("Update Failed.\nFirst Name and Last Name cannot be empty.")
                                    .font(.system(size: 18, weight: .medium))
                                    .multilineTextAlignment(.center)
                                Spacer()
                                Button(action: {
                                    self.showPopUp = false
                                }, label: {
                                    Text("Close")
                                        .font(.system(size: 16, weight: .medium))
                                })
                            }.padding()
                            
                        } else {
                            
                            VStack {
                                Image("check-mark-badge").resizable().cornerRadius(10).frame(width:100, height: 100)
                                Text("Profile Successfully Updated!")
                                    .font(.system(size: 18, weight: .medium))
                                Spacer()
                                Button(action: {
                                    self.showPopUp = false
                                }, label: {
                                    Text("Close")
                                        .font(.system(size: 16, weight: .medium))
                                })
                            }
                            .padding()
                            .onAppear(){
                                self.editProfile()
                            }
                        }
                    }
                    .frame(width: 300, height: 200, alignment: .center)
                    .cornerRadius(20).shadow(radius: 20)
                    .offset(y: -100)
                    .padding(.bottom, -100)
                }
                
            }
        }
    }
}

