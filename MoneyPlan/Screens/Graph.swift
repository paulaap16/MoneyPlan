//
//  Graph.swift
//  MoneyPlan
//
//  Created by Paula Arroyo on 25/7/25.
//

import SwiftUI
import Charts

struct GraphView: View {
    @State private var mesSeleccionado = Calendar.current.component(.month, from: Date())
    @State private var anioSeleccionado = Calendar.current.component(.year, from: Date())
    @State private var verTodoElAnio = false
    @State private var tipoSeleccionado = "Ingresos"
    
    let tipos = ["Ingresos", "Gastos"]
    let categorias = ["Salario", "Premio", "Regalo", "Alquiler", "Comida", "Ocio", "Transporte"]
    
    struct Movimiento {
        let tipo: String
        let categoria: String
        let cantidad: Double
    }
    
    let movimientos: [Movimiento] = [
        .init(tipo: "Ingresos", categoria: "Salario", cantidad: 1200),
        .init(tipo: "Gastos", categoria: "Comida", cantidad: 300),
        .init(tipo: "Gastos", categoria: "Ocio", cantidad: 100),
        .init(tipo: "Ingresos", categoria: "Premio", cantidad: 300),
        .init(tipo: "Gastos", categoria: "Transporte", cantidad: 60)
    ]
    
    var body: some View {
        ZStack {
            Color.moneyPlanGreen.ignoresSafeArea()
            VStack(spacing: 10) {
                
                // Selector de mes y año o todo el año
                HStack {
                    Toggle("Ver todo el año", isOn: $verTodoElAnio)
                        .toggleStyle(.button)
                        .tint(.white)
                        .foregroundColor(.white)
                    
                    if !verTodoElAnio {
                        Picker("Mes", selection: $mesSeleccionado) {
                            ForEach(1...12, id: \.self) { mes in
                                Text(nombreMes(mes)).tag(mes)
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(.white)
                        
                        Picker("Año", selection: $anioSeleccionado) {
                            ForEach(2020...Calendar.current.component(.year, from: Date()), id: \.self) { anio in
                                Text("\(anio)").tag(anio)
                            }
                        }
                        .pickerStyle(.menu)
                        .accentColor(.white)
                    }
                }
                .background(Color.white.opacity(0.15))
                .cornerRadius(12)
                
                // Total
                Text("Total: \(netoTotal(), specifier: "%.2f") €")
                    .font(.title2).bold()
                    .foregroundColor(netoTotal() >= 0 ? .lime : .peach)
                    .padding(.bottom, 10)
                
                // Gráfico de barras
                Chart {
                    BarMark(x: .value("Tipo", "Ingresos"), y: .value("€", totalPorTipo("Ingresos")))
                        .foregroundStyle(Color.lime)
                    BarMark(x: .value("Tipo", "Gastos"), y: .value("€", totalPorTipo("Gastos")))
                        .foregroundStyle(Color.peach)
                }
                .frame(height: 200)
                .padding(.bottom, 20)
                .padding(.horizontal)
                .chartXAxis {
                    AxisMarks {
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                            .foregroundStyle(.white)
                    }
                }
                .chartYAxis {
                    AxisMarks {
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel()
                            .foregroundStyle(.white)
                    }
                }
                
                
                // Picker ingresos/gastos
                Picker("Tipo", selection: $tipoSeleccionado) {
                    ForEach(tipos, id: \.self) { tipo in
                        Text(tipo)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                
                // Gráfico de tarta
                Chart {
                    ForEach(categoriasDe(tipo: tipoSeleccionado), id: \.self) { categoria in
                        let cantidad = totalPorCategoria(tipo: tipoSeleccionado, categoria: categoria)
                        if cantidad > 0 {
                            SectorMark(
                                angle: .value("€", cantidad),
                                innerRadius: .ratio(0.5),
                                angularInset: 1
                            )
                            .foregroundStyle(by: .value("Categoría", categoria))
                        }
                    }
                }
                .frame(height: 230)
                
            }
            .padding()
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    EmptyView()
                }
            }
        }
    }
    // MARK: - Funciones auxiliares
    
    func nombreMes(_ mes: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.monthSymbols[mes - 1].capitalized
    }
    
    func totalPorTipo(_ tipo: String) -> Double {
        movimientos.filter { $0.tipo == tipo }.map { $0.cantidad }.reduce(0, +)
    }
    
    func netoTotal() -> Double {
        totalPorTipo("Ingresos") - totalPorTipo("Gastos")
    }
    
    func categoriasDe(tipo: String) -> [String] {
        Array(Set(movimientos.filter { $0.tipo == tipo }.map { $0.categoria }))
    }
    
    func totalPorCategoria(tipo: String, categoria: String) -> Double {
        movimientos.filter { $0.tipo == tipo && $0.categoria == categoria }.map { $0.cantidad }.reduce(0, +)
    }
}

