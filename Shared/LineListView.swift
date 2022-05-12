//
//  LineListView.swift
//  PlainText3
//
//  Created by Michael Swarm on 08/03/22.
//

import SwiftUI

struct LineListView: View {
    @Binding var document: PlainText3Document
    
    var body: some View {
        GroupBox {
            List(document.nlpLines.indices, id: \.self) { index in
                Text("\(index): \(document.nlpLines[index])")
            }
#if os(OSX)
            .listStyle(.bordered(alternatesRowBackgrounds: true))
#endif
        }
    }
}

struct SentenceLineView_Previews: PreviewProvider {
    static var previews: some View {
        LineListView(document: .constant(PlainText3Document(text: "Hello World!")))
    }
}
