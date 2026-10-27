//
//  GameStopUITests.swift
//  GameStopUITests
//
//  Created by Joao Pedro Giaretta on 16/03/26.
//

import XCTest

final class GameStopUITests: XCTestCase {

    let app = XCUIApplication()
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app.launchArguments = ["UITesting"]
    }
    
    @MainActor
    func test_searchGame() throws {
        app.launch()
        
        // Faz login com usuário mock
//        let usernameField = app.textFields["Usuário"]
//        XCTAssertTrue(usernameField.waitForExistence(timeout: 5))
//        usernameField.tap()
//        usernameField.typeText("admin")
//        
//        let passwordField = app.secureTextFields["Senha"]
//        passwordField.tap()
//        passwordField.typeText("admin123")
//        
//        app.buttons["Entrar"].tap()
        
        // Aguarda a HomeView carregar
        let searchField = app.textFields["Buscar Jogos"]
        XCTAssertTrue(searchField.waitForExistence(timeout: 10))
        
        // Busca o jogo do mock
        searchField.tap()
        searchField.typeText("Hollow")
        
        // Verifica se o jogo aparece
        let gameCard = app.staticTexts["Hollow Knight: Silksong"]
        XCTAssertTrue(gameCard.waitForExistence(timeout: 3))
    }
    
}
