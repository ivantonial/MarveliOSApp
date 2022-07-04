//
//  Stories.swift
//  Marvel iOS App
//
//  Created by Ivan Tonial on 29/06/22.
//

import Foundation

// MARK: - WelcomeStories
struct WelcomeStories: Codable {
    let data: DataStories
}


// MARK: - DataStories
struct DataStories: Codable {
    let results: [Stories]
}


// MARK: - Comics
struct Stories: Codable {
    let title: String
    let description: String?
}
