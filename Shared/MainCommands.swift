//
//  MainCommands.swift
//  PlainText3
//
//  Created by Michael Swarm on 07/03/22.
//

//  May want different menu commands Mac and IOS.
//  For example, Mac TextEditor-NSTextView supports TextEditingCommands, which IOS does not. 

import SwiftUI

struct MainCommands: Commands { // MenuCommands???
    @ObservedObject var main: MainModel
    
    var body: some Commands {
        CommandGroup(before: .sidebar) { // Shows up in View menu.
            Button("Test", action: { print("Test Keyboard Shortcut...") })
                .keyboardShortcut("[") // Shows up as <CMD><[>. How to ctrl or option?
        }
        CommandGroup(after: .textEditing) {
            Button("Find", action: {
                print("Find...")
                main.showFindReplace = true
                // filterAction?()
            })
                .keyboardShortcut("F") // Shows up as <CMD><[>. How to ctrl or option?
        }
    }
}
