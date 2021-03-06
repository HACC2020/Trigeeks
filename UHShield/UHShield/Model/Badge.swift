//
//  Badge.swift
//  UHShield
//
//  Created by Tianhui Zhou on 10/31/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Badge: Codable, Identifiable, Hashable {
    
    @DocumentID var id: String? = UUID().uuidString
    var guestID: String?
    var assignedTime: Date?
    var badgeID: String?
    var building: String?
    
    enum CodingKeys: String, CodingKey{
        
        case id
        case guestID
        case assignedTime
        case badgeID
        case building
    }
}


