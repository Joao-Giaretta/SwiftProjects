//
//  RemoteRepository.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 16/03/26.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(code: Int)
}

protocol RemoteProtocol {
    func getGames() async throws -> [Game]
    func postGame(_ game: Game) async throws
}

class RemoteRepository: RemoteProtocol {
    /// Mock API (mockapi.io) used as the games backend.
    private static let gamesEndpoint = "https://69b07034c63dd197febc4844.mockapi.io/agidevs/games"

    // MARK: - GET
    func getGames() async throws -> [Game] {
        guard let url = URL(string: Self.gamesEndpoint) else {
            debugLog("❌ URL INVÁLIDA")
            throw NetworkError.invalidURL
        }
        
        let (data, responseMetadata) = try await URLSession.shared.data(from: url)
        
        guard let response = responseMetadata as? HTTPURLResponse else {
            debugLog("❌ Invalid Response")
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(response.statusCode) else {
            debugLog("❌ Erro de servidor")
            throw NetworkError.httpError(code: response.statusCode)
        }
        
        let decoder = JSONDecoder()
        let games = try decoder.decode([Game].self, from: data)
        
        return games
    }
    
    // MARK: - POST
    func postGame(_ game: Game) async throws {
        guard let url = URL(string: Self.gamesEndpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(game)
        
        let (_, responseMetadata) = try await URLSession.shared.data(for: request)
        
        guard let response = responseMetadata as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(response.statusCode) else {
            throw NetworkError.httpError(code: response.statusCode)
        }
        
        debugLog("Jogo adicionado com sucesso")
    }}

class RemoteRepositoryMockSuccess: RemoteProtocol {
    func postGame(_ game: Game) async throws {
        
    }
    
    func getGames() async throws -> [Game] {
        return [
            Game(id: UUID().uuidString, developer: "Team Cherry", name: "Hollow Knight: Silksong", price: 60, mediaType: "Mídia Digital", gameDescription: "Discover a vast, haunted kingdom in Hollow Knight: Silksong! Explore, fight and survive as you ascend to the peak of a land ruled by silk and song.", imageURL: "https://upload.wikimedia.org/wikipedia/pt/8/86/Hollow_Knight_Silksong_cover.jpeg", specs: Specs(platform: "PC", genre: "Ação/Aventura", ageRating: "Livre"))
            ]
    }
}

class RemoteRepositoryErrorMock: RemoteProtocol {
    func postGame(_ game: Game) async throws {
        
    }
    
    func getGames() async throws -> [Game] {
        throw NetworkError.httpError(code: 404)
    }
}

class RemoteRepositoryMockSuccessEmpty: RemoteProtocol {
    func postGame(_ game: Game) async throws {
        
    }
    
    func getGames() async throws -> [Game] {
        return []
    }
}

class RemoteRepositoryPostSucess: RemoteProtocol {
    var games: [Game] = []
    
    func getGames() async throws -> [Game] {
        return games
    }
    
    func postGame(_ game: Game) async throws {
        games.append(game)
    }
}

class RemoteRepositoryPostError: RemoteProtocol {
    var games: [Game] = []
    
    func getGames() async throws -> [Game] {
        return games
    }
    
    func postGame(_ game: Game) async throws {
        throw NetworkError.invalidResponse
    }
    
    
}
