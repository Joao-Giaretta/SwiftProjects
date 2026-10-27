//
//  CartItem.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 23/03/26.
//

import Foundation

struct CartItem: Identifiable {
    let id: String
    let game: Game
    var quantity: Int = 1
}
