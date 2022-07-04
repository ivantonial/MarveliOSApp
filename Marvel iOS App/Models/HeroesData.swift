//
//  HeroesData.swift
//  Marvel iOS App
//
//  Created by Ivan Tonial on 27/06/22.
//

import Foundation

// MARK: - Welcome
struct Welcome: Codable {
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let results: [Result]
}

// MARK: - Result
struct Result: Codable {
    let id: Int
    let name: String
    let thumbnail: Thumbnail
}

// MARK: - Thumbnail
struct Thumbnail: Codable {
    let path: String
    let `extension`: String
}
