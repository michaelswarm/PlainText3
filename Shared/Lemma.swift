//
//  Lemma.swift
//  PlainText3
//
//  Created by Michael Swarm on 05/05/22.
//

//  TBD:
//  - WordView. Vertical like current WordStack? Or horizontal? (How to show multiple pos and spellings?)
//  - WordList. New. Sorted by alphabet and grouped by first letter. With list search. Basic dictionary view.
//  - Export from PlainText.
//  - Import to Dictionary.

import Foundation
import NaturalLanguage

// How does this relate to tuple (String, NLTag?, NLTag?)?
typealias TagTuple = (spelling: String, pos: NLTag?, lemma: NLTag?)

// Filter lemma.
// Intersect spelling and pos.

struct Lemma: Codable { // (actually a protocol?) LemmaWord?
    var lemma: String // lowercased. Apple NLP keeps capitals for some proper nouns like Mac and SwiftUI. Should these be named entities, and excluded from lemmas? (Fail on upper case, rather than normalize?)
    var pos: Set<String> // Use Apple NLP tags for part of speech. At least 1. (pos = grammar?)
    var spellings: Set<String> // lowercased. At least 1. Bottoms up spelling, from context. (Rather than top down by grammar inflection algorithm.)
    // var language: TBD
    init(_ tagTuple: TagTuple) { // failable? (Requires non optional tags.)
        lemma = tagTuple.lemma!.rawValue.lowercased()
        pos = Set([tagTuple.pos!.rawValue])
        spellings = Set([tagTuple.spelling.lowercased()]) // lowercased. Do not retain case of original context.
    }
    mutating func intersect(_ word: Lemma) {
        pos = pos.intersection(word.pos)
        spellings = spellings.intersection(word.spellings)
    }
}

extension Lemma: Identifiable {
    var id: String { lemma }
}
