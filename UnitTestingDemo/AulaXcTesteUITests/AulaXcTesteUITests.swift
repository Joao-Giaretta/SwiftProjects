//
//  AulaXcTesteUITests.swift
//  AulaXcTesteUITests
//
//  Created by Joao Pedro Giaretta on 11/03/26.
//

import XCTest

final class AulaXcTesteUITests: XCTestCase {
    
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launchArguments.append("UITesting")

    }
    
    @MainActor
    func test_search_foundItems() throws {
        app.activate()
        
        let searchBar = app.textFields["Buscar Contatos"].firstMatch
        XCTAssertTrue(searchBar.exists)
        searchBar.tap()
        searchBar.typeText("brit")
        
        let brit = app.staticTexts["Britney Spears"].firstMatch
        XCTAssertTrue(brit.exists)
        
    }
    
    @MainActor
    func test_search_notFound() throws {
        app.activate()
        
        let searchBar = app.textFields["Buscar Contatos"].firstMatch
        XCTAssertTrue(searchBar.exists)
        searchBar.tap()
        searchBar.typeText("xxx")
        
        let emptyText = app.staticTexts["Nenhum contato encontrado"].firstMatch
        XCTAssertTrue(emptyText.exists, "Texto de conteudo vazio não encontrado")
        
    }
}
