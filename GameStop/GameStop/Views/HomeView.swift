//
//  ContentView.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 16/03/26.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var viewModel: GameViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State var query = ""
    @State var isPresentingSheet = false
    @State var refreshToken = UUID()

    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                // MARK: - Header
                VStack(spacing: 6) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.15))
                            .frame(width: 72, height: 72)
                        Image(systemName: "gamecontroller.fill")
                            .font(.system(size: 32))
                            .foregroundStyle(.green)
                    }
                    Text("GameStop")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(.primary)
                    Text("A diversão começa aqui")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 8)
                .padding(.bottom, 4)
                
                Section {
                    TextField("Buscar Jogos", text: $query)
                        .onChange(of: query) { oldValue, newValue in
                            viewModel.filterGames(newValue)
                        }
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color(.systemGray5))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(query.isEmpty ? Color.clear : Color.green, lineWidth: 1.5)
                        )
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                }
                
                switch viewModel.viewState {
                case .loading:
                    ProgressView()
                        .padding(.top, 40)
                case .empty:
                    GameOverView()
                case .loaded:
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(viewModel.filteredGames) { game in
                            GameCardView(
                                game: game,
                                userId: authViewModel.currentUser,
                                isPresentingSheet: $isPresentingSheet
                            )
                            .frame(maxHeight: .infinity)
                            .id("\(game.id)-\(refreshToken)")
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                case .error(let message):
                    VStack(spacing: 20) {
                        Spacer()
                        
                        ZStack {
                            Circle()
                                .fill(Color.red.opacity(0.15))
                                .frame(width: 80, height: 80)
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.system(size: 36))
                                .foregroundStyle(.red)
                        }
                        
                        VStack(spacing: 8) {
                            Text("Algo deu errado")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                            Text(message)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        
                        Button {
                            Task { await viewModel.getGames() }
                        } label: {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.clockwise")
                                Text("Tentar novamente")
                                    .fontWeight(.semibold)
                            }
                            .foregroundStyle(.black)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(.green)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 40)
                }
            }
            .onAppear {
                refreshToken = UUID()
            }
            .sheet(isPresented: $isPresentingSheet, onDismiss: {
                refreshToken = UUID()
            }) {
                CartView(isPresenting: $isPresentingSheet, userId: authViewModel.currentUser)
            }
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
        .task {
            await viewModel.getGames()
        }

    }
}

#Preview {
    let auth = AuthViewModel()
    auth.currentUser = "previewUser"
    return HomeView()
        .environmentObject(auth)
        .environmentObject(GameViewModel(remote: RemoteRepositoryErrorMock(), userId: auth.currentUser, wishlistRemote: WishlistRepository(userId: auth.currentUser)))
}
