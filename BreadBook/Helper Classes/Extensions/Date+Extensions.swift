//
//  Date+Extensions.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation

extension Date {
    
    func timeAgoDisplay(justReturnDate: Bool? = false) -> String {
        
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date()) ?? Date()
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date()) ?? Date()
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        let yearAgo = calendar.date(byAdding: .day, value: -365, to: Date()) ?? Date()
        if justReturnDate ?? false {
            let formatter = DateFormatter()
            formatter.dateFormat =  "d MMM yyyy"
            return formatter.string(from: self)
        }
        if minuteAgo < self {
            return "just now"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return "\(diff)m ago"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return "\(diff)h ago"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return "\(diff)d ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = yearAgo > self ? "d MMM yyyy" : "d MMM"
            return formatter.string(from: self)
        }
    }
    
    func timeLeftDisplay() -> String {
        let now = Date()
        let diff = Calendar.current.dateComponents([.second, .minute, .hour, .day, .month], from: now, to: self)
        if isDiffInPast(diff) {
            return "ended"
        }
        if let months = diff.month, months != 0 {
            return "\(months) month\(months > 1 ? "s" : "") left"
        } else if let days = diff.day, days != 0 {
            return "\(days) day\(days > 1 ? "s" : "") left"
        } else if let hours = diff.hour, hours != 0 {
            return "\(hours) hour\(hours > 1 ? "s" : "") left"
        } else if let minutes = diff.minute, minutes != 0 {
            return "\(minutes) minute\(minutes > 1 ? "s" : "") left"
        } else if let seconds = diff.second, seconds != 0 {
            return "\(seconds) second\(seconds > 1 ? "s" : "") left"
        } else {
            return "ending now"
        }
    }
    
    func timeStampToMediumShortFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        let strDate = dateFormatter.string(from: self)
        return strDate
    }
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    func isDiffInPast(_ diff: DateComponents) -> Bool {
        // We will convert the date components to seconds and check if it's negative
        guard let seconds = diff.second,
              let minutes = diff.minute,
              let hours = diff.hour,
              let days = diff.day,
              let months = diff.month else {
            // If any component is missing, we cannot determine if it's in the past, so we return false
            return false
        }
        
        // Convert all components to seconds and check if the total is negative
        let totalSeconds = seconds + (minutes * 60) + (hours * 3600) + (days * 86400) + (months * 2592000)
        return totalSeconds < 0
    }
    
}
