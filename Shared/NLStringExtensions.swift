//
//  NLStringExtensions.swift
//  WriterSwiftUI
//
//  Created by Michael Swarm on 1/26/21.
//
//  Extension keeps NLP code out of main design.
//  Expect NLP calculated properties.
//  Use more functional APIs.

import Foundation
import NaturalLanguage

fileprivate struct Constant {
    static let verbose = false // Turn development print on-off.
    static let log = false // Not used. Turn run time log on-off.
    /*
    static let logger = MyLogger(MyLogger.Logs.document) // Migrate to my custom logger before Swift Logger IOS 14+ and MacOS 11.0+.
    static let syncLogger = MyLogger(MyLogger.Logs.sync) // Migrate to my custom logger before Swift Logger IOS 14+ and MacOS 11.0+.

    // Should Import-Export also log as document? Or something separate for import-export?
    
    static let mysignpost = MySignpost() // Replaces signpost below. Can remove os.log and os.signpost.
    // Can Signposts also be moved into MyLogger? MySignpost? (Then no need to import os.log and os.signpost.)
    // private static let subsystem = Bundle.main.bundleIdentifier!
    // static let signpost = OSLog(subsystem: subsystem, category: "Signpost")
    static var count = 0
    */
}


extension String {
    var nlpLines: [String] { // NLP does not include final blank line as line.
        tokens(unit: .paragraph)
    }
    var nlpSentences: [String] {
        tokens(unit: .sentence)
    }
    var nlpWords: [String] { // NLP does not include symbols (+-*/=) as words. What about digits?
        tokens(unit: .word)
    }
    var nlpWordTokens: [(String, NLTag?)] {
        let tagRanges = tags(scheme: .lexicalClass, unit: .word)
        let tagStrings = tagRanges.map { (tag: $0.0, string: String(self[$0.1])) }
        let stringTags = tagStrings.map { ($0.string, $0.tag) }
        return stringTags
    }
    // Helper Function
    func tokens(unit: NLTokenUnit) -> [String] {
        let scanner = NLTokenizer(unit: unit)
        scanner.string = self
        // Just for print...
        scanner.tokens(for: self.startIndex..<self.endIndex).enumerated().forEach {
            let index = $0.offset
            let range = $0.element
            if Constant.verbose { print("\(index).\(self[range])") }
        }
        // Best to return String, Substring or Range<String.Index>? For now, String.
        let tokens = scanner.tokens(for: self.startIndex..<self.endIndex).map { String(self[$0]) }
        return tokens
    }
    func ranges(unit: NLTokenUnit) -> [Range<String.Index>] {
        let scanner = NLTokenizer(unit: unit)
        scanner.string = self
        let ranges = scanner.tokens(for: self.startIndex..<self.endIndex) // Tokens = Ranges?
        return ranges
    }
    func language() -> String? {
        // Uses newer NaturalLanguage framework.
        if let language = NLLanguageRecognizer.dominantLanguage(for: self) {
            return language.rawValue
        } else {
            return "en"
        }
    }
    func nsLanguage() -> String? {
        // Uses older NSLinguisticTagger (IOS 5+)
        let scheme = NSLinguisticTagScheme.language
        let tagger = NSLinguisticTagger(tagSchemes: [scheme], options: 0)
        tagger.string = self
        let language = tagger.dominantLanguage
        return language
    }
    func orthography() -> NSOrthography {
        // Orthography = script + language
        let orthography = NSOrthography.defaultOrthography(forLanguage: self.language() ?? "en")
        return orthography
    }
    
    // Getting tags is work in progress.
    // Better blank than nil?
    // Better NLTag.rawValue than NLTag?

    // Tags returns only 1 tag. How to get multiple tags?
    // Working on good code for multiple tags...
    // May be helpful to have view code for tags. WordStack (TagStack?) is first try.
    
    func tags(scheme: NLTagScheme, unit: NLTokenUnit) -> [(NLTag?, Range<String.Index>)] {
        // Uses NLTagger (IOS 12+)
        let tagger = NLTagger(tagSchemes: [scheme]) // Why is scheme used 2x? Here and as tags argument?
        tagger.string = self
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace]
        let tags = tagger.tags(in: self.startIndex..<self.endIndex, unit: unit, scheme: scheme, options: options)
        return tags
    }
    func tagTuples() -> [(String, NLTag?, NLTag?)] {
        //Cannot convert return expression of type '[((NLTag?, Range<String.Index>), (NLTag?, Range<String.Index>))]' to return type '(String, String)'
        let unit: NLTokenUnit = .word
        let scanner = NLTokenizer(unit: unit)
        scanner.string = self
        let ranges = scanner.tokens(for: self.startIndex..<self.endIndex) // Tokens = Ranges?

        let tagger = NLTagger(tagSchemes: [.lexicalClass, .lemma]) // All schemes that will be used by the tagger.
        tagger.string = self
        // let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace] // Not used, because already tokenized.
        let tagTuples = ranges.map { (
            String(self[$0]),
            tagger.tag(at: $0.lowerBound, unit: unit, scheme: .lexicalClass).0,
            tagger.tag(at: $0.lowerBound, unit: .word, scheme: .lemma).0
        ) }
        return tagTuples
    }
    
    func nsTags(unit: NLTokenUnit, scheme: NSLinguisticTagScheme) -> [(string: String, tag: NSLinguisticTag?)] {
        // Uses older NSLinguisticTagger (IOS 5+)
        let options: NSLinguisticTagger.Options = [.omitPunctuation, .omitWhitespace]
        let tagger = NSLinguisticTagger(tagSchemes: [scheme], options: 0)
        tagger.string = self
        let range = NSMakeRange(0, self.count) // Why Range<String.Int> above, but NSRange here???
        var tags = [(string: String, tag: NSLinguisticTag?)]()
        tagger.enumerateTags(in: range, scheme: scheme, options: options) {
            // NSLinguisticTag?, NSRange, NSRange, UnsafeMutablePointer<ObjCBool>) -> Void'
            tag, tokenRange, _, stop  in
            tags.append((string: (self as NSString).substring(with: tokenRange), tag: tag))
        }
        return tags
    }
    
    // EXPERIMENT: HOW TO STEM WORD? CAN NLP STEM INDIVIDUAL WORDS WITHOUT CONTEXT OF SENTENCE?
    // SINGLE TOKEN (ALREADY TOKENIZED)
    func lemma() -> String {
        let tagger = NLTagger(tagSchemes: [.lemma])
        tagger.string = self
        let tag = tagger.tag(at: self.startIndex, unit: .word, scheme: .lemma).0
        if let tag = tag {
            return tag.rawValue
        } else {
            return self
        }
    }
    
    // EXPERIMENT (Should this be in NLStringExtensions?)
    func concordance(term: String) -> [String] {
        /*
         1. String contains term. (What ranges?)
         2. Divide string into sentences. (What ranges?)
         3. Find sentences that contain term. (Intersect ranges?) This will find exact terms, not normalized (lowercase, stem) terms?
         */
        let sentences = self.nlpSentences
        let matches = sentences.filter {
            $0.words
                .map { $0.lowercased() }
                .map { $0.lemma() }
                .contains(term)
        } // Basic $0.words.contains(term) will only exact match normalized term. Add lowercased() and lemma() to normalize same steps as  create forward index for content. 
        return matches
    }
}
