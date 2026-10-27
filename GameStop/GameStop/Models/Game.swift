//
//  Game.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 16/03/26.
//

import Foundation

struct Game: Codable, Identifiable {
    let id: String
    let developer: String
    let name: String
    let price: Double
    let mediaType: String
    let gameDescription: String
    let imageURL: String
    let specs: Specs
    
    var isWishlisted = false
    var isAddedToCart = false
    
    enum CodingKeys: String, CodingKey {
        case id
        case developer
        case name
        case price
        case mediaType = "media_type"
        case gameDescription = "description"
        case imageURL = "image"
        case specs
    }
}

struct Specs: Codable {
    let platform: String
    let genre: String
    let ageRating: String

    enum CodingKeys: String, CodingKey {
        case platform
        case genre
        case ageRating = "age_rating"
    }
}

