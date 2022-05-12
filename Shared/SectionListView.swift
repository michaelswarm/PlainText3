//
//  SectionListView.swift
//  PlainText3
//
//  Created by Michael Swarm on 10/03/22.
//

//  GroupBox uses too much space on IOS. (Doubles the border-padding.) Check if same case on Mac??? 

import SwiftUI

struct SectionListView: View {
    @Binding var document: PlainText3Document

    var body: some View {
        // GroupBox {
            List {
                ForEach(document.sections.indices, id: \.self) { index in
                    HStack {
                        // Text("\(index), len: \(document.sections[index].count): ") // Test to find and remove empty sections.
                        Text("\(index): ")
                        Text("\(document.sections[index])")
                    }
                }
                .onDelete { atIndexSet in
                    document.remove(atOffsets: atIndexSet)
                }
                .onMove { fromIndexSet, toInt in // onMove is ForEach modifier. Separate ForEach from List.
                    document.move(fromOffsets: fromIndexSet, toOffsets: toInt)
                }
            }
            #if os(OSX)
            .listStyle(.bordered(alternatesRowBackgrounds: true)) // 'bordered(alternatesRowBackgrounds:)' is unavailable in iOS. 
            #endif
            // .environment(\.editMode, .constant(.active)) // Use this to keep editable always. // editMode unavailable in macOS.
        }
     // }
}

struct SectionListView_Previews: PreviewProvider {
    static var previews: some View {
        SectionListView(document: .constant(PlainText3Document(text: "Hello World!")))
    }
}
