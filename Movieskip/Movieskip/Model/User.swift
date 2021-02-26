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
    let username: String
    var watchlist: [Movie]
    var excluded: [Movie]
    var skipped: [Movie]
    var friends: [User]
    var profileImage: String?

    var watchListCount: Int {
        return watchlist.count
    }
    var excludedCount: Int {
        return excluded.count
    }
    
}
