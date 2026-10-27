//
//  SplashScreenView.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 28/03/26.
//

import SwiftUI

struct SplashScreenView<Destination: View>: View {
    
    let destination: () -> Destination
    
    @State private var scale: CGFloat = 0.7
    @State private var opacity: Double = 0
    @State private var textOpacity: Double = 0
    @State private var isFinished = false
    
    init(@ViewBuilder destination: @escaping () -> Destination) {
        self.destination = destination
    }
    
    var body: some View {
        if isFinished {
            destination()
        } else {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.15))
                            .frame(width: 120, height: 120)
                        
                        Circle()
                            .stroke(Color.green.opacity(0.3), lineWidth: 1.5)
                            .frame(width: 150, height: 150)
                        
                        Image(systemName: "gamecontroller.fill")
                            .font(.system(size: 56))
                            .foregroundStyle(.green)
                    }
                    .scaleEffect(scale)
                    .opacity(opacity)
                    
                    VStack(spacing: 4) {
                        Text("GameStop")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundStyle(.white)
                        
                        Text("A diversão começa aqui")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    .opacity(textOpacity)
                }
            }
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    scale = 1.0
                    opacity = 1.0
                }
                
                withAnimation(.easeIn(duration: 0.4).delay(0.3)) {
                    textOpacity = 1.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation(.easeOut(duration: 0.4)) {
                        isFinished = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView {
        LoginView()
    }
}
