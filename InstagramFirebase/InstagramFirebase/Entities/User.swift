//
//  User.swift
//  InstagramFirebase
//
//  Created by Ardak on 17.02.2022.
//

import Foundation

struct User {
    let user: String
    let profileUserUrl: String

    init(_ dictionary: [String: Any]) {
        self.user = dictionary["username"] as? String ?? ""
        self.profileUserUrl = dictionary["profileURL"] as? String ?? ""
    }
}
