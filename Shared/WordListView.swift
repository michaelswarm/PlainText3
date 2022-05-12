//
//  WordListView.swift
//  PlainText3
//
//  Created by Michael Swarm on 08/03/22.
//

import SwiftUI

struct WordListView: View {
    @Binding var document: PlainText3Document
    
    var body: some View {
        GroupBox {
            VStack {
                List(document.nlpWords, id: \.self) { word in
                    Text(word)
                }
#if os(OSX)
                .listStyle(.bordered(alternatesRowBackgrounds: true))
#endif
                Text("Word Count: \(document.nlpWords.count)").font(.caption).padding(.horizontal, 4)
            }
        }
    }
}

struct WordListView_Previews: PreviewProvider {
    static var previews: some View {
        WordListView(document: .constant(PlainText3Document(text: "Hello World!")))
    }
}
