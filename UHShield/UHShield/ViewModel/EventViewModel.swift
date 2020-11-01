//
//  EventViewModel.swift
//  UHShield
//
//  Created by weirong he on 10/31/20.
//

import Foundation
import FirebaseFirestore

class EventViewModel: ObservableObject {
    
    @Published var events = [Event]()
    
    private var db = Firestore.firestore()
    
    func fetchData() {
        db.collection("events")
            .addSnapshotListener {
                (querySnapshot, error) in
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                
                self.events = documents.compactMap { (queryDocumentSnapshot) -> Event? in
                    return try? queryDocumentSnapshot.data(as: Event.self)
                }
                print(self.events)
                print("Done for fetching data")
            }
    }
    
    func addEvent(event: Event) {
        do {
            let _ = try db.collection("events").document(event.id!).setData(from: event)
        } catch {
            print(error)
        }
    }
    
    func updateEvent(event: Event) {
        do {
            try db.collection("events").document(event.id!).setData(from: event, merge: true)
        } catch {
            print(error)
        }
    }
}
