//
//  Extensions.swift
//
//
//  Created by Gamal Mostafa on 17/01/2022.
//

import Foundation

//MARK: Extension For Encodable to add "asDictionary" function to be used in sending the http body.

extension Encodable {
    public func asDictionary() -> [String: Any] {
        do {
            let data = try JSONEncoder().encode(self)
            guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                return [:]
            }
            return dictionary
        }
        catch {
            return [:]
        }
        
    }
    
    public func asStringDictionary() -> [String: String] {
        let dictionary = self.asDictionary()
        var dictionaryToBeReturned: [String: String] = [:]
        for item in dictionary {
            if let array = (item.value as? Array<Any>) {
                guard !array.isEmpty, let value = encodeArray(array) else { continue }
                dictionaryToBeReturned[item.key] = value
            } else if let value = encodeValue(item.value) {
                dictionaryToBeReturned[item.key] = value
            }
        }
        return dictionaryToBeReturned
    }
    
    private func encodeArray(_ array: Any) -> String? {
        if let array = (array as? Array<Any>) {
            if array.isEmpty { return nil }
            return "[" + array.compactMap { encodeArray($0) }.joined(separator: ",") + "]"
        } else {
            return encodeValue(array)
        }
    }
    
    private func encodeValue(_ value: Any) -> String? {
        guard case Optional<Any>.some(var value) = value else { return nil }
        if "\(type(of: value))" == "__NSCFBoolean" {
            value = "\(value as! Bool ? true : false)"
        }
        return "\(value)"
    }
    
}

//MARK: Extension For String to add "moduleLocalized" function which gets localizations from the module bundle
extension String {
    public func moduleLocalized() -> String {
        return  NSLocalizedString(self,bundle: Bundle.module,comment: "")
    }
}


//MARK: Extension for NSMUtable data, to append String and get data

extension NSMutableData {
  func appendString(_ string: String) {
    if let data = string.data(using: .utf8) {
      self.append(data)
    }
  }
}
