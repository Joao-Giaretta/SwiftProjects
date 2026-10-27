//
//  GameStopApp.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 16/03/26.
//

import SwiftUI

@main
struct GameStopApp: App {
    
    @StateObject var authViewModel = AuthViewModel()
    @StateObject var themeManager = ThemeManager()
    
    var isTesting: Bool {
        ProcessInfo.processInfo.arguments.contains("UITesting")
    }
    
    var remoteRepo: RemoteProtocol {
        isTesting ? RemoteRepositoryMockSuccess() : RemoteRepository()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView {
                if authViewModel.isLoggedIn {
                    MainTabView()
                        .environmentObject(authViewModel)
                        .environmentObject(GameViewModel(remote: remoteRepo, userId: authViewModel.currentUser, wishlistRemote: WishlistRepository(userId: authViewModel.currentUser)))
                        .environmentObject(themeManager)
                        .preferredColorScheme(themeManager.colorScheme)
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                        .environmentObject(themeManager)
                        .preferredColorScheme(themeManager.colorScheme)
                }
            }
        }
    }
}
