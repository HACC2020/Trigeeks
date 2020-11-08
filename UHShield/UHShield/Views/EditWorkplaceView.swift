//
//  EditWorkplaceView.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/11/7.
//

import SwiftUI
import FirebaseFirestore
import Firebase

struct EditWorkplaceView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var locations: LocationsViewModel
    @Binding var profile: Profile
    @State var building: String = ""
    @State private var showPopUp = false
    
    func editWorkplace(){
        let db = Firestore.firestore()
        db.collection("Profiles").document(profile.email).setData(["building": building], merge: true)
    }
    
    
    var body: some View {
        
        NavigationView {
            ZStack{
                VStack {
                    VStack{
                        Text("Change Workplace")
                            .font(.system(size: 32, weight: .heavy))
                        Text("Edit your current working building")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                    }
                    .padding(.top, -130)
                    
                    VStack(spacing: 18) {
                        TextField("Fake Field", text: $building)
                            .font(.system(size: 18))
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(.gray), lineWidth: 1))
                        
                        TextField("Workping building", text: $building)
                            .font(.system(size: 18))
                            .padding(12)
                            .background(RoundedRectangle(cornerRadius: 5).strokeBorder(Color(.gray), lineWidth: 1))
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

                            VStack {
                                Image("check-mark-badge").resizable().cornerRadius(10).frame(width:100, height: 100)
                                Text("Workplace Successfully Updated!")
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
                                self.editWorkplace()
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
