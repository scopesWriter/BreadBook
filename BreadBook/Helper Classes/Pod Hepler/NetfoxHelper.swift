//
//  NetfoxHelper.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation
import netfox

class NetfoxHelper {
    static let shared = NetfoxHelper()
    
    func enableNetfox() {
        #if !PROD
        NFX.sharedInstance().start()
        #endif
    }
}
