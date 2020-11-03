//
//  ScannerLayoutView.swift
//  UHShield
//
//  Created by weirong he on 10/27/20.
//

import SwiftUI

struct ScannerLayoutView: View {
    @State var scanerLineOffset: CGFloat = 0
    @State var circleSize: CGFloat = 0
    @State var checkMarkSize: CGFloat = 0.1
    @State var checkMarkOpacity: Double = 0.01
    @State var checkMarkRotation: Double = 100
    @State var codeDetails: [String] = []
    @State var isShowCheckInView = false
    @Binding var selection: Int
    var body: some View {

            ZStack {
                VStack {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "Test\nJohn\nPOST\n101\n2020-11-03 02:39:18 +0000\n2020-11-03 02:39:18 +0000\nWeir\nheweiron@hawaii.edu", completion: handleScan)
                }
                
                VStack {
                    HStack {
                        Button(action: {
                            selection = 10
                        }, label: {
                            HStack {
                                Image(systemName: "chevron.backward")
                                Text("Back")
                            }.font(.system(size: 20))
                            
                    })
                        Spacer()
                    }.padding()
                    
                    Spacer()
                }
                // scanning lines with animation
                Rectangle().fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.white.opacity(0.1)]), startPoint: .bottom, endPoint: .top)).frame(height: 20)
                    .offset(y:  -UIScreen.main.bounds.height/4)
                    .offset(y: scanerLineOffset)
                
                // success image with animation
                Circle().fill(Color.green).frame(width: circleSize)
                Image(systemName: "checkmark").foregroundColor(Color.white.opacity(checkMarkOpacity)).font(.system(size: checkMarkSize, weight: .bold)).rotationEffect(Angle(degrees: checkMarkRotation))

                if isShowCheckInView {
                    CheckInView(details: codeDetails, isShowCheckInView: $isShowCheckInView).onDisappear {selection = 10}
                }
            }.onAppear {
                Timer.scheduledTimer(withTimeInterval: 1.8, repeats: true) { _ in
                    self.scanerLineOffset = 0
                    withAnimation(.linear(duration: 1.8)) {
                        self.scanerLineOffset = UIScreen.main.bounds.height/2
                    }
                }
                
                
            }
        }

    
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {

        
        switch result {
        case .success(let code):
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                
                withAnimation(.linear(duration: 0.1)) {
                    self.circleSize = 100
                    self.checkMarkOpacity = 1
                }
                withAnimation(.linear(duration: 0.3)) {
                    self.checkMarkSize = 60
                    self.checkMarkRotation = 0
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                // change to guest information View
                isShowCheckInView = true
            })
            let details = code.components(separatedBy: "\n")
            codeDetails = details
            
            print(details[0])
            print(details[1])
        case .failure(let error):
            print(error)
            selection = 10
        }
    }
}

struct ScannerLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerLayoutView( selection: .constant(11))
    }
}
