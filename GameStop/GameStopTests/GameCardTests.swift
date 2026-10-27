//
//  GameCardTests.swift
//  GameStopTests
//
//  Created by Joao Pedro Giaretta on 26/03/26.
//

import XCTest
@testable import GameStop

@MainActor
final class GameCardTests: XCTestCase {
    
    func test_addGameWishlist() async {
        let sut = GameCardViewModel(game: Game(id: "1",
                                               developer: "",
                                               name: "",
                                               price: 1,
                                               mediaType: "",
                                               gameDescription: "",
                                               imageURL: "",
                                               specs: Specs(platform: "",
                                                            genre: "",
                                                            ageRating: "")),
                                    userId: "",
                                    isWishlisted: false,
                                    isAddedToCart: false,
                                    wishlistRemote: WishlistAddMock(), cartRemote: CartAddMock())
        await MainActor.run {
            sut.toggleWishlist()
        }
        
        await MainActor.run {
            XCTAssertTrue(sut.isWishlisted)
            
        }
    }
    
    
    func test_deleteGameWishlist() async {
        let sut = GameCardViewModel(game: Game(id: "1",
                                               developer: "teste",
                                               name: "teste",
                                               price: 10,
                                               mediaType: "teste",
                                               gameDescription: "teste",
                                               imageURL: "",
                                               specs: Specs(platform: "",
                                                            genre: "",
                                                            ageRating: "")),
                                    userId: "",
                                    isWishlisted: true,
                                    isAddedToCart: false,
                                    wishlistRemote: WishlistDeleteMock(), cartRemote: CartAddMock())
        await MainActor.run {
            sut.toggleWishlist()
        }
        
        await MainActor.run {
            XCTAssertFalse(sut.isWishlisted)
        }
        
    }
    
    func test_addGameCart() async {
        let sut = GameCardViewModel(game: Game(id: "1",
                                         developer: "",
                                         name: "",
                                         price: 1,
                                         mediaType: "",
                                         gameDescription: "",
                                         imageURL: "",
                                         specs: Specs(platform: "",
                                                      genre: "",
                                                      ageRating: "")),
                              userId: "",
                              isWishlisted: false,
                              isAddedToCart: false,
                              wishlistRemote: WishlistAddMock(), cartRemote: CartAddMock())
        
        await MainActor.run {
            sut.toggleCart()
        }
        
        await MainActor.run {
            XCTAssertTrue(sut.isAddedToCart)
        }
    }
    
    func test_deleteGameCart() async {
        let sut = GameCardViewModel(game: Game(id: "1",
                                               developer: "teste",
                                               name: "teste",
                                               price: 10,
                                               mediaType: "teste",
                                               gameDescription: "teste",
                                               imageURL: "",
                                               specs: Specs(platform: "",
                                                            genre: "",
                                                            ageRating: "")),
                                    userId: "",
                                    isWishlisted: false,
                                    isAddedToCart: true,
                                    wishlistRemote: WishlistDeleteMock(), cartRemote: CartDeleteMock())
        
        await MainActor.run {
            sut.toggleCart()
        }
        
        await MainActor.run {
            XCTAssertFalse(sut.isAddedToCart)
        }
    }
}
