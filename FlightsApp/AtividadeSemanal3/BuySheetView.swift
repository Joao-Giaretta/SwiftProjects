//
//  BuySheetView.swift
//  AtividadeSemanal3
//
//  Created by Joao Pedro Giaretta on 26/02/26.
//

import SwiftUI

struct BuySheetView: View {
    
    @State var passagem: Passagem?
    
    let voo: Voo
    @State var nome = ""
    @State var cpf = ""
    @State var dataNascimento: Date = Date()
    
    @State var isPresentingAlert = false
    
    var body: some View {
        VStack {
            VooCard(voo: voo)
            VStack (alignment: .leading, spacing: 16) {
                Section("Nome:") {
                    TextField("Digite seu nome completo:", text: $nome)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke()
                        }
                }
                .foregroundStyle(.blue)
                Section("CPF:") {
                    TextField("Digite seu CPF:", text: $cpf)
                        .padding()
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .stroke()
                        }
                }
                .foregroundStyle(.blue)
                DatePicker("Data de Nascimento:", selection: $dataNascimento, displayedComponents: .date)
                    .foregroundStyle(.blue)
                    
            }
            .padding()
                        .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .stroke()
                    .foregroundStyle(.blue)
            }
            
            Spacer()
            
            Button {
                passagem = Passagem(nome: nome, cpf: cpf, dataNascimento: dataNascimento, voo: voo)
                isPresentingAlert.toggle()
            } label: {
                Image(systemName: "cart.fill")
                    .font(.system(size: 36))
            }
        }
        .padding(.horizontal, 16)
        .alert("Compra Bem Sucedida", isPresented: $isPresentingAlert) {
            Button("Fechar", role: .close) {}
        } message: {
                Text("Passagem:\nOrigem: \(passagem?.voo.origem ?? "") \nDestino: \(passagem?.voo.destino ?? "") \nValor: \(String(format: "%.2f", passagem?.voo.valor ?? 0.00)) ")
        }
    }
}

#Preview {
    BuySheetView(voo: Voo(origem: "São Paulo", destino: "Rio de Janeiro", valor: 340, horario: "08:00", isSomenteIda: true))
}
