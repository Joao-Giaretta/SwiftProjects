//
//  CartView.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 20/03/26.
//

import SwiftUI

struct CartView: View {
    
    @Binding var isPresenting: Bool
    let userId: String

    @EnvironmentObject var viewModel: GameViewModel
    @StateObject var cartViewModel: CartViewModel
    
    @State var isPresentingConfirmAlert = false
    @State var isPresentingSuccessAlert = false
    
    init(isPresenting: Binding<Bool>, userId: String) {
        _isPresenting = isPresenting
        self.userId = userId
        _cartViewModel = StateObject(wrappedValue: CartViewModel(cartRemote: CartRepository(userId: userId)))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // MARK: - Lista de itens
                if cartViewModel.cartGames.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "cart.badge.minus")
                            .font(.system(size: 60))
                            .foregroundStyle(.secondary)
                        Text("Seu carrinho está vazio")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach($cartViewModel.cartGames) { $item in
                            CartItemView(item: $item)
                                .listRowBackground(Color(.secondarySystemBackground))
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
                        }
                        .onDelete { indexSet in
                            cartViewModel.removeItems(at: indexSet)
                        }
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
                
                // MARK: - Rodapé
                if !cartViewModel.cartGames.isEmpty {
                    VStack(spacing: 12) {
                        Divider()
                        
                        // Resumo de preços
                        VStack(spacing: 8) {
                            HStack {
                                Text("Subtotal (\(cartViewModel.totalItems) \(cartViewModel.totalItems == 1 ? "item" : "itens"))")
                                    .foregroundStyle(.secondary)
                                Spacer()
                                Text("R$ \(cartViewModel.subtotal, specifier: "%.2f")")
                                    .foregroundStyle(.primary)
                            }
                                                        
                            Divider()
                            
                            HStack {
                                Text("Total")
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Text("R$ \(cartViewModel.subtotal, specifier: "%.2f")")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.green)
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        // Botão Checkout
                        Button {
                            isPresentingConfirmAlert.toggle()
                        } label: {
                            Text("Finalizar Compra")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(.black)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 14)
                                .background(.green)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                    }
                    .background(Color(.systemBackground))
                }
            }
            .background(Color(.systemBackground))
            .navigationTitle("🛒 Carrinho")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Fechar") {
                        isPresenting.toggle()
                    }
                    .foregroundStyle(.green)
                }
                
                if !cartViewModel.cartGames.isEmpty {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Limpar") {
                            cartViewModel.clearCart()
                        }
                        .foregroundStyle(.red)
                    }
                }
            }
            .alert("Confirmar Pagamento", isPresented: $isPresentingConfirmAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Pagar R$ \(cartViewModel.subtotal, specifier: "%.2f")") {
                    cartViewModel.checkout()
                    isPresentingSuccessAlert.toggle()
                }
            } message: {
                Text("Deseja confirmar a compra de \(cartViewModel.totalItems) \(cartViewModel.totalItems == 1 ? "item" : "itens")?")
            }
            .alert("Compra Realizada! 🎮", isPresented: $isPresentingSuccessAlert) {
                Button("OK") {
                    isPresenting.toggle()
                }
            } message: {
                Text("Seu pagamento foi processado com sucesso. Bons jogos!")
            }
        }
        .onAppear {
            cartViewModel.fetchCart()
        }
    }
}

// MARK: - CartItemView
struct CartItemView: View {
    
    @Binding var item: CartItem
    
    var body: some View {
        HStack(spacing: 12) {
            
            AsyncImage(url: URL(string: item.game.imageURL)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color(.systemGray5)
                Image(systemName: "photo.trianglebadge.exclamationmark")
                    .font(.system(size: 40))
            }
            .frame(width: 70, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 4) {
                Text(item.game.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                Text(item.game.specs.platform)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text("R$ \(item.game.price * Double(item.quantity), specifier: "%.2f")")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.green)
            }
            
            Spacer()
            
            // Seletor de quantidade
            HStack(spacing: 8) {
                Button {
                    if item.quantity > 1 { item.quantity -= 1 }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .foregroundStyle(item.quantity > 1 ? .green : .gray)
                        .font(.title3)
                }
                .buttonStyle(.borderless)
                
                Text("\(item.quantity)")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                    .frame(minWidth: 20)
                
                Button {
                    item.quantity += 1
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundStyle(.green)
                        .font(.title3)
                }
                .buttonStyle(.borderless)
            }
        }
        .padding(12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

