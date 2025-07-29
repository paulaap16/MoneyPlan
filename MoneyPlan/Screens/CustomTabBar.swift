//
//  CustomTabBar.swift
//  MoneyPlan
//
//  Created by Paula Arroyo on 25/7/25.
//

import SwiftUI

enum Tab {
    case add, calendar, graph, profile
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack {
            tabButton(icon: "plus.circle", tab: .add)
            tabButton(icon: "calendar", tab: .calendar)
            tabButton(icon: "chart.line.uptrend.xyaxis", tab: .graph)
            tabButton(icon: "person.crop.circle", tab: .profile)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 24)
        .background(Color.moneyPlanGreen)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .shadow(radius: 5)
    }
    
    private func tabButton(icon: String, tab: Tab) -> some View {
        Button(action: {
            selectedTab = tab
        }) {
            ZStack {
                if selectedTab == tab {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 50, height: 36)
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                }
                
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.4))
            }
        }
        .frame(maxWidth: .infinity)
        .ignoresSafeArea(.keyboard, edges: .bottom)

    }
}
