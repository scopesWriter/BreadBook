//
//  TokenHandler.swift
//
//
//  Created by Gamal Mostafa on 12/01/2022.
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

