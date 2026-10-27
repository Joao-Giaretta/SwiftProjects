//
//  GameStopTests.swift
//  GameStopTests
//
//  Created by Joao Pedro Giaretta on 16/03/26.
//

import XCTest
@testable import GameStop

@MainActor
final class GameTests: XCTestCase {
    
    func test_getGames_success() async {
        let sut = GameViewModel(remote: RemoteRepositoryMockSuccess(), userId: "", wishlistRemote: WishlistFetchSuccessMock())
        
        await sut.getGames()
        
        XCTAssertFalse(sut.games.isEmpty)
        XCTAssertEqual(sut.viewState, .loaded)
    }
    
    func test_fetchWishlisted_success() async {
        let sut = GameViewModel(remote: RemoteRepositoryMockSuccess(), userId: "", wishlistRemote: WishlistFetchSuccessMock())
        
        sut.fetchWishlistedGames()
        
        XCTAssertFalse(sut.wishlistedGames.isEmpty)
        XCTAssertEqual(sut.wishlistViewState, .loaded)
    }
    
    func test_getGames_succesEmpty() async {
        let sut = GameViewModel(remote: RemoteRepositoryMockSuccessEmpty(), userId: "", wishlistRemote: WishlistFetchSuccessMock())
        
        await sut.getGames()
        
        XCTAssertTrue(sut.games.isEmpty)
        XCTAssertEqual(sut.viewState, .empty)
    }
    
    func test_getGames_erros() async {
        let sut = GameViewModel(remote: RemoteRepositoryErrorMock(), userId: "", wishlistRemote: WishlistFetchSuccessMock())
        
        await sut.getGames()
        
        XCTAssertEqual(sut.viewState, .error(message: "Erro de servidor código 404"))
    }
    
    func test_filterGames_foundItems() async {
        let sut = GameViewModel(remote: RemoteRepositoryMockSuccess(), userId: "", wishlistRemote: WishlistFetchSuccessMock())
        
        await sut.getGames()
        sut.filterGames("hollow")
        
        XCTAssertEqual(sut.viewState, .loaded)
        XCTAssertFalse(sut.filteredGames.isEmpty)
    }
    
    func test_filterGames_notFound() async {
        let sut = GameViewModel(remote: RemoteRepositoryMockSuccess(), userId: "", wishlistRemote: WishlistFetchSuccessMock())
        
        await sut.getGames()
        sut.filterGames("XXXXXXXX")
        
        XCTAssertEqual(sut.viewState, .empty)
        XCTAssertTrue(sut.filteredGames.isEmpty)
    }
    
    func test_filterGames_emptyQuery() async {
        let sut = GameViewModel(remote: RemoteRepositoryMockSuccess(), userId: "", wishlistRemote: WishlistFetchSuccessMock())
        
        await sut.getGames()
        sut.filterGames("")
        
        XCTAssertEqual(sut.viewState, .loaded)
        XCTAssertEqual(sut.filteredGames.count, sut.games.count)
    }
    
}
