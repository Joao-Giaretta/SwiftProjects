//
//  CoreDataStack.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 20/03/26.
//

import CoreData
import Foundation

class CoreDataStack {
    
    // MARK: - Singleton
    static let shared = CoreDataStack()
    
    // MARK: - Container
    let container: NSPersistentContainer
    
    var context: NSManagedObjectContext {
        container.viewContext
    }
    
    // MARK: - Init
    private init() {
        container = NSPersistentContainer(name: "GameCoreData")
        container.viewContext.automaticallyMergesChangesFromParent = true // Garante que os dados são atualizados automaticamente quando alterados
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Erro ao carregar CoreData: \(error.localizedDescription)")
            } else {
                debugLog("CoreData carregado com sucesso")
            }
        }
    }
    
    // MARK: - Save
    func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            debugLog("❌ Erro ao salvar CoreData: \(error.localizedDescription)")
        }
    }
}

/// Logs only in DEBUG builds, so release builds stay quiet.
func debugLog(_ message: @autoclosure () -> String) {
    #if DEBUG
    print(message())
    #endif
}
