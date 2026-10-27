//
//  GameDetailsView.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 23/03/26.
//

import SwiftUI

struct GameDetailsView: View {
    
    @StateObject private var viewModel: GameCardViewModel
    @Binding var isPresentingSheet: Bool
    @State var isPresentingAlert: Bool = false
    
    init(game: Game, userId: String, isPresentingSheet: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: GameCardViewModel(game: game, userId: userId, wishlistRemote: WishlistRepository(userId: userId), cartRemote: CartRepository(userId: userId)))
        _isPresentingSheet = isPresentingSheet
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    AsyncImage(url: URL(string: viewModel.game.imageURL)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ZStack {
                            Color(.systemGray5)
                            Image(systemName: "photo.trianglebadge.exclamationmark")
                                .font(.system(size: 40))
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 380)
                    .clipped()
                    
                    LinearGradient(
                        colors: [.clear, .black.opacity(0.8)],
                        startPoint: .center,
                        endPoint: .bottom
                    )
                    .frame(height: 380)
                                        
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Spacer()
                            Text(viewModel.game.name)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.white)
                            
                            Text("R$ \(viewModel.game.price, specifier: "%.2f")")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.green)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(16)
                        
                        VStack(alignment: .trailing) {
                            Spacer()
                            Button {
                                viewModel.toggleWishlist()
                            } label: {
                                Image(systemName: viewModel.isWishlisted ? "heart.fill" : "heart")
                                    .foregroundStyle(viewModel.isWishlisted ? .red : .white)
                                    .padding(16)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                                    .shadow(radius: 4)
                            }
                            .padding(16)
                        }

                    }
                }
                .frame(height: 380)
                
                // MARK: - Badges
                HStack(spacing: 8) {
                    BadgeView(text: viewModel.game.specs.platform, color: plataformColor(viewModel.game.specs.platform))
                    BadgeView(text: viewModel.game.specs.genre, color: .purple)
                    BadgeView(text: viewModel.game.specs.ageRating, color: ageRatingColor(viewModel.game.specs.ageRating))
                    BadgeView(text: viewModel.game.mediaType, color: .gray)
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                
                HStack(spacing: 6) {
                    Image(systemName: "person.crop.square")
                        .foregroundStyle(.secondary)
                    Text(viewModel.game.developer)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Sobre o jogo")
                        .font(.headline)
                        .foregroundStyle(.primary)
                    
                    Text(viewModel.game.gameDescription)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineSpacing(4)
                }
                .padding(16)
                
                Spacer()
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(Color(.systemBackground))
        .overlay(alignment: .bottom) {
            VStack(spacing: 10) {
                Button {
                    debugLog("Comprar \(viewModel.game.name)")
                    isPresentingAlert.toggle()
                } label: {
                    Text("Comprar agora")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Button {
                    viewModel.toggleCart()
                } label: {
                    HStack {
                        Image(systemName: viewModel.isAddedToCart ? "checkmark" : "cart.badge.plus")
                        Text(viewModel.isAddedToCart ? "Adicionado!" : "Adicionar ao carrinho")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(.systemGray4))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            .background(
                LinearGradient(
                    colors: [.black.opacity(0), .black],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .alert("Prosseguir para a compra", isPresented: $isPresentingAlert) {
                Button("Cancelar", role: .cancel) {}
                Button("Sim") {
                    viewModel.toggleCart()
                    isPresentingSheet.toggle()
                }
            } message: {
                Text("Deseja prosseguir com a compra?")
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Cor do badge por faixa etária
    func ageRatingColor(_ rating: String) -> Color {
        switch rating.uppercased() {
        case "LIVRE": return .green
        case "10+": return .blue
        case "14+": return .orange
        case "16+": return .red
        case "18+": return .black
        default: return .gray
        }
    }
    
    // MARK: - Cor do badge por plataforma
    func plataformColor(_ rating: String) -> Color {
        switch rating.uppercased() {
        case "PS5": return .blue
        case "PC": return .orange
        case "NINTENDO SWITCH": return .red
        case "XBOX SERIES X/S": return .green
        default: return .gray
        }
    }
}

// MARK: - BadgeView
struct BadgeView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.caption2)
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.8))
            .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}

#Preview {
    GameDetailsView(
        game: Game(
            id: "a1b2c3d4-e5f6-4a5b-6c7d-8e9f0a1b2c3d",
            developer: "Rockstar Games",
            name: "Grand Theft Auto VI",
            price: 349.9,
            mediaType: "MÃ­dia FÃ­sica",
            gameDescription: "O jogo mais aguardado da dÃ©cada. Retorne ao estado de Leonida e explore as ruas de Vice City em uma experiÃªncia de mundo aberto sem precedentes.",
            imageURL: "https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/062fceab-dd60-438b-adb7-88f55526ae36/dgjcfhc-e482dd58-808c-47df-8a66-b3b08f8f264a.jpg/v1/fill/w_789,h_1013,q_70,strp/gta_vi_ps5_cover_ii_by_domestrialization_dgjcfhc-pre.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTMxNCIsInBhdGgiOiIvZi8wNjJmY2VhYi1kZDYwLTQzOGItYWRiNy04OGY1NTUyNmFlMzYvZGdqY2ZoYy1lNDgyZGQ1OC04MDhjLTQ3ZGYtOGE2Ni1iM2IwOGY4ZjI2NGEuanBnIiwid2lkdGgiOiI8PTEwMjQifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.KzwHtyAhhSgj7O6f4o_dpX6qcYdTzywg77VBFr12AZA",
            specs: Specs(platform: "PS5", genre: "AÃ§Ã£o / Mundo Aberto", ageRating: "18+")
        ),
        userId: "previewUser",
        isPresentingSheet: .constant(false)
    )
}

