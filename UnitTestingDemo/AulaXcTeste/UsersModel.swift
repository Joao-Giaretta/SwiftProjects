//
//  UsersModel.swift
//  AulaXcTeste
//
//  Created by Joao Pedro Giaretta on 11/03/26.
//

import Foundation

struct UsersResponse: Codable {
    let users: [User]
}

struct User: Codable, Identifiable {
    let id: Int?
    let firstName: String
    let lastName: String
    let phone: String
    let image: String
}


