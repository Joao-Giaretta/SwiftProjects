//
//  ThemeManager.swift
//  GameStop
//
//  Created by Joao Pedro Giaretta on 28/03/26.
//

import SwiftUI
import Combine

class ThemeManager: ObservableObject {
    
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: "isDarkMode")
        }
    }
    
    init() {
        self.isDarkMode = UserDefaults.standard.object(forKey: "isDarkMode") as? Bool ?? true
    }
    
    var colorScheme: ColorScheme {
        isDarkMode ? .dark : .light
    }
}
