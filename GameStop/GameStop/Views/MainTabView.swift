//
//  MainTabView.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 20/03/26.
//

import SwiftUI

struct MainTabView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var gameViewModel: GameViewModel
    
    var body: some View {
        TabView {
            
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                }
                .tag(0)
                        
            WishlistedView()
                .tabItem {
                    Image(systemName: "heart.fill")
                }
                .tag(3)

            AddGameView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                }
                .tag(4)
        }
        .tint(.green)
    }
}

#Preview {
    // Para preview, criamos os objetos necessários.
    let auth = AuthViewModel()
    auth.currentUser = "previewUser"
    return MainTabView()
        .environmentObject(auth)
        .environmentObject(
            GameViewModel(
                remote: RemoteRepository(),
                userId: auth.currentUser,
                wishlistRemote: WishlistRepository(userId: auth.currentUser)
            )
        )
}
