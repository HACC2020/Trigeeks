//
//  LocationsViewModel.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/11/7.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class LocationsViewModel: ObservableObject {
    
    @Published var location = [Locations]()
    
    private var db = Firestore.firestore()
    
    //fetching data for all badge
    func fetchData() {
        db.collection("Locations").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.location = documents.compactMap { (queryDocumentSnapshot) -> Locations? in
                return try? queryDocumentSnapshot.data(as: Locations.self)
                
            }
            print(self.location)
            print("Done for fetching location data")
            
        }
    }
    
}
