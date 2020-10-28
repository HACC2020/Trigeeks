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
    @State var checkMarkSize: CGFloat = 0
    @State var checkMarkRotation: Double = 100
    @Binding var isShowScanner: Bool
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    CodeScannerView(codeTypes: [.qr], simulatedData: "ABC\nabc", completion: handleScan)
                }.navigationBarItems(leading:Button(action: {
                    isShowScanner = false
                }, label: {
                    
                    Image(systemName: "chevron.backward").font(.system(size: 30)).foregroundColor(.black)
                }))
                
                Rectangle().fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.5), Color.white.opacity(0.1)]), startPoint: .bottom, endPoint: .top)).frame(height: 20)
                    .offset(y: scanerLineOffset)
                
                Circle().fill(Color.green).frame(width: circleSize)
                Image(systemName: "checkmark").foregroundColor(.white).font(.system(size: checkMarkSize, weight: .bold)).rotationEffect(Angle(degrees: checkMarkRotation))

            }.onAppear {
                Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                    self.scanerLineOffset = -UIScreen.main.bounds.height/3
                    withAnimation(.linear(duration: 1.8)) {
                        self.scanerLineOffset = UIScreen.main.bounds.height/5
                    }
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
                }
                withAnimation(.linear(duration: 0.3)) {
                    self.checkMarkSize = 60
                    self.checkMarkRotation = 0
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                isShowScanner = false
            })
            let details = code.components(separatedBy: "\n")
            print(details[0])
            print(details[1])
        case .failure(let error):
            print(error)
            isShowScanner = false
        }
    }
}

struct ScannerLayoutView_Previews: PreviewProvider {
    static var previews: some View {
        ScannerLayoutView(isShowScanner: .constant(true))
    }
}
