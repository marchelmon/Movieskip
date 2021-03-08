//
//  User.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-13.
//

import Foundation

struct User {
    let uid: String
    let email: String
    var username: String
    var watchlist: [Int]
    var excluded: [Int]
    var skipped: [Int]
    var friends: [User]
    var profileImage: String?

    var watchListCount: Int {
        return watchlist.count
    }
    var excludedCount: Int {
        return excluded.count
    }
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.profileImage = dictionary["image"] as? String ?? nil
        self.watchlist = dictionary["watchlist"] as? [Int] ?? []
        self.excluded = dictionary["excluded"] as? [Int] ?? []
        self.skipped = dictionary["skipped"] as? [Int] ?? []
        self.friends = dictionary["friends"] as? [User] ?? []
    }
    
    var dictionary: [String: Any] {
        let list = [
            "uid": uid,
            "email": email,
            "username": username,
            "watchlist": watchlist,
            "excluded": excluded,
            "skipped": skipped,
            "friends": friends,
            "profileImage": profileImage ?? ""
        ] as [String : Any]
        return list
    }
    
}
