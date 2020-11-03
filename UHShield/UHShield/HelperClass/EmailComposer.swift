//
//  EmailComposer.swift
//  UHShield
//
//  Created by weirong he on 11/1/20.
//

import Foundation
import SwiftUI
import MessageUI

public struct EmailComposer: UIViewControllerRepresentable {
    
    @Binding var result: Result<MFMailComposeResult, Error>?
    @Binding var isShowing: Bool
    
    let eventName: String
    var guest: Guest
    let location: Location
    let sponsor: String
    let startTime: Date
    let endTime: Date
    let qrCode: UIImage
    
    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(isShowing: Binding<Bool>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _isShowing = isShowing
            _result = result
        }
        
        public func mailComposeController(_ controller: MFMailComposeViewController,
                                          didFinishWith result: MFMailComposeResult,
                                          error: Error?) {
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        return Coordinator(isShowing: $isShowing, result: $result)
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<EmailComposer>) -> MFMailComposeViewController {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let vc = MFMailComposeViewController()
        
        print("\(guest)")
        print("\(guest.email)")
        print("\(guest.name)")
        
        vc.setSubject(eventName)
        vc.setToRecipients([guest.email])
//        vc.setMessageBody("Aloha \(guest.name)!\nThis is an invatation of \(eventName).\nLocation: \(location.building) \(location.roomID)\nTime: \(formatter.string(from: startTime)). Please come in time. Mahalo!\n\(sponsor)", isHTML: true)
        vc.setMessageBody("<h1>Invitation</h1><p>Aloha \(guest.name)!</p><p>This is an invatation of \(eventName)</p><p>Location: \(location.building) \(location.roomID)</p><p>Time: \(formatter.string(from: startTime)) </p><p>The attachment below is your identity authentication QR-Code, please show it to the reception.</p><p>Mahalo!</p><p>\(sponsor)</p>", isHTML: true)
        vc.addAttachmentData(qrCode.pngData()!, mimeType: "image/png", fileName: "imageName.png")
        vc.mailComposeDelegate = context.coordinator
        
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                       context: UIViewControllerRepresentableContext<EmailComposer>) {
        
    }
}