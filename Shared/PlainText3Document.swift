//
//  PlainText3Document.swift
//  Shared
//
//  Created by Michael Swarm on 06/03/22.
//

import SwiftUI
import UniformTypeIdentifiers
import NaturalLanguage // NLTag

typealias Document = PlainText3Document

extension UTType {
    static var exampleText: UTType {
        UTType(importedAs: "com.example.plain-text")
    }
}

struct PlainText3Document: FileDocument {
    var text: String
    var id = UUID().uuidString

    init(text: String = "Hello, world!") {
        self.text = text
    }

    static var readableContentTypes: [UTType] { [.exampleText] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        text = string
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = text.data(using: .utf8)!
        return .init(regularFileWithContents: data)
    }
    
    // MARK: FIND
    func allRanges(searchText: String) -> [Range<String.Index>] {
        text.allRanges(inRange: text.startIndex..<text.endIndex, ofSearchTerm: searchText)
    }

    func attributedText(searchText: String) -> AttributedString {
        var attributed = AttributedString(text)
        let matches = attributed.allRanges(inRange: attributed.startIndex..<attributed.endIndex, ofSearchTerm: searchText)
        for match in matches {
            attributed[match].backgroundColor = .accentColor
        }
        return attributed
    }
       
    // MARK: REPLACE
    mutating func replace(at subrange: Range<String.Index>, with string: String) {
        text.replaceSubrange(subrange, with: string)
    }
    mutating func replaceAll(of oldString: String, with newString: String) {
        text = text.replacingOccurrences(of: oldString, with: newString) // Default is case sensitive. Options include .caseInsensitive and .diacriticInsensitive.
        // text = text.replacingOccurrences(of: oldString, with: newString, options: .caseInsensitive) // Default is case sensitive. Options include .caseInsensitive and .diacriticInsensitive.
    }
    
    // MARK: LANGUAGE
    // StringExtensions
    var wordCount: Int { text.words.count }
    var lineCount: Int { text.lines.count }
    // var sections: [String] { text.sections }
    var sectionCount: Int { text.sections.count }

    // NLStringExtensions
    var nlpWords: [String] { text.nlpWords }
    var nlpLines: [String] { text.nlpLines }
    var nlpSentences: [String] { text.nlpSentences }

    var nlpWordCount: Int { nlpWords.count }
    var nlpLineCount: Int { nlpLines.count }
    var nlpSentenceCount: Int { nlpSentences.count }
    
    // New and experimental. Use something like SentenceTagsListView to view.
    // Vocabulary = Lemmas only (No guarantee is real word if can't resolve lemma.)
    var contentVocabularyLemmas: [(String, String)] {
        contentVocabulary.map { ($0.2!.rawValue, $0.1!.rawValue) } // Lemma guaranteed != nil from vocabulary filter.
    }
    var contentVocabulary: [(String, NLTag?, NLTag?)] { // Sentence vocabulary? Headings count as sentences.
        var tagTuples = [(String, NLTag?, NLTag?)]()
        text.nlpSentences.forEach {
            tagTuples.append(contentsOf: $0.tagTuples()
                                .filter { $0.2 != nil } ) // Include only terms with lemma.
        }
        var dictionary = [String : (String, NLTag?, NLTag?)]()
        tagTuples.forEach {
            dictionary[$0.2!.rawValue] = $0 // Deduplicate based on lemma.
        }
        return Array(dictionary.values)
    }
    
    var headingVocabularyLemmas: [String] {
        // What if further filtered stop words by pos???
        let filtered = headingVocabulary.filter { $0.1?.rawValue == "Noun" } // Filter stop words (Article, Preposition, Adj, Adv, Verb, etc.) Most heading words are probably nouns anyways. With maybe a few verbs and adjectives. 
        return filtered.map { $0.2!.rawValue } // Lemma guaranteed != nil from vocabulary filter.
    }
    var headingVocabulary: [(String, NLTag?, NLTag?)] { 
        var tagTuples = [(String, NLTag?, NLTag?)]()
        headings.forEach {
            tagTuples.append(contentsOf: $0.tagTuples()
                                .filter { $0.2 != nil } ) // Include only terms with lemma.
        }
        var dictionary = [String : (String, NLTag?, NLTag?)]()
        tagTuples.forEach {
            dictionary[$0.2!.rawValue] = $0 // Deduplicate based on lemma.
        }
        return Array(dictionary.values)
    }

    // MARK: SECTION ACCESS
    mutating func move(fromOffsets: IndexSet, toOffsets: Int) {
        var sections = text.sections
        sections.move(fromOffsets: fromOffsets, toOffset: toOffsets)
        text = sections.joined(separator: Constant.separator)
    }
    
    mutating func remove(atOffsets: IndexSet) {
        var sections = text.sections
        sections.remove(atOffsets: atOffsets)
        text = sections.joined(separator: Constant.separator)
    }
    // May need separate view model, with sections, that stays in sync with underlying model. Good use for view model. May be single model or composite models (section + section list).
    
    var sections: [String] {
        set {
            // _sections = newValue // Write cache.
            text = newValue.joined(separator: Constant.separator) // Write to storage.
        }
        get {
            text.sections
            // text.components(separatedBy: Constant.separator) // Read from storage.
        }
    }
    var headings: [String] {
        get {
            // Strictly speaking, the first line. First line may still be quite long. If first line contains multiple sentences, include only the first sentence?
            let firstLines = text.sections.map { $0.lines.first != nil ? $0.lines.first! : "" } // Does every section always contain a line?
            let firstSentences = firstLines.map { $0.nlpSentences.first != nil ? $0.nlpSentences.first! : ""}
            return firstSentences
        }
    }
    // private var _sections: [String] // Cache value.
    
    /*
     How to keep in sync?
     Every modification to any section must be immediately translated to underlying store.
     
    */
    
    // MARK: CONSTANTS
    struct Constant {
        static let separator = "\n\n" // Also exists in String extensions.
    }

}

#if os(OSX)
extension PlainText3Document {
    // MARK: - PRINT
    
    func printMac() {
        // 1. Print Container View
        let frame = NSRect(x: 0, y: 0, width: 600, height: 400) // Does frame origin or size matter???
        let textView = NSTextView(frame: frame) // New NSTextView. What frame?
        textView.string = text
        // What font, etc?
        
        // 2. Print Info
        let printInfo = NSPrintInfo()
        printInfo.scalingFactor = 0.7
        // What margins, etc? (Default seems to be 1 inch all sides.) 
        // printInfo.topMargin = 0.5
        // printInfo.bottomMargin = 0.5
        // printInfo.leftMargin = 0.25
        // printInfo.rightMargin = 0.25

        
        // 3. Print Operation
        let printOperation = NSPrintOperation(view: textView, printInfo: printInfo)
        printOperation.printInfo.isVerticallyCentered = false
        printOperation.printInfo.isHorizontallyCentered = false
        // let docWindow: NSWindow? = nil // How to get window???
        // printOperation.runModal(for: docWindow!, delegate: self, didRun: nil, contextInfo: nil)
        printOperation.run()
    }
}
#endif

