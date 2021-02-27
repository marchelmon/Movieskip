//
//  SettingsViewModel.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-26.
//

import Foundation

struct SettingsViewModel {
    
    //MARK: - Properties
    
    let user: User
    
    
    //MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
    }
    
}
