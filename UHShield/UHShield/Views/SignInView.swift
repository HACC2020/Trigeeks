//
//  SignInView.swift
//  UHShield
//
//  Created by weirong he on 10/28/20.
//

import SwiftUI

struct SignInView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var error: String = ""
    @State var isVisiable = false
    @State var showAlert = false
    
    @EnvironmentObject var session: SessionStore
    var TextColor = Color("bg1")
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    
                    HStack {
                        Spacer()
                        Text("Welcome To UHShield!")
                            .fontWeight(.semibold)
                            .font(.largeTitle)
                            .foregroundColor(TextColor)
                            .multilineTextAlignment(.trailing)
                            .padding(.top, 40)
                            .padding(.leading, 6)
                            .frame(width: UIScreen.main.bounds.width*3/4)
                        
                    }
                    
                    
                    VStack {
                        // Log in Information field
                        VStack(alignment: .leading) {
                            
                            // email text filed
                            Text("Email")
                                .fontWeight(.semibold)
                                .font(.title)
                                .foregroundColor(TextColor)
                            
                            TextField("Enter Your Email", text: $email)
                                .keyboardType(.emailAddress)
                                .modifier(TextFieldModifier())
                            
                            
                            
                            // password text field
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
                            }
                        }.padding(20)
                        
                        
                        // Button log in
                        VStack {
                            Button(action: {signIn()}, label: {
                                Text("Login")
                                    .fontWeight(.semibold)
                                    .font(.title2)
                                    .foregroundColor(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)))
                            })
                            .buttonStyle(LongButtonStyle())
                            
                        }.padding()
                    }.background(
                        RoundedRectangle(cornerRadius: 15).foregroundColor(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)))
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 8, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -10, y: -10)
                    )
                    .padding(30)
                    
                    Spacer()
                    
                    // go to signup section
                    
                    HStack {
                        Text("Do not have an account?")
                            .fontWeight(.semibold)
                            .foregroundColor(TextColor)
                        
                        NavigationLink (destination: SignUpView()) {
                            Text("Register").fontWeight(.semibold)
                                .foregroundColor(TextColor)
                        }.buttonStyle(SmallButtonStyle())
                    }.padding(30)
                    .modifier(SectionModifier())
                    
                    Spacer()
                }.background(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)))
                .ignoresSafeArea(.all)
                if showAlert {
                    AlertView(showAlert: $showAlert, alertMessage: $error).transition(.slide)
                }
            }
        }
    }
    
    func signIn() {
        session.signIn(email: email, password: password) { (result, error) in
            if let error = error {
                self.error = error.localizedDescription
                self.showAlert = true
                
            } else {
                self.email = ""
                self.password = ""
            }
        }
        
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
