//
//  AulaXcTesteApp.swift
//  AulaXcTeste
//
//  Created by Joao Pedro Giaretta on 11/03/26.
//

import SwiftUI

@main
struct AulaXcTesteApp: App {
    var body: some Scene {
        WindowGroup {
            
            let isUITesting = ProcessInfo.processInfo.arguments.contains("UITesting")
            let remote: UserRemoteProtocol = isUITesting ? MockUserRemoteSucess(): UserRemote()
            
            ContentView(remote: remote)
        }
    }
}
