//
//  SectionEditorView.swift
//  PlainText3
//
//  Created by Michael Swarm on 10/03/22.
//

//  Already exists SectionListView, that reads document.text.sections.indices and document.sections[index]. 

import SwiftUI

struct SectionEditorView: View {
    @Binding var document: PlainText3Document

    var body: some View {
        List(document.sections, id: \.self) { section in
            Text(section)
        }
    }
}

struct SectionEditorView_Previews: PreviewProvider {
    static var previews: some View {
        SectionEditorView(document: .constant(PlainText3Document(text: "Hello World!")))
    }
}
