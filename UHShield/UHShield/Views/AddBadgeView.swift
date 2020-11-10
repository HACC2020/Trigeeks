//
//  AddBadgeView.swift
//  UHShield
//
//  Created by weirong he on 11/2/20.
//

import SwiftUI

struct AddBadgeView: View {
    
    @StateObject var badgeViewModel = BadgeViewModel()
    @Binding var isShowAddBadge: Bool
    let guestName: String
    let guestEmail: String
    
    @State var badgeID = ""
    @State var isShowAlert = false
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Text("Update Badge").fontWeight(.bold).font(.largeTitle).foregroundColor(Color("bg1"))
                    Spacer()
                    Button(action: {isShowAddBadge = false}, label: {
                        Image(systemName: "xmark.circle").font(.title)
                    })
                }.padding()
                // present guest information for convienent
                VStack {
                    HStack {
                        Text("Guest Information").fontWeight(.bold).font(.title)
                        Spacer()
                    }.padding()
                    HStack {
                        Text("Name:").frame(width: 90, alignment: .leading)
                        Text("\(guestName)").font(.headline)
                        Spacer()
                    }
                    HStack {
                        Text("Email:").frame(width: 90, alignment: .leading)
                        Text("\(guestEmail)").font(.headline)
                        Spacer()
                    }
                   
                }.padding()
                .background(
                    RoundedRectangle(cornerRadius: 25).foregroundColor(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)))
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 4, y: 5)
                        .shadow(color: Color.white.opacity(0.4), radius: 5, x: -5, y: -5)
                ).padding(30)
                
                VStack {

                    VStack(alignment: .leading) {
                        Text("Badge ID")
                            .fontWeight(.semibold)
                            .font(.title)
                            .foregroundColor(Color("bg1"))
                        
                        TextField("Enter Badge ID on the Card", text: $badgeID)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .modifier(TextFieldModifier())
                        
                        Button(action: { handleUpdateButton() }, label: {
                            Text("Update").font(.title2).fontWeight(.bold).foregroundColor(.white)
                        }).buttonStyle(LongButtonStyle()).padding()
                    }.padding()
                }
                
                Spacer()
            }.frame(maxWidth: .infinity ,maxHeight: .infinity)
            .background(Color(#colorLiteral(red: 0.8864660859, green: 0.8863860965, blue: 0.9189570546, alpha: 1)).ignoresSafeArea())
            .onAppear {
                badgeViewModel.fetchData()
            }
            
            if isShowAlert {
                AlertView(showAlert: $isShowAlert, alertMessage: .constant("Badge ID cannot be empty!"), alertTitle: "ERROR").transition(.slide)
            }
        }
    }
    
    func handleUpdateButton() {
        if badgeID == "" {
            withAnimation {
                isShowAlert = true
            }
        } else {
            badgeViewModel.addBadge(badge: Badge(guestID: "\(guestEmail)", assignedTime: Date(), badgeID: badgeID))
            isShowAddBadge = false
        }
    }
}

struct AddBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        AddBadgeView(isShowAddBadge: .constant(true), guestName: "John", guestEmail: "john@hawaii.edu")
    }
}
