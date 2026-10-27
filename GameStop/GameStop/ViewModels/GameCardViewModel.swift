//
//  GameCardViewModel.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 19/03/26.
//

import Combine
import SwiftUI
import Foundation

class GameCardViewModel: ObservableObject {
    
    let game: Game
    let wishlistRepo: WishlistProtocol
    let cartRepo: CartProtocol
    let userId: String
    
    @Published var isWishlisted: Bool
    @Published var isAddedToCart: Bool
    
    var onWishlistToggle: (() -> Void)? // Atualizar a lista quando remover um game
    var onCartToggle: (() -> Void)? // Atualiza o carrinho quando remover uma game
    
    init(
        game: Game,
        userId: String,
        isWishlisted: Bool? = nil,
        isAddedToCart: Bool? = nil,
        onWishlistToggle: (() -> Void)? = nil,
        onCartToggle: (() -> Void)? = nil,
        wishlistRemote: WishlistProtocol,
        cartRemote: CartProtocol
    ) {
        self.game = game
        self.userId = userId
        self.wishlistRepo = wishlistRemote
        self.cartRepo = cartRemote
        self.isWishlisted = isWishlisted ?? wishlistRepo.isWishlisted(id: game.id)
        self.isAddedToCart = isAddedToCart ?? cartRepo.isInCart(id: game.id)
        self.onWishlistToggle = onWishlistToggle
        self.onCartToggle = onCartToggle
    }
    
    // MARK: - Wishlist
    func toggleWishlist() {
        wishlistRepo.toggle(game: game)
        isWishlisted = wishlistRepo.isWishlisted(id: game.id)
        onWishlistToggle?()
    }
    
    // MARK: - Cart
    func toggleCart() {
        cartRepo.toggle(game: game)
        isAddedToCart = cartRepo.isInCart(id: game.id)
        onCartToggle?()
    }
}

