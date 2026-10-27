//
//  UsersViewModel.swift
//  AulaXcTeste
//
//  Created by Joao Pedro Giaretta on 11/03/26.
//

import Combine
import Foundation

enum ViewState: Equatable {
    case success
    case error
    case empty
    case loading
}

class UsersViewModel: ObservableObject {
    
    var users: [User] = []
    
    @Published var filteredUsers: [User] = []
    @Published var viewState: ViewState = .loading
    
    let remote: UserRemoteProtocol
    
    init(remote: UserRemoteProtocol) {
        self.remote = remote
    }
    
    func getUsers() async {
        
        viewState = .loading
        
        do {
            users = try await remote.getUsers()
            filteredUsers = users
            
            if filteredUsers.isEmpty {
                viewState = .empty
            } else {
                viewState = .success
            }
        } catch  {
            viewState = .error
        }
    }
    
    func filterUsers(_ query: String) {
        if query.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter({ user in
                "\(user.firstName) \(user.lastName)".lowercased().contains(query.lowercased()) || user.phone.contains(query)
            })
        }
        
        if filteredUsers.isEmpty {
            viewState = .empty
        } else {
            viewState = .success
        }
    }
    
}
