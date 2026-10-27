//
//  ContentView.swift
//  AtividadeSemanal3
//
//  Created by Joao Pedro Giaretta on 25/02/26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModel()
    
    @State var origem = ""
    @State var destino = ""
    @State var data: Date = Date()
    @State var isSomenteIda = false
    
    @State var isPresentigAlert = false
    @State var isFinish = false
    
    var body: some View {
        VStack {
            NavigationStack {
                VStack {
                    Image(systemName: "airplane.ticket")
                        .font(.system(size: 70))
                        .foregroundStyle(.white)
                        .padding()
                    Text("FindMyFly")
                        .font(.system(size: 40))
                        .foregroundStyle(.white)
                    Form {
                        Section("Origem:") {
                            Picker("Escolha uma Origem:", selection: $origem) {
                                ForEach(viewModel.origensUnicas, id: \.self) { origem in
                                    Text(origem)
                                        .tag(origem)
                                }
                            }
                            .foregroundStyle(.gray)
                        }
                        .foregroundStyle(.white)
                        Section("Destino:") {
                            Picker("Escolha um Destino:", selection: $destino) {
                                ForEach(viewModel.destinoUnicos, id: \.self) { destino in
                                    Text(destino)
                                }
                            }
                            .foregroundStyle(.gray)
                        }
                        .foregroundStyle(.white)
                        DatePicker("Dia:", selection: $data, displayedComponents: .date)
                        Toggle("Somente Ida", isOn: $isSomenteIda)
                    }
                    .background(Color.blue)
                    .scrollContentBackground(.hidden)
                    Button {
                        if origem == "" || destino == "" {
                            isPresentigAlert.toggle()
                        } else {
                            isFinish.toggle()
                        }
                    } label: {
                        Text("Prosseguir")
                            .foregroundStyle(.blue)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(16)
                    
                }
                .padding()
                .background(Color.blue)
                .navigationDestination(isPresented: $isFinish, destination: {
                    VoosView(origem: origem, destino: destino, isSomenteIda: isSomenteIda, viewModel: viewModel)
                })
            }
        }
        .alert("Selecione uma Origem e um Destino", isPresented: $isPresentigAlert) {
            Button("Fechar", role: .close) {}
        }
    }
}

#Preview {
    ContentView()
}
