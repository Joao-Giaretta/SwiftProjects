//
//  WishlistedView.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 20/03/26.
//

import SwiftUI

struct WishlistedView: View {
    
    @EnvironmentObject var viewModel: GameViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var isPresentingSheet = false
        
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                VStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.15))
                            .frame(width: 72, height: 72)
                        Image(systemName: "heart.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(.green)
                    }
                    Text("Lista de Desejos")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    Text("Seu Sonho a um Clique de Distância")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 8)
                .padding(.bottom, 16)
                
                switch viewModel.wishlistViewState {
                case .loading:
                    ProgressView()
                    
                case .empty:
                    GameOverView()
                        .padding(50)
                    
                case .loaded:
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.wishlistedGames) { game in
                            GameCardView(
                                game: game,
                                userId: authViewModel.currentUser,
                                isWishlisted: true,
                                onWishlistToggle: {
                                    viewModel.fetchWishlistedGames()
                                },
                                isPresentingSheet: $isPresentingSheet
                            )
                            .frame(maxHeight: .infinity)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    
                case .error(let message):
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(.red)
                        Text(message)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Tentar novamente") {
                            viewModel.fetchWishlistedGames()
                        }
                        .foregroundStyle(.green)
                    }
                    .padding(.top, 40)
                }
            }
            .animation(.none, value: viewModel.wishlistViewState)
            .background(Color(.systemBackground))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isPresentingSheet.toggle()
                    } label: {
                        Image(systemName: "cart.fill")
                            .foregroundStyle(.green)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchWishlistedGames()
        }
        .sheet(isPresented: $isPresentingSheet) {
            CartView(isPresenting: $isPresentingSheet, userId: authViewModel.currentUser)
        }
    }
}

#Preview {
    let auth = AuthViewModel()
    auth.currentUser = "previewUser"
    return WishlistedView()
        .environmentObject(auth)
        .environmentObject(GameViewModel(remote: RemoteRepositoryErrorMock(), userId: auth.currentUser, wishlistRemote: WishlistRepository(userId: auth.currentUser)))}
