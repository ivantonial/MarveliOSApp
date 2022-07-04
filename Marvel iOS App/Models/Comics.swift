//
//  Comics.swift
//  Marvel iOS App
//
//  Created by Ivan Tonial on 29/06/22.
//

import Foundation

// MARK: - WelcomeComics
struct WelcomeComics: Codable {
    let data: DataComics
}


// MARK: - DataComics
struct DataComics: Codable {
    let results: [Comics]
}


// MARK: - Comics
struct Comics: Codable {
    let title: String
    let description: String?
}


