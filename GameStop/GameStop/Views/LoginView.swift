//
//  LoginView.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 25/03/26.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var username = ""
    @State private var password = ""
    @State private var showPassword = false
    @FocusState private var focusedField: LoginField?
    
    enum LoginField { case username, password }
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color.green.opacity(0.08)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                Spacer()
                
                // MARK: - Logo
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.15))
                            .frame(width: 90, height: 90)
                        Image(systemName: "gamecontroller.fill")
                            .font(.system(size: 40))
                            .foregroundStyle(.green)
                    }
                    Text("GameStop")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundStyle(.white)
                    Text("Faça login para continuar")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
                
                // MARK: - Campos
                VStack(spacing: 12) {
                    // Username
                    HStack(spacing: 10) {
                        Image(systemName: "person.fill")
                            .foregroundStyle(.green)
                            .frame(width: 20)
                        TextField("Usuário", text: $username)
                            .foregroundStyle(.primary)
                            .autocorrectionDisabled()
                            .textInputAutocapitalization(.never)
                            .focused($focusedField, equals: .username)
                    }
                    .padding(14)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                focusedField == .username ? Color.green : Color.green.opacity(0.2),
                                lineWidth: 1.5
                            )
                    )
                    
                    // Password
                    HStack(spacing: 10) {
                        Image(systemName: "lock.fill")
                            .foregroundStyle(.green)
                            .frame(width: 20)
                        Group {
                            if showPassword {
                                TextField("Senha", text: $password)
                            } else {
                                SecureField("Senha", text: $password)
                            }
                        }
                        .foregroundStyle(.primary)
                        .focused($focusedField, equals: .password)
                        
                        Button {
                            showPassword.toggle()
                        } label: {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(14)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                focusedField == .password ? Color.green : Color.green.opacity(0.2),
                                lineWidth: 1.5
                            )
                    )
                    
                    // Erro
                    if !viewModel.errorMessage.isEmpty {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundStyle(.red)
                                .font(.caption)
                            Text(viewModel.errorMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.horizontal, 24)
                
                // MARK: - Botão Login
                Button {
                    focusedField = nil
                    viewModel.login(username: username, password: password)
                } label: {
                    Text("Entrar")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            username.isEmpty || password.isEmpty ? Color.gray : Color.green
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(
                            color: username.isEmpty || password.isEmpty ? .clear : Color.green.opacity(0.4),
                            radius: 10, x: 0, y: 4
                        )
                }
                .disabled(username.isEmpty || password.isEmpty)
                .padding(.horizontal, 24)
                .animation(.easeInOut(duration: 0.2), value: username.isEmpty || password.isEmpty)
                
                // Hint dos usuários mock
                VStack(spacing: 4) {
                    Text("Usuários disponíveis:")
                        .font(.caption2)
                        .foregroundStyle(.gray)
                    Text("admin / joao / maria")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.green.opacity(0.7))
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthViewModel())
}
