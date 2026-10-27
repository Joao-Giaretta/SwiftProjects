//
//  AddGameView.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 20/03/26.
//

import SwiftUI

struct AddGameView: View {
    
    @StateObject private var viewModel = AddGameViewModel(remote: RemoteRepository())
    @FocusState private var focusedField: FormFieldType?
    
    enum FormFieldType: Hashable {
        case name, developer, genre, description, price, imageUrl
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(.systemBackground), Color.green.opacity(0.05)],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        
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
                            Text("Anunciar Jogo")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundStyle(.primary)
                            Text("Preencha os dados do jogo que deseja anunciar")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 28)
                        
                        // MARK: - Seção: Informações Básicas
                        Header(title: "Informações Básicas", icon: "info.circle.fill")
                        
                        VStack(spacing: 12) {
                            StyledField(
                                title: "Nome do Jogo",
                                placeholder: "Ex: God of War",
                                text: $viewModel.name,
                                icon: "tag.fill",
                                isFocused: focusedField == .name
                            )
                            .focused($focusedField, equals: .name)
                            
                            StyledField(
                                title: "Desenvolvedor",
                                placeholder: "Ex: Santa Monica Studio",
                                text: $viewModel.developer,
                                icon: "person.fill",
                                isFocused: focusedField == .developer
                            )
                            .focused($focusedField, equals: .developer)
                            
                            StyledField(
                                title: "Gênero",
                                placeholder: "Ex: Ação / Aventura",
                                text: $viewModel.genre,
                                icon: "square.grid.2x2.fill",
                                isFocused: focusedField == .genre
                            )
                            .focused($focusedField, equals: .genre)
                            
                            // Preço
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 6) {
                                    Image(systemName: "brazilianrealsign")
                                        .font(.caption)
                                        .foregroundStyle(.green)
                                    Text("Preço")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.gray)
                                }
                                HStack(spacing: 10) {
                                    Text("R$")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.green)
                                    TextField("0,00", text: $viewModel.price)
                                        .keyboardType(.decimalPad)
                                        .foregroundStyle(.primary)
                                        .focused($focusedField, equals: .price)
                                }
                                .padding(12)
                                .background(Color(.systemGray6))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(
                                            focusedField == .price ? Color.green : Color.green.opacity(0.2),
                                            lineWidth: focusedField == .price ? 1.5 : 1
                                        )
                                )
                            }
                            
                            // Descrição
                            VStack(alignment: .leading, spacing: 6) {
                                HStack(spacing: 6) {
                                    Image(systemName: "text.alignleft")
                                        .font(.caption)
                                        .foregroundStyle(.green)
                                    Text("Descrição")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.secondary)
                                }
                                TextField("Descreva o jogo...", text: $viewModel.description, axis: .vertical)
                                    .lineLimit(3...6)
                                    .foregroundStyle(.primary)
                                    .focused($focusedField, equals: .description)
                                    .padding(12)
                                    .background(Color(.systemGray6))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(
                                                focusedField == .description ? Color.green : Color.green.opacity(0.2),
                                                lineWidth: focusedField == .description ? 1.5 : 1
                                            )
                                    )
                                StyledField(
                                    title: "URL Imagem",
                                    placeholder: "http://imagem.com",
                                    text: $viewModel.imageURL,
                                    icon: "photo",
                                    isFocused: focusedField == .imageUrl
                                )
                                .focused($focusedField, equals: .imageUrl)
                            }
                        }
                        .padding(.bottom, 24)
                        
                        
                        // MARK: - Seção: Especificações
                        Header(title: "Especificações", icon: "slider.horizontal.3")
                        
                        VStack(spacing: 12) {
                            StyledPicker(
                                title: "Plataforma",
                                icon: "desktopcomputer",
                                selection: $viewModel.platform,
                                options: viewModel.platforms
                            )
                            StyledPicker(
                                title: "Classificação Etária",
                                icon: "person.badge.shield.checkmark",
                                selection: $viewModel.ageRating,
                                options: viewModel.ageRatings
                            )
                            StyledPicker(
                                title: "Tipo de Mídia",
                                icon: "opticaldisc",
                                selection: $viewModel.mediaType,
                                options: viewModel.mediaTypes
                            )
                        }
                        .padding(.bottom, 32)
                        
                        // MARK: - Botão
                        Button {
                            focusedField = nil
                            Task { await viewModel.addGame() }
                        } label: {
                            Group {
                                if case .loading = viewModel.viewState {
                                    HStack(spacing: 10) {
                                        ProgressView().tint(.black)
                                        Text("Anunciando...").fontWeight(.bold).foregroundStyle(.black)
                                    }
                                } else {
                                    HStack(spacing: 8) {
                                        Image(systemName: "plus.circle.fill")
                                        Text("Anunciar Jogo").fontWeight(.bold)
                                    }
                                    .foregroundStyle(viewModel.isFormValid ? .black : .gray)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                viewModel.isFormValid
                                    ? Color.green
                                    : Color(.systemGray5)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .shadow(
                                color: viewModel.isFormValid ? Color.green.opacity(0.4) : .clear,
                                radius: 12, x: 0, y: 4
                            )
                        }
                        .disabled(!viewModel.isFormValid || {
                            if case .loading = viewModel.viewState { return true }
                            return false
                        }())
                        .animation(.easeInOut(duration: 0.2), value: viewModel.isFormValid)
                        .padding(.bottom, 32)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .alert("Jogo Anunciado! 🎮", isPresented: $viewModel.showSuccess) {
                Button("OK") { }
            } message: {
                Text("\(viewModel.name) foi adicionado com sucesso!")
            }
            .alert("Erro", isPresented: .init(
                get: { if case .error = viewModel.viewState { return true }; return false },
                set: { _ in viewModel.viewState = .loaded }
            )) {
                Button("OK") { }
            } message: {
                if case .error(let message) = viewModel.viewState {
                    Text(message)
                }
            }
        }
    }
}

// MARK: - Header
struct Header: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(.green)
            Text(title.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .foregroundStyle(.green)
            Rectangle()
                .fill(Color.green.opacity(0.3))
                .frame(height: 1)
        }
        .padding(.bottom, 12)
    }
}

// MARK: - StyledField
struct StyledField: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    let icon: String
    let isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(.green)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }
            TextField(placeholder, text: $text)
                .foregroundStyle(.primary)
                .padding(12)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            isFocused ? Color.green : Color.green.opacity(0.2),
                            lineWidth: isFocused ? 1.5 : 1
                        )
                )
                .animation(.easeInOut(duration: 0.15), value: isFocused)
        }
    }
}

// MARK: - StyledPicker
struct StyledPicker: View {
    let title: String
    let icon: String
    @Binding var selection: String
    let options: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                    .foregroundStyle(.green)
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
            }
            Picker(title, selection: $selection) {
                ForEach(options, id: \.self) { option in
                    Text(option).tag(option)
                }
            }
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.green.opacity(0.2), lineWidth: 1)
            )
            .tint(.green)
        }
    }
}

#Preview {
    AddGameView()
}
