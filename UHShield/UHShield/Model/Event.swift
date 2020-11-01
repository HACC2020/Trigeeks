//
//  Event.swift
//  UHShield
//
//  Created by weirong he on 10/31/20.
//

import Foundation
import FirebaseFirestoreSwift

struct Event: Codable, Identifiable {

    @DocumentID var id: String? = UUID().uuidString
    var sponsor: String
    var guests: [String]
    var arrivedGuests: [String]
    var location: Location
    var date: Date
    var startTime: Date
    var endTime: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case sponsor
        case guests
        case arrivedGuests
        case location
        case date
        case startTime
        case endTime
    }
    
}

struct Location: Codable {
    var building: String
    var roomID: String
}
