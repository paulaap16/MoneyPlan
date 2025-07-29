//
//  MoneyPlanApp.swift
//  MoneyPlan
//
//  Created by Paula Arroyo on 25/7/25.
//

import SwiftUI

@main
struct MoneyPlanApp: App {
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false

    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                MainContainerView() // Tu vista principal de la app
            } else {
                ContentView() // Pantalla de bienvenida
            }
        }
    }
}
