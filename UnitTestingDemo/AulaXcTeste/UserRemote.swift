//
//  UserRemote.swift
//  AulaXcTeste
//
//  Created by Joao Pedro Giaretta on 11/03/26.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case invalidResponse
    case httpError(stausCode: Int)
}

protocol UserRemoteProtocol {
    func getUsers() async throws -> [User]
}

class UserRemote: UserRemoteProtocol {
    
    func getUsers() async throws -> [User] {
        guard let url = URL(string: "https://dummyjson.com/users") else {
            throw NetworkError.invalidUrl
        }
        
        let (data, responseMetadata) = try await URLSession.shared.data(from: url)
        
        guard let response = responseMetadata as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard(200...299).contains(response.statusCode) else {
            throw NetworkError.httpError(stausCode: response.statusCode)
        }
        
        let decoder = JSONDecoder()
        
        let usersResponse = try decoder.decode(UsersResponse.self, from: data)
        
        return usersResponse.users
    }
}

class MockUserRemoteSucess: UserRemoteProtocol {
    func getUsers() async throws -> [User] {
        return [
            User(id: 0, firstName: "Britney", lastName: "Spears", phone: "99999-9999", image: ""),
            User(id: 1, firstName: "Taylor", lastName: "Swift", phone: "99999-9998", image: "")
        ]
    }
}

class MockUserRemoteError: UserRemoteProtocol {
    func getUsers() async throws -> [User] {
        throw NetworkError.invalidResponse
    }
}


class MockUserRemoteSucessEmpty: UserRemoteProtocol {
    func getUsers() async throws -> [User] {
        return []
    }
}
