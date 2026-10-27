//
//  VoosView.swift
//  AtividadeSemanal3
//
//  Created by Joao Pedro Giaretta on 26/02/26.
//

import SwiftUI

struct VoosView: View {
    
    let origem: String
    let destino: String
    let isSomenteIda: Bool
    @State var isPresentingSheet = false
    @ObservedObject var viewModel: ViewModel
    
    var voosFiltrados: [Voo] {
        viewModel.voos.filter {
            $0.origem == origem &&
            $0.destino == destino &&
            $0.isSomenteIda == isSomenteIda
        }
    }
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Image(systemName: "airplane.ticket")
                    .font(.system(size: 70))
                    .foregroundStyle(.white)
                    .padding()
                Text("FindMyFly")
                    .font(.system(size: 40))
                    .foregroundStyle(.white)
                HStack {
                    Text("Selecione seu voo:")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                    Spacer()
                }
            }
            .padding()
            if voosFiltrados.isEmpty {
                Text("Nenhum Voo Encontrado")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundStyle(.white)
                    .padding()
                Spacer()
            } else {
                ForEach(voosFiltrados) { voo in
                    Button {
                        viewModel.vooSelecionado = voo
                        isPresentingSheet.toggle()
                    } label: {
                        VooCard(voo: voo)
                    }
                }
                Spacer()
            }
        }
        .background(Color.blue)
        .sheet(isPresented: $isPresentingSheet) {
            BuySheetView(voo: viewModel.vooSelecionado!)
                .presentationDetents([.medium])
        }
    }
}

struct VooCard: View {
    
    let voo: Voo
    @State var isFlySelected = false
    
    var body: some View {
        HStack {
            VStack {
                HStack{
                    Text(voo.origem)
                    Spacer()
                    Image(systemName: "airplane.path.dotted")
                    Spacer()
                    Text(voo.destino)
                }
                HStack{
                    Text("R$: \(String(format: "%.2f", voo.valor))")
                    Spacer()
                    Text(voo.horario)
                }
            }
            Image(systemName: "chevron.right")
                .padding()
        }
        .foregroundStyle(.blue)
        .padding()
        .background(Color.white)
        .cornerRadius(30)
        .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
    }
}

#Preview {
    VoosView(origem: "São Paulo", destino: "Rio de Janeiro", isSomenteIda: true, viewModel: ViewModel())
}
