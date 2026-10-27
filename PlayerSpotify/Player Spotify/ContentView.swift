//
//  ContentView.swift
//  Player Spotify
//
//  Created by Joao Pedro Giaretta on 18/02/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "chevron.down")
                Spacer()
                Text("From Zero, Linkin Park")
                Spacer()
                Image(systemName: "ellipsis")
            }
            
            Image(.albumCover)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 300, height: 350, alignment: .center)
                .cornerRadius(8)
                .padding(.vertical, 32)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Stained")
                        .font(.system(size: 32).bold())
                    Text("Linkin Park")
                }
                Spacer()
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.system(size: 32))
            }
            
            VStack {
                ProgressView(value: 0.3)
                    .background(Color.gray)
                    .tint(.white)
                
                HStack {
                    Text("0:50")
                        .font(.system(size: 14))
                    
                    Spacer()
                    
                    Text("3:07")
                        .font(.system(size: 14))
                }
            }
            .padding(.vertical, 16)
            
            HStack {
                Image(systemName: "shuffle")
                    .font(.system(size: 28))
                
                Spacer()
                
                HStack (spacing: 18){
                    Image(systemName: "backward.end.fill")
                        .font(.system(size: 28))
                    
                    Image(systemName: "pause.circle.fill")
                        .font(.system(size: 60))

                    Image(systemName: "forward.end.fill")
                        .font(.system(size: 28))
                }
                
                Spacer()
                
                Image(systemName: "repeat")
                    .font(.system(size: 28))
            }
            
            HStack {
                Image(systemName: "play.display")
                    .font(.system(size: 16))
                
                Spacer()
                
                HStack (spacing: 18){
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20))
                    
                    Image(systemName: "text.line.magnify")
                        .font(.system(size: 20))
                }
            }
            .padding(.vertical, 16)
            Spacer()
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 1.0, green: 0.25, blue: 0.65),
                    Color(red: 0.85, green: 0.0, blue: 0.5)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

#Preview {
    ContentView()
}
