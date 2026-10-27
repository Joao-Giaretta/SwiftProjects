//
//  AulaXcTesteTests.swift
//  AulaXcTesteTests
//
//  Created by Joao Pedro Giaretta on 11/03/26.
//

import XCTest
@testable import AulaXcTeste

@MainActor
final class ContactsTests: XCTestCase {

    func test_getUsers_sucess() async {
        
        // given (dado que...)
        // subject under test
        let sut = UsersViewModel(remote: MockUserRemoteSucess())
        
        // when (quando...)
        await sut.getUsers()
        
        // then (então...) Assert
        XCTAssertFalse(sut.users.isEmpty)
        XCTAssertEqual(sut.viewState, .success)
    }
    
    func test_getUsers_sucessEmpty() async {
        
        // given (dado que...)
        // subject under test
        let sut = UsersViewModel(remote: MockUserRemoteSucessEmpty())
        
        // when (quando...)
        await sut.getUsers()
        
        // then (então...) Assert
        XCTAssertTrue(sut.users.isEmpty)
        XCTAssertEqual(sut.viewState, .empty)
    }
    
    func test_getUsers_error() async {
        // given
        let sut = UsersViewModel(remote: MockUserRemoteError())
        
        // when
        await sut.getUsers()
        
        // then
        XCTAssertEqual(sut.viewState, .error, "Não causou erro na view")
    }
    
    func test_filterUsers_foundItems() async {
        let sut = UsersViewModel(remote: MockUserRemoteSucess())
        
        await sut.getUsers()
        sut.filterUsers("brit")
        
        XCTAssertEqual(sut.viewState, .success)
        XCTAssertFalse(sut.filteredUsers.isEmpty)
    }
    
    func test_filterUsers_notFound() async {
        let sut = UsersViewModel(remote: MockUserRemoteSucess())
        
        await sut.getUsers()
        sut.filterUsers("xxxxx")
        
        XCTAssertEqual(sut.viewState, .empty)
        XCTAssertTrue(sut.filteredUsers.isEmpty)
    }

    func test_filterUsers_emptyQuery() async {
        let sut = UsersViewModel(remote: MockUserRemoteSucess())
        
        await sut.getUsers()
        sut.filterUsers("")
        
        XCTAssertEqual(sut.viewState, .success)
        XCTAssertEqual(sut.filteredUsers.count, sut.users.count)
    }

}
