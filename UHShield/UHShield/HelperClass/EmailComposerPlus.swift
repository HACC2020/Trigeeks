//
//  EmailComposerGroup.swift
//  UHShield
//
//  Created by Tianhui Zhou on 11/8/20.
//

import Foundation
import SwiftUI
import MessageUI

public struct EmailComposerPlus: UIViewControllerRepresentable {
    
    @Binding var result: Result<MFMailComposeResult, Error>?
    @Binding var isShowing: Bool
    @Binding var outvalue: Int
    let eventName: String
    var guests: [Guest]
    let location: Location
    let sponsor: String
    let startTime: Date
    let endTime: Date
    
    
    public class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var isShowing: Bool
        @Binding var result: Result<MFMailComposeResult, Error>?
        @Binding var outvalue: Int
        
        init(isShowing: Binding<Bool>,
             result: Binding<Result<MFMailComposeResult, Error>?>, outvalue: Binding<Int>) {
            _isShowing = isShowing
            _result = result
            _outvalue = outvalue
        }
        
        public func mailComposeController(_ controller: MFMailComposeViewController,
                                          didFinishWith result: MFMailComposeResult,
                                          error: Error?) {
            print("there is a test from Bobby for email result 111: \(result)")
            defer {
                isShowing = false
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
            switch result {
            case .cancelled:
                print("Oh you cancel it!")
                outvalue = 1
            case .sent:
                print("Oh you send it!")
                outvalue = 2
            default:
                print("error")
            }
            
        }
        
    }
    
    public func makeCoordinator() -> Coordinator {
        
        return Coordinator(isShowing: $isShowing, result: $result, outvalue: $outvalue)
    }
    
    public func makeUIViewController(context: UIViewControllerRepresentableContext<EmailComposerPlus>) -> MFMailComposeViewController {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let vc = MFMailComposeViewController()
        var tempArr: [String] = []
        for eachGuest in guests {
            tempArr.append(eachGuest.email!)
        }
        vc.setSubject(eventName)
        vc.setToRecipients(tempArr)
//        vc.setMessageBody("Aloha \(guest.name)!\nThis is an invatation of \(eventName).\nLocation: \(location.building) \(location.roomID)\nTime: \(formatter.string(from: startTime)). Please come in time. Mahalo!\n\(sponsor)", isHTML: true)
        vc.setMessageBody("<h1>Update</h1><p>Aloha!</p><p>This is an update notification of \(eventName)</p><p>Location: \(location.building) \(location.roomID)</p><p>Time: \(formatter.string(from: startTime)) </p><p>Your QR-Code that is received from last email is still available for attending this event, please show it to the reception.</p><p>Mahalo!</p><p>\(sponsor)</p>", isHTML: true)
        
        vc.mailComposeDelegate = context.coordinator
        
        return vc
    }
    
    public func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                       context: UIViewControllerRepresentableContext<EmailComposerPlus>) {
        //print("there is a test from Bobby for email result: \(result)")
    }
}
