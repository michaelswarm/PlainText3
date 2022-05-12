//
//  PlainText3App.swift
//  Shared
//
//  Created by Michael Swarm on 06/03/22.
//

//  Clean Document Based App
//  1. DocumentGroup scene with new document.
//  2. Document value binding (content model and storage) passed to ContentView.
//  3. Main model shared object passed to commands (menus) and set in environment (views).
//  4. Focused value-focused scene value bug. If in app file, causes debug layout errors and drawing issuses. If in menu commands file ok. Maybe some interaction with model passed as value or set in environment too. 

import SwiftUI

// AppState and MainModel do essentially the same thing. Both set environment. Why is one plain var, and other @StateObject?

@main
struct PlainText3App: App {
    var appState = AppState()
    @StateObject var mainModel = MainModel() // 3.
    // @FocusedValue(\.document) var focusedDocument // 4. Focused value-focused scene value bug. If in app file, causes debug layout errors and drawing issuses. If in menu commands file ok.
    
    var body: some Scene {
        DocumentGroup(newDocument: PlainText3Document()) { file in // 1.
#if os(OSX)
            CustomHSplitView(sidebarView: InspectorTabView(document: file.$document), mainView: ContentViewMac(document: file.$document))
                .environmentObject(mainModel) // 3.
                .environmentObject(appState)

#elseif os(iOS)
            CustomHSplitView(sidebarView: InspectorTabView(document: file.$document), mainView: ContentViewIOS(document: file.$document))
                .environmentObject(mainModel) // 3.
                .environmentObject(appState)
#endif

            // ContentViewMac(document: file.$document) // 2. Might also pass file here.
            // .focusedSceneValue(\.document, file.$document) // 4.
        }
        
        .commands {
#if os(OSX)
            MenuCommandsMac(main: mainModel, appState: appState) // 3.
#elseif os(iOS)
            MenuCommandsIOS(main: mainModel) // 3.
#endif
        }
    }
}
