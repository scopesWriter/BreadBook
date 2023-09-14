//
//  String+Extensions.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import SwiftUI

public extension String {
    
    //MARK: Check for Valid Email
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var hasValue: Bool {
        !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var isValidMobileNumber : Bool {
        let prefixes = ["010","011","012","015"]
        return prefixes.contains(where: self.hasPrefix) && self.count == 11 && self.isNumbersOnly()
    }
    
    func isNumbersOnly() -> Bool {
        do {
            let regexNumbersOnly = try NSRegularExpression(pattern: ".*[^0-9].*", options: [])
            let success = regexNumbersOnly.firstMatch(in: self, options: [], range: NSMakeRange(0, self.count)) == nil
            return success
        } catch let error as NSError {
            print(error.description)
            return false
        }
    }
    
    var localize: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func numberOfOccurrencesOf(string: String) -> Int {
        return self.components(separatedBy:string).count - 1
    }
}


//MARK: CharAt and Substrings
public extension String {
    
    func charAt(_ index: Int)-> String{
        return self[index]
    }
    
    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, count) ..< count]
    }
    
    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }
    
    func substring(fromIndex: Int, toIndex: Int) -> String {
        if fromIndex > toIndex {return ""}
        return self[min(fromIndex, count) ..< max(0, toIndex)]
    }
    
    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
                                            upper: min(count, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}

public extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

public extension String {
    func daySuffix()-> String {
        var daySuffix = "th"
        switch self {
        case "01": daySuffix = "st"
        case "02": daySuffix = "nd"
        case "03": daySuffix = "rd"
        default: daySuffix = "th"
        }
        return daySuffix
    }
}


public extension Optional where Wrapped == String {
    
    var isNilOrEmpty: Bool {
        return self?.replacingOccurrences(of: " ", with: "").isEmpty ?? true
    }
    
    var orEmpty: String {
        return self ?? ""
    }
    
}

extension String {
    // MARK: - Is Valid Name
    var isValidName: Bool {
        !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        self.split(separator: " ").count > 1 &&
        self.split(separator: " ").map { String($0).count }.allSatisfy { $0 > 2 } &&
        self.rangeOfCharacter(from: .decimalDigits) == nil  &&
        self.rangeOfCharacter(from: .punctuationCharacters) == nil &&
        self.rangeOfCharacter(from: .symbols) == nil
    }
    
    // MARK: - Is .com Email
    func isDotComEmail() -> Bool {
        return self.isValidEmail && self.hasSuffix(".com")
    }
    
    func versionCompare(_ otherVersion: String) -> ComparisonResult {
        return self.compare(otherVersion, options: .numeric)
    }
    
    var firstLetterCapitalized: String {
        return prefix(1).capitalized + dropFirst().lowercased()
    }
    
}

// as time interval format
extension String {
    
    enum Format {
        case ago
        case left
        case meduimShort
    }
    
    func asTimeInterval(format: String.Format) -> String {
        let date = Date(timeIntervalSince1970: self.convertToTimeInterval())
        switch format {
        case .ago:
            return date.timeAgoDisplay()
        case .left:
            return date.timeLeftDisplay()
        case .meduimShort:
            return date.timeStampToMediumShortFormat()
        }
    }
    
    func convertToTimeInterval() -> TimeInterval {
        guard self != "" else {
            return 0
        }

        var interval: Double = 0

        let parts = self.components(separatedBy: ":")
        for (index, part) in parts.reversed().enumerated() {
            interval += (Double(part) ?? 0) * pow(Double(60), Double(index))
        }

        return interval
    }
    
}

extension String {
    func removingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else {
            return self
        }
        return String(self.dropFirst(prefix.count))
    }
   func width(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

extension String {
    func withoutHashtag() -> String {
        return self.replacingOccurrences(of: "#", with: "")
    }
    
    func isEmptyOrWhitespace() -> Bool {
        
        // Check empty string
        if self.isEmpty {
            return true
        }
        // Trim and check empty string
        return (self.trimmingCharacters(in: .whitespaces) == "")
    }
}

extension String {
    func isTimestampInPast() -> Bool {
        guard let timestampDouble = Double(self), timestampDouble > 0 else {
            return false
        }
        let timestampDate = Date(timeIntervalSince1970: timestampDouble)
        return timestampDate < Date()
    }
}
