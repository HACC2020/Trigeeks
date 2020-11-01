//
//  AlertView.swift
//  UHShield
//
//  Created by weirong he on 10/28/20.
//

import SwiftUI

struct AlertView: View {
    @Binding var showAlert: Bool
    @Binding var alertMessage: String
    var body: some View {
        VStack {
            VStack {
                
                // title of alert
                HStack {
                    Text("ERROR").font(.title).bold().foregroundColor(Color.red.opacity(0.7))
                    Spacer()
                }.padding(.horizontal, 25)
                
                // error message
                Text(self.alertMessage).foregroundColor(Color.black.opacity(0.7)).padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 120)
                
                // confirm button
                Button(action: {
                    self.showAlert.toggle()
                }) {
                    Text("OK").padding(.vertical).frame(width: UIScreen.main.bounds.width - 120).foregroundColor(Color.white)
                    }.background(Color("bg1")).cornerRadius(20)
                }.padding().background(Color.white).cornerRadius(20)
            .animation(.interpolatingSpring(mass: 1, stiffness: 90, damping: 10, initialVelocity: 0))
            
        } // gray background with opacity
        .padding()
        .frame(maxHeight: .infinity)
        .background(Color.black.opacity(0.2))
        .edgesIgnoringSafeArea(.all)
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(showAlert: .constant(true), alertMessage: .constant("This is wrong"))
    }
}
