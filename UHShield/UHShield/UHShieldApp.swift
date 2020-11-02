//
//  UHShieldApp.swift
//  UHShield
//
//  Created by weirong he on 10/27/20.
//

import SwiftUI
import Firebase

@main
struct UHShieldApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(SessionStore()).environmentObject(EventViewModel())
        }
    }
}


class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
