//
//  ContentView.swift
//  AulaXcTeste
//
//  Created by Joao Pedro Giaretta on 11/03/26.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel: UsersViewModel
    @State var query = ""
    
    init(remote: UserRemoteProtocol) {
        _viewModel = StateObject(wrappedValue: UsersViewModel(remote: remote))
    }
    
    var body: some View {
        List {
            Section {
                TextField("Buscar Contatos", text: $query)
                    .onChange(of: query) { oldValue, newValue in
                        viewModel.filterUsers(newValue)
                    }
            }
            
            switch viewModel.viewState {
            case .success:
                successView
            case .error:
                Text("Erro!")
                    .font(.largeTitle)
                    .bold()
            case .empty:
                Text("Nenhum contato encontrado")
                    .font(.largeTitle)
                    .bold()
            case .loading:
                ProgressView()
            }

        }
        .task {
            await viewModel.getUsers()
        }
    }
    
    var successView: some View {
        Section("Contatos") {
            ForEach(viewModel.filteredUsers) { user in
                makeUserCell(user)
            }
        }

    }
    
    func makeUserCell(_ user: User) -> some View {
        HStack {
            if let url = URL(string: user.image) {
                AsyncImage(url: url)
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
            }
            
            VStack(alignment: .leading) {
                Text("\(user.firstName) \(user.lastName)")
                    .font(.headline)
                Text(user.phone)
                    .font(.subheadline)
            }
        }
    }
}

#Preview {
    ContentView(remote: MockUserRemoteSucess())
}
