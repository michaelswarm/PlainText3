//
//  SentenceTagsListView.swift
//  PlainText3
//
//  Created by Michael Swarm on 08/03/22.
//

import SwiftUI

struct SentenceTagsListView: View {
    @Binding var document: Document
    
    var body: some View {
        GroupBox {
            List(document.nlpSentences, id: \.self) { sentence in
                WordRow(words: sentence.tagTuples())
            }
#if os(OSX)
            .listStyle(.bordered(alternatesRowBackgrounds: true)) // 'bordered(alternatesRowBackgrounds:)' is unavailable in iOS.
#endif
            .listRowInsets(.none)
            // .listStyle(.bordered(alternatesRowBackgrounds: true))
        }
    }
}

struct SentenceTagsListView_Previews: PreviewProvider {
    static var previews: some View {
        SentenceTagsListView(document: .constant(PlainText3Document(text: "Hello World!")))
    }
}
