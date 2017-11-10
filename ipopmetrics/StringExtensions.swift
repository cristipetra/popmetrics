//
//  StringExtensions.swift
//  Twignature
//
//  Created by Ivan Hahanov on 5/12/17.
//  Copyright © 2017 user. All rights reserved.
//

import Foundation
import UIKit

typealias Tag = String

extension String {
    
    func toDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
    
    var attributed: NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
    
    var range: Range<String.Index>? {
        return range(for: self)
    }
    
    var nsRange: NSRange {
        return NSRange(location: 0, length: count)
    }

    mutating func replaceString(in range: NSRange, with string: String) {
        self = (self as NSString).replacingCharacters(in: range, with: "")
        self.insert(contentsOf: string,
                    at: self.index(self.startIndex, offsetBy: range.location))
    }
    
    func range(for string: String) -> Range<String.Index>? {
        guard let start = index(of: string), let end = endIndex(of: string) else { return nil }
        return Range(uncheckedBounds: (lower: start, upper: end))
    }
    
    func index(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.lowerBound
    }
    
    func endIndex(of string: String, options: CompareOptions = .literal) -> Index? {
        return range(of: string, options: options)?.upperBound
    }
    
    func indexes(of string: String, options: CompareOptions = .literal) -> [Index] {
        var result: [Index] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range.lowerBound)
            start = range.upperBound
        }
        return result
    }
    
    func ranges(of string: String, options: CompareOptions = .literal) -> [Range<Index>] {
        var result: [Range<Index>] = []
        var start = startIndex
        while let range = range(of: string, options: options, range: start..<endIndex) {
            result.append(range)
            start = range.upperBound
        }
        return result
    }
    
    func findMatches(for pattern: String) -> [NSTextCheckingResult] {
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return [] }
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        return matches
    }
    
    func matches(regex: String) -> Bool {
        let test = NSPredicate(format:"SELF MATCHES %@", regex)
        return test.evaluate(with: self)
    }
    
    fileprivate func taggedRange(tag: Tag) -> Range<Index>? {
        guard let start = index(of: "<\(tag)>"),
            let end = index(of: "</\(tag)>") else { return nil }
        return Range(uncheckedBounds: (lower: start, upper: end))
    }
    
    func localized(file: String) -> String {
        return NSLocalizedString(self, tableName: file, bundle: Bundle.main, comment: "")
    }
    
    func sizeForText(forContainerWithWidth containerWidth: CGFloat, font: UIFont) -> CGSize {
        let size = CGSize(width: containerWidth, height: CGFloat.greatestFiniteMagnitude)
        let options: NSStringDrawingOptions = [.usesFontLeading, .usesLineFragmentOrigin]
        let attributes: [NSAttributedStringKey: Any] = [.font: font]
        return (self as NSString).boundingRect(with: size, options: options, attributes: attributes, context: nil).size
    }
}

extension NSMutableAttributedString {
    
    func alignment(_ alignment: NSTextAlignment) -> NSMutableAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = alignment
        let new = NSMutableAttributedString(attributedString: self)
        new.addAttribute(.paragraphStyle, value: paragraph, range: string.nsRange)
        return new
    }
    
    // MARK: - Tags
    
    func baselineOffset(_ offset: Double, for tag: Tag? = nil) -> NSMutableAttributedString {
        return applyAttribute(name: .baselineOffset, value: offset, tag: tag)
    }
    
    func paragraphStyle(_ style: NSParagraphStyle, for tag: Tag? = nil) -> NSMutableAttributedString {
        return applyAttribute(name: .paragraphStyle, value: style, tag: tag)
    }
        
    func font(_ font: UIFont, for tag: Tag? = nil) -> NSMutableAttributedString {
        return applyAttribute(name: .font, value: font, tag: tag)
    }
    
    func color(_ color: UIColor, for tag: Tag? = nil) -> NSMutableAttributedString {
        return applyAttribute(name: .foregroundColor, value: color, tag: tag)
    }
    
    func kern(_ kern: CGFloat, for tag: Tag? = nil) -> NSMutableAttributedString {
        return applyAttribute(name: .kern, value: kern, tag: tag)
    }
    
    func link(_ link: String = "a", for tag: Tag? = nil) -> NSMutableAttributedString {
        return applyAttribute(name: .link, value: link, tag: tag)
    }
    
    func underline(_ style: NSUnderlineStyle = .styleSingle, for tag: Tag? = nil) -> NSMutableAttributedString {
        return applyAttribute(name: .underlineStyle, value: style.rawValue, tag: tag)
    }
    
    // MARK: - Mentions
    
    func font(_ font: UIFont, mention: String) -> NSMutableAttributedString {
        return applyAttribute(name: .font, value: font, mention: mention)
    }
    
    func color(_ color: UIColor, mention: String) -> NSMutableAttributedString {
        return applyAttribute(name: .foregroundColor, value: color, mention: mention)
    }
    
    func kern(_ kern: CGFloat, mention: String) -> NSMutableAttributedString {
        return applyAttribute(name: .kern, value: kern, mention: mention)
    }
    
    // MARK: - Range
    
    func link(_ link: String = "a", range: Range<String.Index>) -> NSMutableAttributedString {
        return applyAttribute(name: .link, value: link, range: range)
    }
    
    func font(_ font: UIFont, range: Range<String.Index>) -> NSMutableAttributedString {
        return applyAttribute(name: .font, value: font, range: range)
    }
    
    func color(_ color: UIColor, range: Range<String.Index>) -> NSMutableAttributedString {
        return applyAttribute(name: .foregroundColor, value: color, range: range)
    }
    
    func kern(_ kern: CGFloat, range: Range<String.Index>) -> NSMutableAttributedString {
        return applyAttribute(name: .kern, value: kern, range: range)
    }
    
    // MARK: - Ranges
    
    func underline(_ style: NSUnderlineStyle = .styleSingle, ranges: [NSRange]) -> NSMutableAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        for range in ranges {
            result.applyAttributeInPlace(name: .underlineStyle, value: style.rawValue, range: range)
        }
        return result
    }
    
    func font(_ font: UIFont, ranges: [NSRange]) -> NSMutableAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        for range in ranges {
            result.applyAttributeInPlace(name: .font, value: font, range: range)
        }
        return result
    }
    
    func color(_ color: UIColor, ranges: [NSRange]) -> NSMutableAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        for range in ranges {
            result.applyAttributeInPlace(name: .foregroundColor, value: color, range: range)
        }
        return result
    }
    
    func kern(_ kern: CGFloat, ranges: [NSRange]) -> NSMutableAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        for range in ranges {
            result.applyAttributeInPlace(name: .kern, value: kern, range: range)
        }
        return result
    }
    
    func link(_ link: String = "a", ranges: [NSRange]) -> NSMutableAttributedString {
        let result = NSMutableAttributedString(attributedString: self)
        for range in ranges {
            result.applyAttributeInPlace(name: .link, value: link, range: range)
        }
        return result
    }
    
    private func applyAttribute(name: NSAttributedStringKey, value: Any, mention: String) -> NSMutableAttributedString {
        guard let range = string.range(for: mention) else {
            return applyAttribute(name: name, value: value, range: string.range!)
        }
        return applyAttribute(name: name, value: value, range: range)
    }
    
    private func applyAttribute(name: NSAttributedStringKey, value: Any, tag: Tag? = nil) -> NSMutableAttributedString {
        guard let tag = tag, let range = string.taggedRange(tag: tag) else {
            return applyAttribute(name: name, value: value, range: string.range!)
        }
        return applyAttribute(name: name, value: value, range: range)
    }
    
    private func applyAttribute(name: NSAttributedStringKey, value: Any, range: Range<String.Index>) -> NSMutableAttributedString {
        let new = NSMutableAttributedString(attributedString: self)
        new.addAttribute(name, value: value, range: NSRange(range: range, in: string))
        return new
    }
    
    var clear: NSAttributedString {
        let new = NSMutableAttributedString(attributedString: self)
        new.string.findMatches(for: "<[a-z]>").forEach { new.replaceCharacters(in: $0.range, with: "") }
        new.string.findMatches(for: "</[a-z]>").forEach { new.replaceCharacters(in: $0.range, with: "") }
        return new
    }
}

extension NSMutableAttributedString {
    fileprivate func applyAttributeInPlace(name: NSAttributedStringKey, value: Any, range: NSRange) {
        self.addAttribute(name, value: value, range: range)
    }
}

public extension NSRange {
    private init(string: String, lowerBound: String.Index, upperBound: String.Index) {
        let utf16 = string.utf16
        
        let lowerBound = lowerBound.samePosition(in: utf16)!
        let location = utf16.distance(from: utf16.startIndex, to: lowerBound)
        let length = utf16.distance(from: lowerBound, to: upperBound.samePosition(in: utf16)!)
        
        self.init(location: location, length: length)
    }
    
    public init(range: Range<String.Index>, in string: String) {
        self.init(string: string, lowerBound: range.lowerBound, upperBound: range.upperBound)
    }
    
    public init(range: ClosedRange<String.Index>, in string: String) {
        self.init(string: string, lowerBound: range.lowerBound, upperBound: range.upperBound)
    }
}
