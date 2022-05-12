//
//  ContentStatusView.swift
//  PlainText3
//
//  Created by Michael Swarm on 08/03/22.
//

//  Experiment with bottom status bar, mostly with Group Box and Text font and foreground style. 

import SwiftUI

struct ContentStatusView: View {
    @Binding var document: PlainText3Document

    var body: some View {
        VStack {
            HStack {
                Text("Lines: \(document.text.lines.count)")
                Spacer()
                Text("Words: \(document.text.words.count)")
                Spacer()
                Text("Sentences: \(document.text.nlpSentences.count)")
            }
            Text(document.headingVocabularyLemmas.description)
        }
        .padding(.horizontal)
        .font(.callout)
        .foregroundStyle(.secondary)
        .lineLimit(1)
    }
}

struct ContentStatusView_Previews: PreviewProvider {
    static var previews: some View {
        ContentStatusView(document: .constant(PlainText3Document(text: "Hello World!")))
    }
}
