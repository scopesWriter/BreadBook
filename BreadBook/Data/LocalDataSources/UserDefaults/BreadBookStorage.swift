//
//  BreadBookStorage.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation

struct BreadBookStorage {
    
    @Storage(key: "NEWSFEED_ITEMS", defaultValue: [])
    static var newsfeedItems: FeedItems?

}
