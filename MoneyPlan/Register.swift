//
//  Register.swift
//  MoneyPlan
//
//  Created by Paula Arroyo on 25/7/25.
//

import SwiftUI

// pantalla de registro de usuario
// campos: username, password, confirmPassword, mail y tipo de usuario
// go! --> MainContainerView()
// forgotten password? --> mail de recuperación

struct RegisterView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var email = ""
    @State private var userType = "Standard"
    @State private var showUserInfo = false
    @State private var navigateToAdd = false
    @State private var errorMessage = ""

    let userTypes = ["Standard", "Premium"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.moneyPlanGreen.ignoresSafeArea()

                VStack(spacing: 30) {
                    Spacer().frame(height: 20)

                    Text("REGISTER")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundColor(.moneyPlanLight)
                        .kerning(6)
                        .padding(.bottom, 10)

                    VStack(alignment: .leading, spacing: 16) {
                        Group {
                            Text("UserName:")
                                .foregroundColor(.moneyPlanLight)
                            TextField("", text: $username)
                                .padding(.horizontal)
                                .frame(height: 50)
                                .background(Color.white)
                                .cornerRadius(30)
                        }

                        Group {
                            Text("Password:")
                                .foregroundColor(.moneyPlanLight)
                            SecureField("", text: $password)
                                .padding(.horizontal)
                                .frame(height: 50)
                                .background(Color.white)
                                .cornerRadius(30)
                        }

                        Group {
                            Text("Confirm Password:")
                                .foregroundColor(.moneyPlanLight)
                            SecureField("", text: $confirmPassword)
                                .padding(.horizontal)
                                .frame(height: 50)
                                .background(Color.white)
                                .cornerRadius(30)
                        }

                        Group {
                            Text("Mail:")
                                .foregroundColor(.moneyPlanLight)
                            TextField("", text: $email)
                                .padding(.horizontal)
                                .frame(height: 50)
                                .background(Color.white)
                                .cornerRadius(30)
                        }

                        Group {
                            HStack {
                                Text("Type of User:")
                                    .foregroundColor(.moneyPlanLight)
                                Button(action: {
                                    showUserInfo.toggle()
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.moneyPlanLight)
                                }
                                .alert(isPresented: $showUserInfo) {
                                    Alert(title: Text("Tipos de Usuario"),
                                          message: Text("""
                                          • Standard: Usuario normal con funciones básicas.
                                          • Premium: Acceso a herramientas avanzadas.
                                          """),
                                          dismissButton: .default(Text("Entendido")))
                                }
                            }

                            Picker("Type of User", selection: $userType) {
                                ForEach(userTypes, id: \.self) { Text($0) }
                            }
                            .pickerStyle(.menu)
                            .frame(maxWidth: .infinity, minHeight: 45, maxHeight: 45)
                            .padding(.horizontal)
                            .background(Color.white)
                            .cornerRadius(30)
                            .foregroundColor(.moneyPlanGreen)
                        }
                    }
                    .padding(.horizontal, 40)

                    Button(action: register) {
                        Text("GO!")
                            .font(.headline)
                            .foregroundColor(.moneyPlanGreen)
                            .padding(.vertical, 10)
                            .padding(.horizontal, 40)
                            .background(Color.moneyPlanLight)
                            .cornerRadius(30)
                    }

                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }

                    Spacer()
                }
            }
            .navigationDestination(isPresented: $navigateToAdd) {
                MainContainerView()
            }
        }
    }

    func register() {
        guard password == confirmPassword else {
            errorMessage = "Las contraseñas no coinciden."
            return
        }

        Task {
            do {
                // 1. Registro en Supabase Auth
                let cleanEmail = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

                let response = try await SupabaseManager.shared.client.auth.signUp(
                    email: cleanEmail,
                    password: password
                )

                let userId = response.user.id


                do {
                    let insertResponse = try await SupabaseManager.shared.client
                        .from("users")
                        .insert([
                            "id": userId.uuidString,
                            "username": username,
                            "email": cleanEmail,
                            "user_type": userType
                        ])
                        .execute()

                    print("Insert response: \(insertResponse)")
                    
                } catch {
                    errorMessage = "Error al insertar en la tabla users: \(error.localizedDescription)"
                }

                // 3. Éxito → Navegar
                errorMessage = ""
                navigateToAdd = true

            } catch {
                errorMessage = "Error: \(error.localizedDescription)"
            }
        }
    }
}
