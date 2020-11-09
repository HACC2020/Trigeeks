//
//  LocationsViewModel.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/11/7.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class BuildingViewModel: ObservableObject {
    
    @Published var buildings = [Building]()
    
    private var db = Firestore.firestore()
    
    //fetching data for all badge
    func fetchData() {
        db.collection("Buildings").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            self.buildings = documents.compactMap { (queryDocumentSnapshot) -> Building? in
                return try? queryDocumentSnapshot.data(as: Building.self)
                
            }
            print(self.buildings)
            print("Done for fetching building data")
            
        }
    }
    
}
