//
//  Locations.swift
//  UHShield
//
//  Created by Yuhan Jiang on 2020/11/7.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Building: Codable, Identifiable, Hashable {
    
    @DocumentID var id: String? = UUID().uuidString
    var rooms: [String]
    var building: String
    
    enum CodingKeys: String, CodingKey{
        
        case id
        case rooms
        case building
    }
}

