//
//  AttributedStringExtensions.swift
//  WriterSwiftUI
//
//  Created by Michael Swarm on 22/02/22.
//

import Foundation

extension AttributedString {
    func allRanges(inRange range: Range<AttributedString.Index>, ofSearchTerm searchTerm: String) -> [Range<AttributedString.Index>] {
        // Case insensitive match
        // As far as I know, no standard function to find all matches. Builds on standard range function.
        var ranges = [Range<AttributedString.Index>]()
        var searchRange = range.lowerBound..<range.upperBound // Variable range (parameter is constant), expressed as bounds and operator. Compare to modification after match below. (The first operand changes.)
        var substring = self[searchRange] // Use substring. 
        // AttributedString.range() does not same parameters as String.range(of:options:range:locale). Missing range: parameter.
        // Work around that by using substring, starting with entire string, and continually moving substring forward as matches are found.
        while let matchRange = substring.range(of: searchTerm, options: .caseInsensitive, locale: nil) {
            ranges.append(matchRange)
            searchRange = matchRange.upperBound..<searchRange.upperBound // Modify variable search range.
            substring = self[searchRange] // Move substring forward.
        }
        return ranges
    }
}
