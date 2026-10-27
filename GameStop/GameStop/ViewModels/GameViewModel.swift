//
//  GameViewModel.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 16/03/26.
//

import Combine
import SwiftUI
import Foundation
import CoreData

enum ViewState: Equatable {
    case loading
    case empty
    case loaded
    case error(message: String)
}

class GameViewModel: ObservableObject {
    let remote: RemoteProtocol
    let wishlistRepo: WishlistProtocol
    
    var games: [Game] = []
    
    @Published var wishlistedGames: [Game] = []
    @Published var filteredGames: [Game] = []
    @Published var viewState: ViewState = .loading
    @Published var wishlistViewState: ViewState = .loading
    
    init(remote: RemoteProtocol, userId: String, wishlistRemote: WishlistProtocol) {
        self.remote = remote
        self.wishlistRepo = wishlistRemote
    }
    
    // MARK: - Filtrar Games
    func filterGames(_ query: String) {
        if query.isEmpty {
            filteredGames = games
        } else {
            filteredGames = games.filter({ game in
                "\(game.name)".lowercased().contains(query.lowercased())
            })
        }
        
        viewState = filteredGames.isEmpty ? .empty : .loaded
    }
    
    // MARK: - GET
    func getGames() async {
        viewState = .loading
        
        do {
            games = try await remote.getGames()
            filteredGames = games
            
            if filteredGames.isEmpty {
                viewState = .empty
            } else {
                viewState = .loaded
            }
        } catch NetworkError.invalidURL {
            viewState = .error(message: "Erro na URL")
        } catch NetworkError.invalidResponse {
            viewState = .error(message: "Resposta Inválida")
        } catch NetworkError.httpError(code: let code) {
            viewState = .error(message: "Erro de servidor código \(code)")
        } catch DecodingError.valueNotFound,
                DecodingError.dataCorrupted,
                DecodingError.typeMismatch,
                DecodingError.keyNotFound {
            viewState = .error(message: "Erro de decodificação")
        } catch {
            viewState = .error(message: "Erro Desconhecido")
        }
    }
    
    // MARK: - Fetch Wishlist (CoreData)
    func fetchWishlistedGames() {
        wishlistedGames = wishlistRepo.fetchWishlistedGames()
        wishlistViewState = wishlistedGames.isEmpty ? .empty : .loaded
    }

}
