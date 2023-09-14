//
//  APIResponse.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation

public struct EvaAPIResponse<T: Decodable>: Decodable {
    let data: T?
    let message: String?
    let errorList : [EvaErrorListItem]?
}

public struct EvaErrorListItem : Decodable {
    let id: Int?
    let message: String?
}
