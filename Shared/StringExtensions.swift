//
//  StringExtensions.swift
//  TextLibraryProto
//
//  Created by Michael Swarm on 7/18/20.
//
//  Jan 2021 added var words: [String]. Both StringExtensions and NLStringExtensions provide lines and words.

import Foundation

extension String {
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-.~/?"
        let alphaAndUnreserved = NSMutableCharacterSet.alphanumeric()
        alphaAndUnreserved.addCharacters(in: unreserved)
        let allowed = alphaAndUnreserved as CharacterSet
        return self.addingPercentEncoding(withAllowedCharacters: allowed)!
    }
    // Remove with String.removingPercentEncoding! // String?
    
    var lines: [String] { return self.components(separatedBy: .newlines) } // Remove the newlines. Check NLP version.
    var words: [String] {
        let separators = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters).union(.symbols).union(.decimalDigits) // Includes symbols (+-*/=) as words. NLP does not include symbols (+-*/=) as words.
        let components = self.components(separatedBy: separators)
        let words = components.filter { !$0.isEmpty }
        return words
    }
    var sections: [String] {
        // let separator = "\n\n" // or "\n\n\n" ???
        // let sections = self.components(separatedBy: separator)
        // return self.components(separatedBy: separator)
        // let noEmptySections = sections.filter { !$0.isEmpty }
        // Filter empty sections can still leaves non empty sections with odd leading returns.
        // Separate by pattern, 2 or more returns, not characters or string? Use custom regex split String extension, below.
        // return noEmptySections
        
        // Using regex repetition avoids empty sections. Leaves single returns within sections and at end of last section.
        let splits = self.split(usingRegex: "\n{2,}") // {2,} is explicit repetition 2 or more.
        // return splits

        // Still possible to have empty sections (only end?).
        let nonEmptySections = splits.filter { !$0.isEmpty }
        return nonEmptySections
    }
    
    func allRanges(inRange range: Range<String.Index>, ofSearchTerm searchTerm: String) -> [Range<String.Index>] {
        // Case insensitive match
        // As far as I know, no standard function to find all matches. Builds on standard range function.
        var ranges = [Range<String.Index>]()
        var searchRange = range.lowerBound..<range.upperBound // Variable range (parameter is constant), expressed as bounds and operator. Compare to modification after match below. (The first operand changes.)

        while let matchRange = self.range(of: searchTerm, options: .caseInsensitive, range: searchRange, locale: nil) {
            ranges.append(matchRange)
            searchRange = matchRange.upperBound..<searchRange.upperBound // Modify variable search range.
        }

        return ranges
    }
    
    func allRanges(inRange range: Range<String.Index>, ofSearchPattern searchPattern: String) -> [Range<String.Index>] {
        // Case insensitive pattern match
        // As far as I know, no standard function to find all matches. Builds on standard range function.
        var ranges = [Range<String.Index>]()
        var searchRange = range.lowerBound..<range.upperBound // Variable range (parameter is constant), expressed as bounds and operator. Compare to modification after match below. (The first operand changes.)
        
        while let matchRange = self.range(of: searchPattern, options: [.regularExpression, .caseInsensitive], range: searchRange, locale: nil) {
            ranges.append(matchRange)
            searchRange = matchRange.upperBound..<searchRange.upperBound // Modify variable search range.
        }
        
        return ranges
    }
    
    // From Stack Overflow: https://stackoverflow.com/questions/57215919/how-to-get-components-separated-by-regular-expression-but-also-with-separators
    // Does not include separators in components.
    func split(usingRegex pattern: String) -> [String] {
        let regex = try! NSRegularExpression(pattern: pattern)
        let matches = regex.matches(in: self, range: NSRange(0..<utf16.count))
        let ranges = [startIndex..<startIndex] + matches.map{Range($0.range, in: self)!} + [endIndex..<endIndex]
        return (0...matches.count).map {String(self[ranges[$0].upperBound..<ranges[$0+1].lowerBound])}
    }
}
