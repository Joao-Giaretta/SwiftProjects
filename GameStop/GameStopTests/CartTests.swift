//
//  CartTests.swift
//  GameStopTests
//
//  Created by Joao Pedro Giaretta on 27/03/26.
//

import XCTest
@testable import GameStop

@MainActor
final class CartTests: XCTestCase {

    func test_fetch_cart_success() async {
        let sut = CartViewModel(cartRemote: CartFetchSuccessMock())
        
        await MainActor.run {
            sut.fetchCart()
        }
        
        await MainActor.run {
            XCTAssertFalse(sut.cartGames.isEmpty)
        }
    }
    
    func test_fetch_cart_empty() async {
        let sut = CartViewModel(cartRemote: CartFetchEmptyMock())
        
        await MainActor.run {
            sut.fetchCart()
        }
        
        await MainActor.run {
            XCTAssertTrue(sut.cartGames.isEmpty)
        }
    }
    
    func test_clear_cart() async {
        let sut = CartViewModel(cartRemote: CartClearMock())
        
        await MainActor.run {
            sut.clearCart()
        }
        
        await MainActor.run {
            XCTAssertTrue(sut.cartGames.isEmpty)
        }
    }
    
}
