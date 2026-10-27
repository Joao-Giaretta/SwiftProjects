//
//  SettingsView.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 20/03/26.
//

import SwiftUI

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.15))
                        .frame(width: 72, height: 72)
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 32))
                        .foregroundStyle(.green)
                }
                Text("Configurações")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
            }
            .padding(.top, 8)
            .padding(.bottom, 4)

            List {
                Section {
                    HStack(spacing: 12) {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.2))
                                .frame(width: 44, height: 44)
                            Text(authViewModel.currentUser.prefix(1).uppercased())
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(.green)
                        }
                        VStack(alignment: .leading) {
                            Text(authViewModel.currentUser.capitalized)
                                .fontWeight(.semibold)
                                .foregroundStyle(.primary)
                            Text("Usuário mock")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
                
                Section("Aparência") {
                    HStack {
                        Image(systemName: themeManager.isDarkMode ? "moon.fill" : "sun.max.fill")
                            .foregroundStyle(themeManager.isDarkMode ? .indigo : .orange)
                            .frame(width: 28)
                        
                        Text(themeManager.isDarkMode ? "Modo Escuro" : "Modo Claro")
                        
                        Spacer()
                        
                        Toggle("", isOn: $themeManager.isDarkMode)
                            .tint(.green)
                    }
                }
                
                Section("Conta") {
                    Button(role: .destructive) {
                        authViewModel.logout()
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Sair da conta")
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AuthViewModel())
        .environmentObject(ThemeManager())
}
