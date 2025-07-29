//
//  Add.swift
//  MoneyPlan
//
//  Created by Paula Arroyo on 25/7/25.
//

import SwiftUI

//pantalla de añadir gasto o ingreso

extension Color {
    static let peach = Color(red: 1.0, green: 0.3, blue: 0.4)
    static let lime = Color(red: 0.7, green: 1.0, blue: 0.0)
}

enum FormType {
    case ingreso, gasto, ninguno
}

struct AddView: View {
    @State private var selectedForm: FormType = .ninguno
    @State private var categoriaSeleccionada = "Salario"
    @State private var nombre = ""
    @State private var cantidad = ""
    @State private var mostrarAlerta = false
    @State private var mensajeAlerta = ""

    
    let categorias = ["Salario", "Premio", "Regalo", "Alquiler", "Comida", "Ocio"]
    
    var formularioCompleto: Bool {
        return !categoriaSeleccionada.isEmpty &&
               !nombre.trimmingCharacters(in: .whitespaces).isEmpty &&
               !cantidad.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ZStack{
            Color.moneyPlanGreen.ignoresSafeArea()
            VStack(spacing: 20) {
                
                Image("moneyLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .padding(.bottom, 10)
                
                HStack(spacing: 20) {
                    Button(action: {
                        selectedForm = .ingreso
                    }) {
                        HStack {
                            Circle()
                                .fill(Color.lime)
                                .frame(width: 40, height: 40)
                                .overlay(Text("+").foregroundColor(Color.moneyPlanGreen).bold())
                            
                            Text("INGRESO")
                                .foregroundColor(Color.moneyPlanGreen)
                                .font(.title3).bold()
                                .padding()
                                .background(Color.lime)
                                .cornerRadius(30)
                        }
                    }
                    
                    Button(action: {
                        selectedForm = .gasto
                    }) {
                        HStack {
                            Circle()
                                .fill(Color.peach)
                                .frame(width: 40, height: 40)
                                .overlay(Text("-").foregroundColor(.white).bold())
                            
                            Text("GASTO")
                                .foregroundColor(Color.moneyPlanLight)
                                .font(.title3).bold()
                                .padding()
                                .background(Color.peach)
                                .cornerRadius(30)
                        }
                    }
                }
                
                if selectedForm != .ninguno {
                    VStack(spacing: 15) {
                        Text(selectedForm == .ingreso ? "INGRESO" : "GASTO")
                            .font(.title)
                            .bold()
                            .foregroundColor(.white)
                        
                        // CATEGORÍA (Picker)
                        Picker("Categoría", selection: $categoriaSeleccionada) {
                            ForEach(categorias, id: \.self) { cat in
                                Text(cat)
                            }
                        }
                        .pickerStyle(.menu)
                        .padding()
                        .frame(width: 340, height: 50)
                        .background(selectedForm == .ingreso ? Color.lime : Color.peach)
                        .cornerRadius(25)
                        .foregroundColor(.black)
                        .font(.headline)
                        
                        // NOMBRE
                        TextField("Nombre", text: $nombre)
                            .padding()
                            .frame(width: 340, height: 50)
                            .background(selectedForm == .ingreso ? Color.lime : Color.peach)
                            .cornerRadius(25)
                            .foregroundColor(.black)
                            .font(.headline)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                        
                        // CANTIDAD (solo numérico)
                        TextField("Cantidad €", text: $cantidad)
                            .keyboardType(.decimalPad)
                            .padding()
                            .frame(width: 340, height: 50)
                            .background(selectedForm == .ingreso ? Color.lime : Color.peach)
                            .cornerRadius(25)
                            .foregroundColor(.black)
                            .font(.headline)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                        
                        Button(action: {
                            if formularioCompleto {
                                    print("Añadido \(selectedForm == .ingreso ? "Ingreso" : "Gasto")")
                                    print("Categoría: \(categoriaSeleccionada)")
                                    print("Nombre: \(nombre)")
                                    print("Cantidad: \(cantidad)")
                                    
                                    mensajeAlerta = "\(selectedForm == .ingreso ? "Ingreso" : "Gasto") añadido correctamente"
                                        
                                    
                                    // Aquí podrías guardar y resetear:
                                    nombre = ""
                                    cantidad = ""
                                    //selectedForm = .ninguno // opcional, vuelve al inicio
                                } else {
                                    mensajeAlerta = "Por favor, completa todos los campos antes de continuar."
                                }
                                mostrarAlerta = true
                        }) {
                            Text("AÑADIR")
                                .font(.headline)
                                .bold()
                                .foregroundColor(Color.moneyPlanGreen)
                                .frame(width: 140, height: 40)
                                .background(Color.moneyPlanLight)
                                .cornerRadius(25)
                                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                                .padding(.top, 10)
                        }
                        .alert(isPresented: $mostrarAlerta) {
                            Alert(
                                title: Text(mensajeAlerta),
                                dismissButton: .default(Text("OK"))
                            )
                        }
                    }
                    .padding(.top, 30)
                }
                
                Spacer()
            }
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct CustomField: View {
    let placeholder: String
    @Binding var text: String
    var color: Color

    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .frame(height: 50)
            .background(color)
            .cornerRadius(25)
            .foregroundColor(.black)
            .font(.headline)
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
    }
}
