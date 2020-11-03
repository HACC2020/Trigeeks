//
//  ProfileViewModel.swift
//  UHShield
//
//  Created by Tianhui Zhou on 11/3/20.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProfileViewModel: ObservableObject {
    
    @Published var profiles = [Profile]()
    
    private var db = Firestore.firestore()
    
    // load profiles from firebase
    func fetchData() {
        db.collection("Profiles").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.profiles = documents.compactMap { (queryDocumentSnapshot) -> Profile? in
                return try? queryDocumentSnapshot.data(as: Profile.self)
                
            }
            print(self.profiles)
            print("Done for fetching profile data")
        }
    }
    
    // update profile when users use EditProfile View
    func updateProfile(profile: Profile) {
        do {
            try db.collection("profiles").document(profile.email).setData(from: profile, merge: true)
        } catch {
            print(error)
        }
    }
}
