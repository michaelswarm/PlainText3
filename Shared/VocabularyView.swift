//
//  VocabularyView.swift
//  PlainText3
//
//  Created by Michael Swarm on 03/05/22.
//

//  Bug: Dismiss pauses while list scrolls???

import SwiftUI

struct VocabularyView: View {
    @Binding var document: PlainText3Document
    // @FocusedValue(\.document) var document
    @EnvironmentObject var appState: AppState
    
    var lemmas: [(String, String)] {
        document.contentVocabularyLemmas
    }

    var body: some View {
        VStack {
            Text("Vocabulary (\(lemmas.count))")
            List(lemmas.indices, id: \.self) { index in // As ScrollView + LazyVStack + ForEach got AttributeGraph: cycle detected (Same id can and does repeat.)
                Label {
                    Text("\(lemmas[index].0), \(lemmas[index].1)")
                }icon: {
                    switch lemmas[index].1 { // Same lemma may have multipe pos. Example: bottom used as both noun and adjective.
                    case "Noun":
                        Image(systemName: "square.fill")
                    case "Pronoun":
                        Image(systemName: "square")
                    case "Verb":
                        Image(systemName: "circle.fill")
                    case "Adjective":
                        Image(systemName: "plus.square")
                    case "Adverb":
                        Image(systemName: "plus.circle")
                    case "Preposition":
                        Image(systemName: "triangle")
                    case "Conjunction":
                        Image(systemName: "plus")
                    default:
                        Image(systemName: "xmark")
                    }
                }
            }
            Button(action: { appState.showVocabulary = false } ) {
                Text("Dismiss")
            }
            .padding()
        }
        .frame(width: 300, height: 600)
    }
}

/*struct VocabularyView_Previews: PreviewProvider {
    static var previews: some View {
        VocabularyView()
    }
}*/
