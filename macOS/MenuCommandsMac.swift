//
//  MenuCommandsMac.swift
//  PlainText3
//
//  Created by Michael Swarm on 08/03/22.
//

//  May want different menu commands Mac and IOS.
//  For example, Mac TextEditor-NSTextView supports TextEditingCommands, which IOS does not.

//  Possible to remove default menu commands? De-clutter? Much distraction in window and view management. Help has been replaced by Internet. Even file is redundant. (Handled at system level.) Only edit menu is specific to text editor. 

import SwiftUI

struct MenuCommandsMac: Commands {
    @ObservedObject var main: MainModel
    @FocusedValue(\.document) var focusedDocument // 4. Focused value-focused scene value bug. If in app file, causes debug layout errors and drawing issuses. If in menu commands file ok.
    @ObservedObject var appState: AppState // Is environment available to command menus?

    var body: some Commands {
        TextEditingCommands() // What does this do? Includes Find, Spelling and Grammar, Substitutions, Transformations and Speech. Find uses the standard NSTextView toolbar (top), with search, arrows, done and replace. Highlight annimates from yellow to blue (blue if active, gray if inactive). (Normal selection highlight is blue?) Replace removes done, adds replace toolbar, with replace, replace, all and done. Spelling opens spelling and grammar panel. Substitutions are dashes and quotes. Transformations are upper and lower case. Speech is text to voice (reads text). Surprised that SwiftUI TextEditor has these. Shows underlying NSTextView. Different experience Mac to IOS.
        CommandGroup(replacing: .printItem) {
            Divider()
            Button("Print...", action: {
                print("Print...")
                // Now require document from focused value above, to execute document.printMac().
                // Printing Not Allowed. This application is not allowed to print. Contact your application vendor for an update. Enable Signing and Capabilities - App Sandbox - Printing.
                focusedDocument?.wrappedValue.printMac() // focusedDocument is binding. Can access properties directly, but not methods. Need to get wrappedValue to use methods.
            } )
                .keyboardShortcut("P") // Shows up as <CMD><P>. How to ctrl or option?
        }
        CommandGroup(before: .textEditing) { // Shows up in View menu.
            Divider()
            Button("Test", action: { print("Test Keyboard Shortcut...") })
                .keyboardShortcut("[") // Shows up as <CMD><[>. How to ctrl or option?
            Divider()
        }
        
        // EXPERIMENT
        CommandGroup(after: .help) {
            Divider()
            Button("Vocabulary", action: {
                print("Show vocabulary...")
                appState.showVocabulary.toggle()
            })
        }

    }
}
