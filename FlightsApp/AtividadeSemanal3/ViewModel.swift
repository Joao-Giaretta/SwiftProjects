//
//  ViewModel.swift
//  AtividadeSemanal3
//
//  Created by Joao Pedro Giaretta on 25/02/26.
//
import Combine
import SwiftUI

struct Voo: Identifiable {
    let id: UUID = UUID()
    let origem: String
    let destino: String
    let valor: Float
    let horario: String
    let isSomenteIda: Bool
}

struct Passagem {
    let nome: String
    let cpf: String
    let dataNascimento: Date
    let voo: Voo
}

class ViewModel: ObservableObject {
    
    @Published var vooSelecionado: Voo?

    @Published var voos: [Voo] = [
        Voo(origem: "São Paulo", destino: "Rio de Janeiro", valor: 340, horario: "08:00", isSomenteIda: true),
        Voo(origem: "São Paulo", destino: "Rio de Janeiro", valor: 380, horario: "11:20", isSomenteIda: true),
        Voo(origem: "São Paulo", destino: "Rio de Janeiro", valor: 410, horario: "18:45", isSomenteIda: false),
        
        Voo(origem: "Recife", destino: "Salvador", valor: 280, horario: "09:45", isSomenteIda: true),
        Voo(origem: "Recife", destino: "Salvador", valor: 320, horario: "15:30", isSomenteIda: true),
        Voo(origem: "Recife", destino: "Salvador", valor: 350, horario: "21:10", isSomenteIda: false),
        
        Voo(origem: "Brasília", destino: "Curitiba", valor: 420, horario: "07:00", isSomenteIda: true),
        Voo(origem: "Brasília", destino: "Curitiba", valor: 460, horario: "14:30", isSomenteIda: true),
        
        Voo(origem: "Fortaleza", destino: "São Paulo", valor: 510, horario: "06:15", isSomenteIda: false),
        Voo(origem: "Fortaleza", destino: "São Paulo", valor: 550, horario: "12:40", isSomenteIda: true),
        Voo(origem: "Fortaleza", destino: "São Paulo", valor: 600, horario: "19:55", isSomenteIda: false),
        
        Voo(origem: "Rio de Janeiro", destino: "Brasília", valor: 390, horario: "10:00", isSomenteIda: true),
        Voo(origem: "Rio de Janeiro", destino: "Brasília", valor: 430, horario: "17:25", isSomenteIda: false)
    ]
    
    var origensUnicas: [String] {
        Array(Set(voos.map { $0.origem })).sorted()
    }
    
    var destinoUnicos: [String] {
        Array(Set(voos.map { $0.destino })).sorted()
    }
    
    
}
