//
//  TokenHandler.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation

public protocol TokenHandler {
    func getAccessToken() -> String?
    func updateToken(accessToken: String, refreshToken: String)
    func refreshToken(completion: @escaping ()->Void)
    @available(macOS 12.0, iOS 13.0, *)
    func refreshToken() async -> Bool
}

public extension TokenHandler  {
    func refreshToken(completion: @escaping ()->Void){}
    @available(macOS 12.0, iOS 13.0, *)
    func refreshToken() async -> Bool {return false}
}

