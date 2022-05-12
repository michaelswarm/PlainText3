//
//  CustomHSplitView.swift
//  Shared
//
//  Created by Michael Swarm on 12/4/20.
//

/*
 Originally from Outline Project.
 Adapt to WriterSwiftUI Project. Made generic.
 Used in PlainText3 for Inspector. Changed to right side.
 */

import SwiftUI

// Custom HSplitView for IOS from HStack. (Avoid nested NavigationView within DocumentGroup.)
// Simple IOS Split View. TBD: Enhancements like adjustable size, hide primary, adapt to screen modes. Assume horizontal.
// Generic View Properties
// Defines generic types SidebarContent and MainContent, which are constrained to be type View.
// Note: Document is no longer required by the split view. The child views with document are created by the app, and passed as parameters, and not created by the split view. (I assume toolbars could also be passed like this.)

enum Side {
    case left, right // leading, trailing?
}

struct CustomHSplitView<SidebarContent: View, MainContent: View>: View {
    var sidebarView: SidebarContent
    var mainView: MainContent
    var side: Side = .right

    @State var showSidebar: Bool = false
    @State var searchText: String = ""
    @EnvironmentObject var appState: AppState
    
    // 260px = 4 tabs
    // 320px = 5 tabs
    // Inspector style sidebar thinner than 320 on Mac. Try 250. Mac Xcode inspector sidebar appears to be 260px.
    // Primary is sidebar.
#if os(OSX)
    let primaryIdealSize: (width: CGFloat, height: CGFloat) = (width: 260.0, height: 640.0) // Wide sidebar takes 2/3 of screen.
#else
    let primaryIdealSize: (width: CGFloat, height: CGFloat) = (width: 320.0, height: 640.0) // Wide sidebar takes 2/3 of screen.
#endif
    let secondaryIdealSize: (width: CGFloat, height: CGFloat ) = (width:640.0, height: 640.0)
    // Primary-Secondary used to adapt between left-right and right-left languages.

    var body: some View {
        HStack(spacing: 0) { // Main layout of split view.
            switch side {
            case .left:
                if showSidebar {
                    sidebarView
                        .frame(minWidth: 0, idealWidth: primaryIdealSize.width, maxWidth: primaryIdealSize.width, minHeight: primaryIdealSize.height/2, idealHeight: primaryIdealSize.height, maxHeight: .infinity)
                    Divider()
                }
                mainView
                    .padding(.top, 1) // Seems to match top padding with leading padding.
                    // .padding(.top, showSidebar ? 10 : 10) // Stop document title bar overlap. Why is this necessary? Why not necessary on primary view (List), but necessary on secondary view (TextEditor)? My custom view has same behavior as NavigationView. (My custom view seems to be working now. Don't know what changed?)
                    // .edgesIgnoringSafeArea(.top) // ???
                    .frame(minWidth: secondaryIdealSize.width/2, idealWidth: secondaryIdealSize.width, maxWidth: .infinity, minHeight: secondaryIdealSize.height/2, idealHeight: secondaryIdealSize.height, maxHeight: .infinity)
            case .right:
                mainView
                    .padding(.top, 1) // Seems to match top padding with leading padding.
                    // .padding(.top, showSidebar ? 10 : 10) // Stop document title bar overlap. Why is this necessary? Why not necessary on primary view (List), but necessary on secondary view (TextEditor)? My custom view has same behavior as NavigationView. (My custom view seems to be working now. Don't know what changed?)
                    // .edgesIgnoringSafeArea(.top) // ???
                    .frame(minWidth: secondaryIdealSize.width/2, idealWidth: secondaryIdealSize.width, maxWidth: .infinity, minHeight: secondaryIdealSize.height/2, idealHeight: secondaryIdealSize.height, maxHeight: .infinity)
                if showSidebar {
                    sidebarView
                        .frame(minWidth: 0, idealWidth: primaryIdealSize.width, maxWidth: primaryIdealSize.width, minHeight: primaryIdealSize.height/2, idealHeight: primaryIdealSize.height, maxHeight: .infinity)
                    Divider()
                }
            }
        } // HStack
        // .searchable(text: $searchText)
        // .accentColor(.accentColor) // What is Color.accentColor vs apply color directly? Does nothing more than asset catalog accent color. 
        // IOS 13 SwiftUI v1
        // .navigationBarItems(leading: leadingTopBar, trailing: TrailingTopBarView(document: $document, exportFileURL: $exportFileURL, showImportPicker: $showImportPicker, showExportPicker: $showExportPicker))
        // IOS 14 SwiftUI v2
        /*.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) { TrailingTopBarView(document: $document, showImportPicker: $showImportPicker, showExportPicker: $showExportPicker, exportFileURL: $exportFileURL) }
        }*/
        // 'navigationBarLeading' is unavailable in macOS
        // SwiftUI v3 supports platform conditional modifiers for postfix member expressions and modifiers.
        #if os(iOS)
        .toolbar {
            ToolbarItem(placement: side == .left ? .navigationBarLeading : .navigationBarTrailing ) { 
                leadingTopBar
            }
        }
        #endif
        #if os(OSX)
        // Toolbar MacOS Monterey very tall!
        .toolbar {
            ToolbarItem(placement: side == .right ? .automatic : .navigation) { // .automatic (Mac right), .primaryAction (Mac right), .principal (Mac middle), .navigation (Mac left)
                leadingTopBar
            }
        }
        #endif
    }
    
    // Keep navigation toolbar code clean.
    var leadingTopBar: some View {
        Button(action: { showSidebar.toggle() } ) {
            Image(systemName: "sidebar.left").font(.system(size: 26.0))
        }
        .help("Sidebar") // New SwiftUI 3: Mac Tool Tip and Accessibility (Just button?)
        .padding(.leading) // Because of back arrow, sidebar symbol is not first button. Need some padding between back arrow and sidebar symbol. No need for trailing.
    }
}
