//
//  GameCardView.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 18/03/26.
//

import SwiftUI

struct GameCardView: View {
    
    @StateObject var viewModel: GameCardViewModel
    
    @State var isPresentingAlert: Bool = false
    
    @Binding var isPresentingSheet: Bool
    
    init(game: Game,
         userId: String,
         isWishlisted: Bool? = nil,
         onWishlistToggle: (() -> Void)? = nil,
         isAddedToCart: Bool? = nil,
         onCartToggle: (() -> Void)? = nil,
         isPresentingSheet: Binding<Bool>) {
        _viewModel = StateObject(
            wrappedValue: GameCardViewModel(
                game: game,
                userId: userId,
                isWishlisted: isWishlisted,
                isAddedToCart: isAddedToCart,
                onWishlistToggle: onWishlistToggle,
                onCartToggle: onCartToggle,
                wishlistRemote: WishlistRepository(userId: userId),
                cartRemote: CartRepository(userId: userId)
            )
        )
        _isPresentingSheet = isPresentingSheet
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // MARK: - Imagem + Wishlist + Age Rating
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
                .frame(height: 140)
                .clipped()

                Button {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                        viewModel.toggleWishlist()
                    }
                } label: {
                    Image(systemName: viewModel.isWishlisted ? "heart.fill" : "heart")
                        .foregroundStyle(viewModel.isWishlisted ? .red : .white)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .shadow(radius: 4)
                }
                .padding(8)

                VStack {
                    Spacer()
                    HStack {
                        Text(viewModel.game.specs.ageRating)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .background(ageRatingColor(viewModel.game.specs.ageRating))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .padding(8)
                        Spacer()
                    }
                }
            }
            .frame(height: 140)

            // MARK: - Infos do jogo
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.game.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(viewModel.game.specs.platform)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text("R$ \(viewModel.game.price, specifier: "%.2f")")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.green)
                    .padding(.top, 2)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .frame(maxWidth: .infinity, minHeight: 80, alignment: .topLeading)

            // MARK: - Botões de ação
            VStack(spacing: 6) {
                Button {
                    debugLog("Comprar")
                    isPresentingAlert.toggle()
                } label: {
                    Text("Comprar")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 7)
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                HStack(spacing: 6) {
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                            viewModel.toggleCart()
                        }
                    } label: {
                        Image(systemName: viewModel.isAddedToCart ? "checkmark" : "cart.badge.plus")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                            .background(Color(.systemGray4))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        GameDetailsView(game: viewModel.game, userId: viewModel.userId, isPresentingSheet: $isPresentingSheet)
                    } label: {
                        Image(systemName: "info.circle")
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 7)
                            .background(Color(.systemGray4))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
        .contentShape(Rectangle())
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.4), radius: 6, x: 0, y: 4)
        .alert("Prosseguir para a compra", isPresented: $isPresentingAlert) {
            Button("Cancelar", role: .cancel) {}
            Button("Sim") {
                if viewModel.isAddedToCart {
                    isPresentingSheet.toggle()
                } else {
                    viewModel.toggleCart()
                    isPresentingSheet.toggle()
                }
            }
        } message: {
            Text("Deseja prosseguir com a compra?")
        }
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
}
