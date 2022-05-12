//
//  ContentViewIOS.swift
//  PlainText3 (iOS)
//
//  Created by Michael Swarm on 17/03/22.
//

import SwiftUI

struct ContentViewIOS: View {
    @Binding var document: PlainText3Document
    // @ObservedObject var main: MainModel
    @EnvironmentObject var main: MainModel
    @Environment(\.dynamicTypeSize) var dynamicTypeSize // (xSmall, small, medium, large, xLarge, xxLarge, xxxLarge) Not available MacOS and does nothing.
    // What other goodies are hiding in environment???
    
    /*
     .scenePhase
     .locale
     .lineLimit
     .backgroundMaterial: Material?
     */
    
    // @State var showFindReplace: Bool = false
    
    /* @Environment(\.controlActiveState) var controlActiveState // (.key, .active, .inactive) // 'controlActiveState' is unavailable in iOS.
    var state: String {
        switch controlActiveState {
        case .key:
            return ".key"
        case .active:
            return ".active"
        case .inactive:
            return ".inactive"
        default:
            return "unknown"
        }
    } */
    
    var body: some View {
        VStack {
            // if !main.showFindReplace || controlActiveState != .key {
            if !main.showFindReplace {
                TextEditor(text: $document.text)
                /*.focusedSceneValue(\.filterAction) { // MAGIC HERE!!! (THIS WORKED FOR A MINUTE. THEN IT BROKE.)
                 showFindReplace = true
                 }*/
                ContentStatusView(document: $document)
                // MultipleDocumentView(main: main)
            } else {
                VStack {
                    GroupBox { // Better than background rounded rectangle and color (platform semantic).
                        Text("TBD...").foregroundStyle(.quaternary) // Better than foregroundColor (platform semantic).
                        GroupBox {
                            Button {
                                main.showFindReplace = false
                            } label: {
                                Text("Done")
                            }
                        }
                        // Text(dynamicTypeSize)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity) // Better than spacers.
            }
            // Text(state)
        }
        .font(.body)
        
        .onAppear {
            main.ids.insert(document.id)
            /* switch controlActiveState {
            case .key:
                main.key = document.id
            default:
                return
            } */
        }
        .onDisappear {
            if main.key == document.id {
                main.key = nil
            }
            main.ids.remove(document.id)
        }
        /* .onChange(of: controlActiveState) { newValue in
            if newValue == .key {
                main.key = document.id
            }
        } */
    }
}

/*struct ContentView_Previews: PreviewProvider {
 static var previews: some View {
 ContentView(document: .constant(PlainText3Document()))
 }
 }*/
