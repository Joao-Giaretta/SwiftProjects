//
//  CartViewModel.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 23/03/26.
//

import SwiftUI
import Foundation
import Combine

class CartViewModel: ObservableObject {
    
    let cartRepo: CartProtocol
    
    @Published var cartGames: [CartItem] = []
    
    init(cartRemote: CartProtocol) {
        self.cartRepo = cartRemote
    }
    
    func fetchCart() {
        let games = cartRepo.fetchGamesInCart()
        cartGames = games.map { CartItem(id: $0.id, game: $0) }
    }
    
    func removeItems(at offsets: IndexSet) {
        offsets.forEach { index in
            let item = cartGames[index]
            cartRepo.delete(id: item.game.id)
        }
        cartGames.remove(atOffsets: offsets)
    }
    
    // MARK: - Limpar carrinho
    func clearCart() {
        cartGames.forEach { cartRepo.delete(id: $0.game.id) }
        withAnimation { cartGames.removeAll() }
    }
    
    // MARK: - Checkout (mock)
    func checkout() {
        clearCart()
        debugLog("✅ Checkout realizado com sucesso!")
    }
    
    // MARK: - Calculo do total
    var totalItems: Int {
        cartGames.reduce(0) { $0 + $1.quantity }
    }
    
    var subtotal: Double {
        cartGames.reduce(0) { $0 + ($1.game.price * Double($1.quantity)) }
    }
}

