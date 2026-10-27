//
//  GameOverView.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 16/03/26.
//

import SwiftUI

struct GameOverView: View {
    
    @State private var scale = 0.8
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("🎮")
                .font(.system(size: 80))
                .scaleEffect(scale)
                .onAppear {
                    withAnimation(
                        .easeInOut(duration: 1)
                        .repeatForever(autoreverses: true)
                    ) {
                        scale = 1.1
                    }
                }
            
            Text("Game Over")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Nenhum jogo encontrado")
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    GameOverView()
}
