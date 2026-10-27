//
//  CartRepository.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 23/03/26.
//

import CoreData
import Foundation

protocol CartProtocol {
    func add(game: Game)
    func delete(id: String)
    func fetchGamesInCart() -> [Game]
    func isInCart(id: String) -> Bool
    func toggle(game: Game)
}

class CartRepository: CartProtocol {
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
        guard !isInCart(id: game.id) else {
            debugLog("Jogo já está no carrinho")
            return
        }
        
        let newGame = GameCartEntity(context: context)
        newGame.id = game.id
        newGame.userId = userId
        newGame.name = game.name
        newGame.gameDescription = game.gameDescription
        newGame.ageRating = game.specs.ageRating
        newGame.developer = game.developer
        newGame.genre = game.specs.genre
        newGame.imageUrl = game.imageURL
        newGame.mediaType = game.mediaType
        newGame.platform = game.specs.platform
        newGame.price = game.price
        
        debugLog("Adicionado ao carrinho: \(game.name)")
        save()
    }
    
    // MARK: - DELETE
    func delete(id: String) {
        let request = NSFetchRequest<GameCartEntity>(entityName: "GameCartEntity")
        request.predicate = NSPredicate(format: "userId == %@ AND id == %@", userId, id)
        
        do {
            let entities = try context.fetch(request)
            if let entity = entities.first {
                context.delete(entity)
                debugLog("Removido do carrinho")
                save()
            }
        } catch {
            debugLog("❌ Erro ao deletar do carrinho: \(error.localizedDescription)")
        }
    }

    // MARK: - Fetch
    func fetchGamesInCart() -> [Game] {
        let request = NSFetchRequest<GameCartEntity>(entityName: "GameCartEntity")
        request.predicate = NSPredicate(format: "userId == %@", userId)

        do {
            let entities = try context.fetch(request)
            return entities.map { converter(entity: $0) }
        } catch {
            debugLog("❌ Erro no fetch do carrinho: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - IS IN CART
    func isInCart(id: String) -> Bool {
        let request = NSFetchRequest<GameCartEntity>(entityName: "GameCartEntity")
        request.predicate = NSPredicate(format: "userId == %@ AND id == %@", userId, id)
        request.fetchLimit = 1
        
        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            debugLog("❌ Erro ao verificar carrinho: \(error.localizedDescription)")
            return false
        }
    }
    
    // MARK: - TOGGLE
    func toggle(game: Game) {
        if isInCart(id: game.id) {
            delete(id: game.id)
        } else {
            add(game: game)
        }
    }
    
    func converter(entity: GameCartEntity) -> Game {
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
            isAddedToCart: true
        )
    }
}

class CartAddMock: CartProtocol {
    var games: [Game] = []
    
    func add(game: Game) {
        games.append(game)
    }
    
    func delete(id: String) {}
    
    func fetchGamesInCart() -> [Game] {
        return games
    }
    
    func isInCart(id: String) -> Bool {
        return games.contains(where: {$0.id == id})
    }
    
    func toggle(game: Game) {
        if isInCart(id: game.id) {
            delete(id: game.id)
        } else {
            add(game: game)
        }
    }
}

class CartDeleteMock: CartProtocol {
    var games = [Game(id: "1", developer: "teste", name: "teste", price: 10, mediaType: "teste", gameDescription: "teste", imageURL: "", specs: Specs(platform: "", genre: "", ageRating: ""))]
    
    func add(game: Game) {}
    
    func delete(id: String) {
        if let index = games.firstIndex(where: { $0.id == id }) {
            games.remove(at: index)
        }
    }
    
    func fetchGamesInCart() -> [Game] {
        return games
    }
    
    func isInCart(id: String) -> Bool {
        return games.contains(where: {$0.id == id})
    }
    
    func toggle(game: Game) {
        if isInCart(id: game.id) {
            delete(id: game.id)
        } else {
            add(game: game)
        }
    }
}

class CartFetchSuccessMock: CartProtocol {
    
    var games = [Game(id: "1", developer: "teste", name: "teste", price: 10, mediaType: "teste", gameDescription: "teste", imageURL: "", specs: Specs(platform: "", genre: "", ageRating: "")),
                 Game(id: "2", developer: "teste", name: "teste", price: 10, mediaType: "teste", gameDescription: "teste", imageURL: "", specs: Specs(platform: "", genre: "", ageRating: "")),
                 Game(id: "3", developer: "teste", name: "teste", price: 10, mediaType: "teste", gameDescription: "teste", imageURL: "", specs: Specs(platform: "", genre: "", ageRating: ""))
    ]
    
    func add(game: Game) {
        
    }
    
    func delete(id: String) {
        
    }
    
    func fetchGamesInCart() -> [Game] {
        return games
    }
    
    func isInCart(id: String) -> Bool {
        return true
    }
    
    func toggle(game: Game) {
        
    }
    

}

class CartFetchEmptyMock: CartProtocol {
    
    var games: [Game] = []
    
    func add(game: Game) {
        
    }
    
    func delete(id: String) {
        if let index = games.firstIndex(where: { $0.id == id }) {
            games.remove(at: index)
        }
    }
    
    func fetchGamesInCart() -> [Game] {
        return games
    }
    
    func isInCart(id: String) -> Bool {
        return true
    }
    
    func toggle(game: Game) {
        
    }
}

class CartClearMock: CartProtocol {
    
    var games: [Game] = [Game(id: "1", developer: "teste", name: "teste", price: 10, mediaType: "teste", gameDescription: "teste", imageURL: "", specs: Specs(platform: "", genre: "", ageRating: "")),
                         Game(id: "2", developer: "teste", name: "teste", price: 10, mediaType: "teste", gameDescription: "teste", imageURL: "", specs: Specs(platform: "", genre: "", ageRating: "")),
                         Game(id: "3", developer: "teste", name: "teste", price: 10, mediaType: "teste", gameDescription: "teste", imageURL: "", specs: Specs(platform: "", genre: "", ageRating: ""))
            ]
    
    func add(game: Game) {
        
    }
    
    func delete(id: String) {
        if let index = games.firstIndex(where: { $0.id == id }) {
            games.remove(at: index)
        }
    }
    
    func fetchGamesInCart() -> [Game] {
        return games
    }
    
    func isInCart(id: String) -> Bool {
        return true
    }
    
    func toggle(game: Game) {
        
    }
}
