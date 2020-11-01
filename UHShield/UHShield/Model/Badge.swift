//
//  Badge.swift
//  UHShield
//
//  Created by Tianhui Zhou on 10/31/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseFirestore
struct Badge: Codable, Identifiable, Hashable {
    
    @DocumentID var id: String? = UUID().uuidString
    var guestID: String
    var assignedTime: String
    var isAvailable: Bool
    
    enum CodingKeys: String, CodingKey{
        
        case id
        case guestID
        case assignedTime
        case isAvailable
        
    }
}


