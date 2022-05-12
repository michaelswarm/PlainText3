//
//  InspectorTabView.swift
//  PlainText3
//
//  Created by Michael Swarm on 08/03/22.
//

//  TabView issues with >6 tabs. Actually space issues with >4 tabs with Mac inspector sidebar size.
//  No tab icons?
//  Better custom view with segmented control (top) and content view (bottom). Then can use small images in segmented control?
//  Other option is allow wider inspector sidebar.
//  Good for quick prototype. Maybe ok for IOS. Need custom tab bar for small tabs (like Xcode navigation tabs.) 

import SwiftUI

struct InspectorTabView: View {
    @Binding var document: PlainText3Document
    
    var body: some View {
        TabView {
            TextCountView(document: $document)
                .tabItem {
                    Label("Counts", systemImage: "person")
                        // .labelStyle(.titleAndIcon) // Icon not shown??? There is a person symbol???
                }
            // Not enough room to display on Mac.
            SectionListView(document: $document)
                .tabItem {
                    Label("Sections", systemImage: "person")
                        // .labelStyle(.iconOnly) // Icon not shown???
                }
            HeadingListView(document: $document)
                .tabItem {
                    Label("Headings", systemImage: "person")
                }
            // SentenceListView NOT USED.
            SentenceTagsListView(document: $document) // Was SentenceList ok. Now SentenceTagList.
                .tabItem {
                    Label("Sentences", systemImage: "person")
                }
            WordListView(document: $document)
                .tabItem {
                    Label("Words", systemImage: "person")
                }
            LineListView(document: $document)
                .tabItem {
                    Label("Lines", systemImage: "person")
                }
        }
        .tabViewStyle(.automatic) // Only automatic is available (on Mac)???
        .accentColor(.accentColor) // Not sure what this does, if anything. At least nothing on Mac.
    }
}

struct InspectorTabView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            InspectorTabView(document: .constant(PlainText3Document(text: "Hello World!")))
.previewInterfaceOrientation(.portraitUpsideDown)
        }
    }
}
