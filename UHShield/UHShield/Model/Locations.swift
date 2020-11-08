//
//  Locations.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/11/7.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Locations: Codable, Identifiable, Hashable {
    
    @DocumentID var id: String? = UUID().uuidString
    var roomID: String?
    var building: Date?
    
    enum CodingKeys: String, CodingKey{
        
        case id
        case roomID
        case building
    }
}

