//
//  MainContainerView.swift
//  MoneyPlan
//
//  Created by Paula Arroyo on 25/7/25.
//

import SwiftUI

struct MainContainerView: View {
    @State private var selectedTab: Tab = .add

    var body: some View {
        ZStack(alignment: .bottom) {
            // Contenido de cada vista
            Group {
                switch selectedTab {
                case .add:
                    AddView()
                case .calendar:
                    CalendarView()
                case .graph:
                    GraphView()
                case .profile:
                    ProfileView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // Barra de navegación inferior
            CustomTabBar(selectedTab: $selectedTab)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}
