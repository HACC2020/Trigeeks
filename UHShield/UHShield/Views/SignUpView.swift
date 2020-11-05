//
//  SignUpView.swift
//  UHShield
//
//  Created by weirong he on 10/28/20.
//

import SwiftUI

struct SignUpView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @State var rePassword: String = ""
    @State var isVisiable = false
    @State var showAlert = false
    
    @EnvironmentObject var session: SessionStore
    @StateObject var profileViewModel = ProfileViewModel()
    var TextColor = Color("bg1")
    
    var body: some View {
        ZStack {
            VStack {
                
                // title of the View
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Create Account")
                            .fontWeight(.heavy)
                            .font(.largeTitle)
                            .foregroundColor(TextColor)
                        
                        Text("Sign Up to get started")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }.padding(.bottom, 20)
                
                // information entering field
                VStack {
                    VStack{
                        VStack(alignment: .leading) {
                            
                            // email text filed
                            Text("Email")
                                .fontWeight(.semibold)
                                .font(.title)
                                .foregroundColor(TextColor)
                            TextField("Email address", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .modifier(TextFieldModifier())
                        }
                        
                        
                        
                        VStack(alignment: .leading) {
                            
                            // Password text filed
                            Text("Password")
                                .fontWeight(.semibold)
                                .font(.title)
                                .foregroundColor(TextColor)
                            HStack {
                                
                                if isVisiable {
                                    TextField("Enter Your Password", text: $password)
                                        .modifier(TextFieldModifier())
                                } else {
                                    SecureField("Enter Your Password", text: $password)
                                        .padding(1)
                                        .modifier(TextFieldModifier())
                                }
                                
                                // change visiable password button
                                Button(action: {
                                    self.isVisiable.toggle()
                                }, label: {
                                    Image(systemName: "eye.fill").foregroundColor(.gray)
                                    
                                }).buttonStyle(SmallButtonStyle())

                            } // end of HStack containing password and eye button
                        }
                        
                        // Re-enter password field
                        TextField("Re-Enter Password", text: $rePassword)
                            .modifier(TextFieldModifier())
                        
                    }.padding()
                    
                    // sign up button
                    Button(action: signUp){
                        Text("Sign Up").fontWeight(.semibold)
                            .font(.title2)
                            .foregroundColor(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)))
                    }.padding().buttonStyle(LongButtonStyle())
                    
                    
                }.background( // Information Field Background
                    RoundedRectangle(cornerRadius: 15).foregroundColor(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)))
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 8, y: 10)
                        .shadow(color: Color.white.opacity(0.7), radius: 10, x: -10, y: -10)
                )
                
                Spacer()
                
               // Whole View Background
            }.padding(.horizontal, 32)
            .padding(.vertical, 50)
            .background(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)))
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                profileViewModel.fetchData()
            }
            
            
            // if error occured show the alert popup View
            if showAlert {
                AlertView(showAlert: $showAlert, alertMessage: $error, alertTitle: "ERROR").transition(.slide)
            }
        }
    }
    
    func signUp(){
        if rePassword != password {
            error = "Your passwords don't match"
            showAlert = true
        } else {
            session.signUp(email: email, password: password) { (result, error) in
                if let error = error {
                    self.error = error.localizedDescription
                    showAlert = true
                } else {
                    profileViewModel.addProfile(profile: Profile(id: email ,email: email, firstName: "", lastName: "", role: "sponsor"))
                    self.email = ""
                    self.password = ""
                }
            }
        }
    }
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
