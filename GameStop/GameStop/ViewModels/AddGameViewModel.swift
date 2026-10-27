//
//  AddGameViewModel.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 23/03/26.
//

import SwiftUI
import Foundation
import Combine

class AddGameViewModel: ObservableObject {
    
    private let remote: RemoteProtocol
    
    // MARK: - Campos do formulário
    @Published var name = ""
    @Published var developer = ""
    @Published var price = ""
    @Published var description = ""
    @Published var platform = "PS5"
    @Published var genre = ""
    @Published var ageRating = "Livre"
    @Published var mediaType = "Mídia Física"
    @Published var imageURL = ""
    
    // MARK: - Estado
    @Published var viewState: ViewState = .loaded
    @Published var showSuccess = false
    @Published var errorMessage = ""
    
    // MARK: - Opções dos pickers
    let platforms = ["PS5", "Xbox Series X/S", "Nintendo Switch", "PC"]
    let ageRatings = ["Livre", "10+", "14+", "16+", "18+"]
    let mediaTypes = ["Mídia Física", "Mídia Digital"]
    
    // MARK: - Validação
    var isFormValid: Bool {
        !name.isEmpty &&
        !developer.isEmpty &&
        !genre.isEmpty &&
        Double(price) != nil
    }
    
    init(remote: RemoteProtocol) {
        self.remote = remote
    }
    
    // MARK: - POST
    func addGame() async {
        guard isFormValid else { return }
        
        await MainActor.run { viewState = .loading }
        
        let newGame = Game(
            id: UUID().uuidString,
            developer: developer,
            name: name,
            price: Double(price) ?? 0,
            mediaType: mediaType,
            gameDescription: description,
            imageURL: imageURL,
            specs: Specs(
                platform: platform,
                genre: genre,
                ageRating: ageRating
            )
        )
        
        do {
            try await remote.postGame(newGame)
            await MainActor.run {
                viewState = .loaded
                showSuccess = true
                clearForm()
            }
        } catch NetworkError.invalidURL {
            await MainActor.run { viewState = .error(message: "URL inválida") }
        } catch NetworkError.invalidResponse {
            await MainActor.run { viewState = .error(message: "Resposta inválida") }
        } catch NetworkError.httpError(let code) {
            await MainActor.run { viewState = .error(message: "Erro do servidor: \(code)") }
        } catch {
            await MainActor.run { viewState = .error(message: "Erro desconhecido") }
        }
    }
    
    // MARK: - Limpar formulário
    private func clearForm() {
        name = ""
        developer = ""
        price = ""
        description = ""
        genre = ""
        imageURL = ""
        platform = "PS5"
        ageRating = "Livre"
        mediaType = "Mídia Física"
    }
}
