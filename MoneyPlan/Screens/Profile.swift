//
//  Profile.swift
//  MoneyPlan
//
//  Created by Paula Arroyo on 25/7/25.
//

import SwiftUI

struct ProfileView: View {
    @State private var selectedCurrency = "€"
    @State private var selectedLanguage = "Español"
    @State private var alertsEnabled = false
    @State private var remindersEnabled = true
    @State private var showExportInfo = false
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = true

    let currencies = ["€", "$", "£"]
    let languages = ["Español", "Inglés"]

    var body: some View {
        ZStack {
            Color.moneyPlanGreen.ignoresSafeArea()

            VStack(spacing: 22) {
                // Avatar y nombre
                VStack(spacing: 8) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                        .foregroundColor(Color.moneyPlanLight.opacity(0.8))

                    Text("Paula Arroyo")
                        .font(.title2.bold())
                        .foregroundColor(.moneyPlanLight)

                    Text("PREMIUM")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.6))
                }

            
                HStack {
                        StatCard(title: "Saldo", amount: "+1200", currency: selectedCurrency, color: Color(red: 155/255, green: 255/255, blue: 95/255))
                        StatCard(title: "Gastos", amount: "-450", currency: selectedCurrency, color: Color(red: 255/255, green: 85/255, blue: 85/255))
                        StatCard(title: "Ahorro", amount: "+750", currency: selectedCurrency, color: Color(red: 85/255, green: 200/255, blue: 255/255))
                }

                Divider().background(Color.white.opacity(0.5)).padding(.horizontal)

                // Preferencias
                VStack(spacing: 12) {
                    Text("Preferencias")
                        .font(.headline)
                        .foregroundColor(.moneyPlanLight)

                    HStack(spacing: 12) {
                        Menu {
                            ForEach(currencies, id: \.self) { currency in
                                Button(currency) { selectedCurrency = currency }
                            }
                        } label: {
                            Text("Divisa: \(selectedCurrency)")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 14)
                                .background(Color.white)
                                .cornerRadius(20)
                                .foregroundColor(.black)
                        }

                        Menu {
                            ForEach(languages, id: \.self) { lang in
                                Button(lang) { selectedLanguage = lang }
                            }
                        } label: {
                            Text("Idioma: \(selectedLanguage)")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 14)
                                .background(Color.white)
                                .cornerRadius(20)
                                .foregroundColor(.black)
                        }

                        Button(action: {
                            // Aquí irá la navegación a Mi Info (editar datos)
                        }) {
                            Text("Mi Info")
                                .padding(.vertical, 8)
                                .padding(.horizontal, 14)
                                .background(Color.white)
                                .cornerRadius(20)
                                .foregroundColor(.black)
                        }
                    }
                }
                Divider().background(Color.white.opacity(0.5)).padding(.horizontal)
                
                // Notificaciones
                VStack(spacing: 8) {
                    Text("Notificaciones")
                        .font(.headline)
                        .foregroundColor(.moneyPlanLight)

                    Toggle("Alertas de gasto excesivo", isOn: $alertsEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: .yellow))
                        .foregroundColor(.white)

                    Toggle("Recordatorios de ingreso", isOn: $remindersEnabled)
                        .toggleStyle(SwitchToggleStyle(tint: .yellow))
                        .foregroundColor(.white)
                }
                .padding(.horizontal)
                
                Divider().background(Color.white.opacity(0.5)).padding(.horizontal)

                HStack(spacing: 10) {
                    Button(action: {
                        // Acción de exportar datos
                    }) {
                        Text("Exportar Datos")
                            .font(.headline)
                            .foregroundColor(.moneyPlanGreen)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 80)
                            .background(Color.white.opacity(0.90))
                            .cornerRadius(12)
                    }

                    Button(action: {
                        showExportInfo.toggle()
                    }) {
                        Image(systemName: "info.circle")
                            .font(.title3)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .alert(isPresented: $showExportInfo) {
                        Alert(
                            title: Text("¿Qué hace Exportar Datos?"),
                            message: Text("Se generará un archivo con tus movimientos financieros para que puedas guardarlos o analizarlos."),
                            dismissButton: .default(Text("Entendido"))
                        )
                    }
                }
              
                Divider().background(Color.white.opacity(0.5)).padding(.horizontal)
                
                Button(action: {
                    Task {
                        do {
                            try await SupabaseManager.shared.client.auth.signOut()
                            isLoggedIn = false  // Esto redirigirá al LoginView desde ContentView
                        } catch {
                            print("Error al cerrar sesión: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Text("Cerrar Sesión")
                        .font(.headline)
                        .foregroundColor(.red)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 40)
                        .background(Color.moneyPlanLight.opacity(0.7))
                        .cornerRadius(20)
                }
                .padding(.top, 15)

                Spacer()
            }
            .padding(.top, 30)
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct StatCard: View {
    var title: String
    var amount: String
    var currency: String
    var color: Color

    var body: some View {
        VStack {
            Text(title)
                .font(.caption)
                .foregroundColor(.black)
            Text("\(amount)\(currency)")
                .font(.headline)
                .foregroundColor(.black)
        }
        .frame(width: 90, height: 60)
        .background(color.opacity(0.97))
        .cornerRadius(15)
    }
}
