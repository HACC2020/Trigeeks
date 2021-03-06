//
//  BadgeViewModel.swift
//  UHShield
//
//  Created by Tianhui Zhou on 10/31/20.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class BadgeViewModel: ObservableObject {
    
    @Published var badges = [Badge]()
    
    private var db = Firestore.firestore()
    
    //fetching data for all badge
    func fetchData() {
        db.collection("Badges").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.badges = documents.compactMap { (queryDocumentSnapshot) -> Badge? in
                return try? queryDocumentSnapshot.data(as: Badge.self)
                
            }
            print(self.badges)
            print("Done for fetching profile data")
            
        }
    }
    
    //updating information for a badge
    func updateBadge(badge: Badge) {
        do {
            try db.collection("Badges").document(badge.id!).setData(from: badge, merge: true)
        } catch {
            print(error)
        }
    }
    
    //deleting a badge from processing list
    func deleteBadge(badge: Badge){
        db.collection("Badges").document(badge.id!).delete{ (error) in
            if error != nil {
                print("Error! cannot delete the badge")
            } else {
                print("Successfully delete!")
            }
        }
    }
    
    func addBadge(badge: Badge) {
        do {
            let _ = try db.collection("Badges").document(badge.id!).setData(from: badge)
        } catch {
            print(error)
        }
    }
}
