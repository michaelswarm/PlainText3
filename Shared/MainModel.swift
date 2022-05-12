//
//  MainModel.swift
//  PlainText3
//
//  Created by Michael Swarm on 06/03/22.
//

//  Session State
//  Permantent state like Preferences stored in user defaults by @AppStorage.
//  Separate from Content Model-Document Storage.

import Foundation

class MainModel: ObservableObject {
    // Shared app state here...
    
    // Command Menu State
    @Published var showFindReplace: Bool = false
    
    // Multi Document State (NOT USED)
    // Depends of document id. 
    @Published var ids = Set<String>()
    var array: [String] {
        Array(ids)
    }
    @Published var key: String?
}
