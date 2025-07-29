//
//  ContentView.swift
//  MoneyPlan
//
//  Created by Paula Arroyo on 25/7/25.
//

import SwiftUI

// pantalla de bienvenida
// campos: welcome to, logo, login, register

extension Color { //esto se puede usar en todos los files del proyecto porque ya los he definido aquí
    static let moneyPlanGreen = Color(red: 66/255, green: 119/255, blue: 71/255) // #427747
    static let moneyPlanLight = Color(red: 220/255, green: 230/255, blue: 210/255) // color claro de los botones
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.moneyPlanGreen
                    .ignoresSafeArea()
                
                VStack(spacing: 25) {
                    Text("WELCOME TO")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(.moneyPlanLight)
                        .kerning(6)
                        .padding(.top, 50)
               
                    
                    Image("moneyLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 500, height: 500)
                    
                    VStack(spacing: 12) {
                        NavigationLink(destination: LoginView()) {
                            Text("LOG IN")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.moneyPlanGreen)
                                .frame(maxWidth: 360)
                                .padding(.vertical, 16)
                                .background(Color.moneyPlanLight)
                                .cornerRadius(25)
                        }

                        NavigationLink(destination: RegisterView()) {
                            Text("REGISTER")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.moneyPlanGreen)
                                .frame(maxWidth: 360)
                                .padding(.vertical, 16)
                                .background(Color.moneyPlanLight)
                                .cornerRadius(25)
                        }
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                }
            }
        }
    }
}
