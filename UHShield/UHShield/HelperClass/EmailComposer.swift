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
    let guests: [String]
    let location: Location
    let sponsor: String
    let startTime: Date
    let endTime: Date
    
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
        
        vc.setSubject(eventName)
        vc.setToRecipients(guests)
        vc.setMessageBody("Aloha!\nThis is an invatation of \(eventName).\nLocation: \(location.building) \(location.roomID)\nTime: \(formatter.string(from: startTime)). Please come in time. Mahalo!\n\(sponsor)", isHTML: false)
        vc.mailComposeDelegate = context.coordinator
        
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                       context: UIViewControllerRepresentableContext<EmailComposer>) {
        
    }
}
