//
//  HeadingListView.swift
//  PlainText3
//
//  Created by Michael Swarm on 11/03/22.
//

//  GroupBox uses too much space on IOS. (Doubles the border-padding.) Check if same case on Mac???
//  IOS EditMode is inactive by default.
//  IOS EditMode active shows both delete and move controls.
//  IOS EditButton does not work unless embedded in NavigationView.
//  NavigationView can't be embedded inside TabView. (Shows empty view with back button.)
//  TBD: No good solutions for edit mode on IOS, so far. (Issues with custom button.)

import SwiftUI

struct HeadingListView: View {
    @Binding var document: PlainText3Document

#if os(iOS)
    // Edit mode is always active for Mac.
    @State var isEditMode: EditMode = .inactive // 'EditMode' is unavailable in macOS. Get only property.
#endif

    var body: some View {
        // NavigationView { // Does not really work inside TabView (IOS).
        // VStack {
            List {
/*
#if os(iOS)
                HStack {
                    Spacer()
                    // EditButton() // Does not toggle EditMode! (Requirement to be embedded in NavigationView?)
                    switch isEditMode {
                    case .inactive:
                        Button("Edit") { isEditMode = .active } // Still need to change to done.
                    case .transient:
                        Text("")
                    case .active:
                        Button("Done") { isEditMode = .inactive } // Still need to change to done.
                    }
                }
#endif
*/
                ForEach(document.headings.indices, id: \.self) { index in
                    HStack {
                        Text("\(index): ")
                        Text("\(document.headings[index])")
                    }
                }
                .onDelete { atIndexSet in
                    document.remove(atOffsets: atIndexSet)
                }
                // Bug: onMove does not work on IOS iPad???
                .onMove { fromIndexSet, toInt in // onMove is ForEach modifier. Separate ForEach from List.
                    document.move(fromOffsets: fromIndexSet, toOffsets: toInt)
                }
            // }
/*
#if os(iOS)
            .environment(\.editMode, Binding.constant(EditMode.active)) // Enables both move and delete. Works, but don't want delete.
#endif
*/
#if os(OSX)
            .listStyle(.bordered(alternatesRowBackgrounds: true)) // 'bordered(alternatesRowBackgrounds:)' is unavailable in iOS.
#endif
            // .environment(\.editMode, .constant(.active)) // Use this to keep editable always. // editMode unavailable in macOS.
        }
        // .navigationBarItems(trailing: EditButton())
    }
}

struct HeadingListView_Previews: PreviewProvider {
    static var previews: some View {
        HeadingListView(document: .constant(PlainText3Document(text: "Hello World!")))
    }
}
