//
//  AuthTests.swift
//  GameStopTests
//
//  Created by Joao Pedro Giaretta on 27/03/26.
//

import XCTest
@testable import GameStop

@MainActor
final class AuthTests: XCTestCase {
    
    func test_login_fail() async {
        let sut = AuthViewModel()
        
        await MainActor.run {
            sut.login(username: "xxxx", password: "xxxxx")
        }
        
        await MainActor.run {
            XCTAssertFalse(sut.isLoggedIn)
        }
    }

    func test_login_sucess() async {
        let sut = AuthViewModel()
        
        await MainActor.run {
            sut.login(username: "joao", password: "joao123")
        }
        
        await MainActor.run {
            XCTAssertTrue(sut.isLoggedIn)
        }
    }
    
    
    func test_logout() async {
        let sut = AuthViewModel()
        
        await MainActor.run {
            sut.logout()
        }
        
        await MainActor.run {
            XCTAssertFalse(sut.isLoggedIn)
        }
    }

}
