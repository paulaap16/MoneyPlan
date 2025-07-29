//
//  Login.swift
//  MoneyPlan
//
//  Created by Paula Arroyo on 25/7/25.
//

import SwiftUI

// pantalla de login
// campos: Login, logo, mail y password
// go! --> MainContainerView()

struct LoginView: View {
    @State private var mail = ""
    @State private var password = ""
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var errorMessage = ""
    @State private var isLoading = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.moneyPlanGreen
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    Spacer().frame(height: 40)

                    Text("LOG IN")
                        .font(.system(size: 30, weight: .medium))
                        .foregroundColor(.moneyPlanLight)
                        .kerning(5)
                        .padding(.top, 35)

                    Image("moneyLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 318, height: 318)
                        .padding(.top, 18)

                    VStack(alignment: .leading, spacing: 10) {
                        Group {
                            Text("Mail:")
                                .foregroundColor(.moneyPlanLight)
                            TextField("", text: $mail)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .cornerRadius(30)
                                .foregroundColor(.black)
                        }

                        Group {
                            Text("Password:")
                                .foregroundColor(.moneyPlanLight)
                            SecureField("", text: $password)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .cornerRadius(30)
                                .foregroundColor(.black)
                        }
                    }
                    .padding(.horizontal, 40)

                    Button(action: login) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .frame(width: 100, height: 40)
                        } else {
                            Text("GO!")
                                .font(.headline)
                                .foregroundColor(.moneyPlanGreen)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 40)
                                .background(Color.moneyPlanLight)
                                .cornerRadius(30)
                        }
                    }
                    .disabled(isLoading)
                    .padding(.top, 5)

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    Button("Forgotten Password?") {
                        recoverPassword()
                    }
                    .font(.footnote)
                    .foregroundColor(.cyan)
                    .padding(.bottom, 30)

                    Spacer()
                }
            }
        
            }
        }

    // MARK: - Función de login
    func login() {
        isLoading = true
        errorMessage = ""

        Task {
            do {
                let cleanEmail = mail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                let session = try await SupabaseManager.shared.client.auth
                    .signIn(email: cleanEmail, password: password)
                
                // Si llega aquí, es que ha iniciado sesión bien
                isLoggedIn = true

            } catch {
                errorMessage = "Error: \(error.localizedDescription)"
            }

            isLoading = false
        }
    }

    // MARK: - Función de recuperación de contraseña
    func recoverPassword() {
        guard !mail.isEmpty else {
            errorMessage = "Introduce tu email para recuperar la contraseña."
            return
        }

        Task {
            do {
                try await SupabaseManager.shared.client.auth
                    .resetPasswordForEmail(mail)
                errorMessage = "📩 Revisa tu email para cambiar tu contraseña."
            } catch {
                errorMessage = "Error: \(error.localizedDescription)"
            }
        }
    }
}
