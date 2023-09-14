//
//  EvaAPIResponse.swift
//  
//
//  Created by Gamal Mostafa on 18/01/2022.
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
