//
//  BreadBookAPIConfiguration.swift
//  MedSulto
//
//  Created by Bishoy Badea [Pharma] on 17/01/2022.
//

import Foundation

extension APIConfigurationDelegate {
    var baseHeaders: [String: String] {
        return ["Content-Type": "application/json"]
    }
    
    var emptyHeaders: [String: String] {
        return [:]
    }
}
