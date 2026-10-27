//
//  AuthViewModel.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 25/03/26.
//

import SwiftUI
import Combine

class AuthViewModel: ObservableObject {
    
    private let keychain = KeychainManager.shared
    
    @Published var isLoggedIn: Bool = false
    @Published var currentUser: String = ""
    @Published var errorMessage: String = ""
    
    private let validUsers: [String: String] = [
        "admin": "admin123",
        "joao": "joao123",
        "maria": "maria123"
    ]
    
    private let usernameKey = "gamestop_username"
    private let passwordKey = "gamestop_password"
    
    init() {
        checkSavedSession()
    }
    
    // MARK: - Verifica sessão salva
    private func checkSavedSession() {
        guard
            let savedUser = keychain.read(key: usernameKey),
            let savedPassword = keychain.read(key: passwordKey),
            validUsers[savedUser] == savedPassword
        else { return }
        
        currentUser = savedUser
        isLoggedIn = true
    }
    
    // MARK: - Login
    func login(username: String, password: String) {
        let user = username.lowercased().trimmingCharacters(in: .whitespaces)
        
        guard let validPassword = validUsers[user], validPassword == password else {
            errorMessage = "Usuário ou senha inválidos"
            return
        }
        
        keychain.save(key: usernameKey, value: user)
        keychain.save(key: passwordKey, value: password)
        
        currentUser = user
        errorMessage = ""
        
        withAnimation(.easeInOut) {
            isLoggedIn = true
        }
    }
    
    // MARK: - Logout
    func logout() {
        keychain.delete(key: usernameKey)
        keychain.delete(key: passwordKey)
        
        currentUser = ""
        
        withAnimation(.easeInOut) {
            isLoggedIn = false
        }
    }
}
