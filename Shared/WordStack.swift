//
//  WordStack.swift
//  WriterSwiftUI
//
//  Created by Michael Swarm on 1/27/21.
//

import NaturalLanguage
import SwiftUI

// NLPWriterSwiftUI
// Avoid Natural Language types (NLTag) in Views?
// Use abreviations instead of long names? (Which are often longer than words.)
// What colors and fonts look best?
// Use horizontal split view? (Is there symbol for horizontal split?)

typealias WordTags = (String, NLTag?, NLTag?)

struct WordStack: View { // Use ScrollView(.horizontal) with HStack to display sentence of [WordStack]. (How to wrap?) May want to dispaly in CustomVSplitView?
    var word: WordTags
    
    var body: some View {
        GroupBox {
            VStack(spacing: 0) {
                Text(word.0).lineLimit(1)
                Text((word.1 != nil) ? word.1!.rawValue : " ").lineLimit(1).foregroundColor(.blue)
                Text((word.2 != nil) ? word.2!.rawValue : " ").lineLimit(1).foregroundColor(.blue)
                // Empty text gets removed from layout.
            }
        }
    }
}

struct WordStack_Previews: PreviewProvider {
    static var previews: some View {
        WordStack(word: "word".tagTuples().first!)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

struct WordRow: View {
    var words: [WordTags]
    
    var body: some View {
        ScrollView(.horizontal) { // Default is vertical.
            HStack {
                ForEach(words, id: \.self.0) { word in
                    WordStack(word: word)
                }
            }
        }
    }
}

struct WordRow_Preview: PreviewProvider {
    static var previews: some View {
        WordRow(words: "Hello World!".tagTuples())
    }
}
