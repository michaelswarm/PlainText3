//
//  SentenceListView.swift
//  PlainText3
//
//  Created by Michael Swarm on 08/03/22.
//

import SwiftUI

struct SentenceListView: View {
    @Binding var document: PlainText3Document
    
    var body: some View {
        List(document.nlpSentences, id: \.self) { sentence in
            Text(sentence)
        }
#if os(OSX)
        .listStyle(.bordered(alternatesRowBackgrounds: true)) // 'bordered(alternatesRowBackgrounds:)' is unavailable in iOS.
#endif
    }
}

struct SentenceListView_Previews: PreviewProvider {
    static var previews: some View {
        SentenceListView(document: .constant(PlainText3Document(text: "Hello World!")))
    }
}
