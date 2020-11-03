//
//  Profile.swift
//  UHShield
//
//  Created by Tianhui Zhou on 11/3/20.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Profile: Codable, Identifiable, Hashable{
    
    @DocumentID var id: String? = UUID().uuidString
    var email: String
    var firstName: String
    var lastName: String
    var role: String
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case email
        case firstName
        case lastName
        case role
    }
}
