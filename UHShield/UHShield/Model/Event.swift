//
//  Event.swift
//  UHShield
//
//  Created by weirong he on 10/31/20.
//

import Foundation
import FirebaseFirestoreSwift

struct Event: Codable, Identifiable, Hashable {

    @DocumentID var id: String? = UUID().uuidString
    var eventName: String?
    var sponsor: String?
    var guests: [Guest]?
    var arrivedGuests: [String]?
    var location: Location?
    var startTime: Date?
    var endTime: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case eventName
        case sponsor
        case guests
        case arrivedGuests
        case location
        case startTime
        case endTime
    }
    
}

struct Location: Codable, Hashable {
    var building: String
    var roomID: String
}

struct Guest: Codable, Hashable {
    var name: String?
    var email: String?
}
