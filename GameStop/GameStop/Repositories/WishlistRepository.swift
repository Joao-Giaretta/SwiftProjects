//
//  WishlistRepository.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 20/03/26.
//

import CoreData
import Foundation

protocol WishlistProtocol {
    func add(game: Game)
    func delete(id: String)
    func fetchWishlistedGames() -> [Game]
    func isWishlisted(id: String) -> Bool
    func toggle(game: Game)
}

class WishlistRepository: WishlistProtocol {
    
    let context = CoreDataStack.shared.context
    let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    // MARK: - SAVE
    func save() {
        CoreDataStack.shared.save()
    }
    
    // MARK: - ADD
    func add(game: Game) {
        guard !isWishlisted(id: game.id) else {
            debugLog("Jogo já está na wishlist")
            return
        }
        
        let newWishlistedGame = GameFavEntity(context: context)
        newWishlistedGame.id = game.id
        newWishlistedGame.userId = userId
        newWishlistedGame.name = game.name
        newWishlistedGame.gameDescription = game.gameDescription
        newWishlistedGame.ageRating = game.specs.ageRating
        newWishlistedGame.developer = game.developer
        newWishlistedGame.genre = game.specs.genre
        newWishlistedGame.imageUrl = game.imageURL
        newWishlistedGame.mediaType = game.mediaType
        newWishlistedGame.platform = game.specs.platform
        newWishlistedGame.price = game.price
        
        debugLog("Adicionado à wishlist: \(game.name)")
        save()
    }
    
    // MARK: - DELETE
    func delete(id: String) {
        let request = NSFetchRequest<GameFavEntity>(entityName: "GameFavEntity")
        request.predicate = NSPredicate(format: "userId == %@ AND id == %@", userId, id)
        do {
            let entities = try context.fetch(request)
            if let entity = entities.first {
                context.delete(entity)
                debugLog("Removido da wishlist")
                save()
            }
        } catch {
            debugLog("❌ Erro ao deletar da wishlist: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Fetch
    func fetchWishlistedGames() -> [Game] {
        let request = NSFetchRequest<GameFavEntity>(entityName: "GameFavEntity")
        request.predicate = NSPredicate(format: "userId == %@", userId)
        
        do {
            let entities = try context.fetch(request)
            return entities.map { converter(entity: $0) }
        } catch {
            debugLog("❌ Erro no fetch da wishlist: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - IS WISHLISTED
    func isWishlisted(id: String) -> Bool {
        let request = NSFetchRequest<GameFavEntity>(entityName: "GameFavEntity")
        request.predicate = NSPredicate(format: "userId == %@ AND id == %@", userId, id)
        request.fetchLimit = 1
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            debugLog("❌ Erro ao verificar wishlist: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - TOGGLE
    func toggle(game: Game) {
        if isWishlisted(id: game.id) {
            delete(id: game.id)
        } else {
            add(game: game)
        }
    }
    
    // MARK: - Converter
    func converter(entity: GameFavEntity) -> Game {
        Game(
            id: entity.id ?? "",
            developer: entity.developer ?? "",
            name: entity.name ?? "",
            price: entity.price,
            mediaType: entity.mediaType ?? "",
            gameDescription: entity.gameDescription ?? "",
            imageURL: entity.imageUrl ?? "",
            specs: Specs(
                platform: entity.platform ?? "",
                genre: entity.genre ?? "",
                ageRating: entity.ageRating ?? ""
            ),
            isWishlisted: true
        )
    }
}

class WishlistFetchSuccessMock: WishlistProtocol {
    var games = [Game(id: "1", developer: "teste", name: "teste", price: 10, mediaType: "teste", gameDescription: "teste", imageURL: "", specs: Specs(platform: "", genre: "", ageRating: ""))]
    
    func add(game: Game) {
        
    }
    
    func delete(id: String) {
        
    }
    
    func fetchWishlistedGames() -> [Game] {
        return games
    }
    
    func isWishlisted(id: String) -> Bool {
        return true
    }
    
    func toggle(game: Game) {
        
    }
}

class WishlistAddMock : WishlistProtocol {
    var games: [Game] = []
    
    func add(game: Game) {
        games.append(game)
    }
    
    func delete(id: String) {}
    
    func fetchWishlistedGames() -> [Game] {
        return games
    }
    
    func isWishlisted(id: String) -> Bool {
        return games.contains(where: {$0.id == id})
    }
    
    func toggle(game: Game) {
        if isWishlisted(id: game.id) {
            delete(id: game.id)
        } else {
            add(game: game)
        }
    }
}

class WishlistDeleteMock : WishlistProtocol {
    
    var games = [Game(id: "1", developer: "teste", name: "teste", price: 10, mediaType: "teste", gameDescription: "teste", imageURL: "", specs: Specs(platform: "", genre: "", ageRating: ""))]
    
    func add(game: Game) {}
    
    func delete(id: String) {
        if let index = games.firstIndex(where: { $0.id == id }) {
            games.remove(at: index)
        }
    }
    
    func fetchWishlistedGames() -> [Game] {
        return games
    }
    
    func isWishlisted(id: String) -> Bool {
        return games.contains(where: { $0.id == id })
    }
    
    func toggle(game: Game) {
        if isWishlisted(id: game.id) {
            delete(id: game.id)
        } else {
            add(game: game)
        }
    }
    
}


