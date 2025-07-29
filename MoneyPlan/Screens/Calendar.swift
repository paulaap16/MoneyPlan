//
//  Calendar.swift
//  MoneyPlan
//
//  Created by Paula Arroyo on 25/7/25.
//

import SwiftUI

enum ViewMode: String, CaseIterable {
    case diaria = "Diaria"
    case mensual = "Mensual"
}

struct Movimiento: Identifiable {
    let id = UUID()
    let fecha: Date
    let tipo: FormType
    let categoria: String
    let nombre: String
    let cantidad: Double
}

struct CalendarView: View {
    @State private var fechaSeleccionada = Date()
    @State private var vista = ViewMode.diaria
    @State private var categoriaSeleccionada = "Todo"
    
    let categorias = ["Salario", "Premio", "Regalo", "Alquiler", "Comida", "Ocio"]

    let movimientos: [Movimiento] = [
        Movimiento(fecha: Date(), tipo: .ingreso, categoria: "Salario", nombre: "Nómina", cantidad: 1500),
        Movimiento(fecha: Date(), tipo: .gasto, categoria: "Comida", nombre: "Supermercado", cantidad: 40),
        Movimiento(fecha: Date(), tipo: .gasto, categoria: "Ocio", nombre: "Cine", cantidad: 12),
        Movimiento(fecha: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, tipo: .gasto, categoria: "Transporte", nombre: "Gasolina", cantidad: 60)
    ]

    var movimientosDelDia: [Movimiento] {
        movimientos.filter {
            Calendar.current.isDate($0.fecha, inSameDayAs: fechaSeleccionada)
        }
    }

    var movimientosDelMes: [Movimiento] {
        movimientos.filter {
            Calendar.current.isDate($0.fecha, equalTo: fechaSeleccionada, toGranularity: .month)
        }
    }

    var totalIngresosDia: Double {
        movimientosDelDia.filter { $0.tipo == .ingreso }.map { $0.cantidad }.reduce(0, +)
    }

    var totalGastosDia: Double {
        movimientosDelDia.filter { $0.tipo == .gasto }.map { $0.cantidad }.reduce(0, +)
    }

    var totalIngresosMes: Double {
        movimientosDelMes.filter { $0.tipo == .ingreso }.map { $0.cantidad }.reduce(0, +)
    }

    var totalGastosMes: Double {
        movimientosDelMes.filter { $0.tipo == .gasto }.map { $0.cantidad }.reduce(0, +)
    }

    var body: some View {
        ZStack {
            Color.moneyPlanGreen.ignoresSafeArea()

            VStack(spacing: 20) {
                // Selector de vista (Diaria / Mensual)
                Picker("Vista", selection: $vista) {
                    ForEach(ViewMode.allCases, id: \.self) { mode in
                        Text(mode.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                if vista == .diaria {
                    diariaView
                } else {
                    mensualView
                }

                Spacer()
            }
            .padding(.top)
        }
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Vista Diaria
   
    var diariaView: some View {
        let movimientosFiltrados = movimientosDelDia.filter {
            categoriaSeleccionada == "Todo" || $0.categoria == categoriaSeleccionada
        }

        let ingresos = movimientosFiltrados.filter { $0.tipo == .ingreso }.map { $0.cantidad }.reduce(0, +)
        let gastos = movimientosFiltrados.filter { $0.tipo == .gasto }.map { $0.cantidad }.reduce(0, +)

        return VStack(spacing: 20) {
            Text("Resumen del Día")
                .font(.title)
                .foregroundColor(.white)

            // Selector de fecha
            DatePicker("Selecciona un día", selection: $fechaSeleccionada, displayedComponents: .date)
                .datePickerStyle(.compact)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)
                .foregroundColor(.white)
                .colorScheme(.dark)

            // Clasificación por categoría (alineado horizontalmente)
            HStack {
                Text("Clasifica por categoría:")
                    .foregroundColor(.white)
                    .font(.subheadline)

                Spacer()

                Picker("Categoría", selection: $categoriaSeleccionada) {
                    Text("Todo").tag("Todo")
                    ForEach(categorias, id: \.self) { cat in
                        Text(cat).tag(cat)
                    }
                }
                .pickerStyle(.menu)
                .accentColor(Color.moneyPlanLight).bold()
                .background(Color.white.opacity(0.15))
                .cornerRadius(10)
            }
            .padding(.horizontal)

            resumenView(ingresos: ingresos, gastos: gastos, fecha: formattedDate(fechaSeleccionada))

            List(movimientosFiltrados) { mov in
                movimientoRow(mov)
            }
            .listStyle(.plain)
        }
    }


    // MARK: - Vista Mensual
    @State private var mesSeleccionado = Calendar.current.component(.month, from: Date())
    @State private var anioSeleccionado = Calendar.current.component(.year, from: Date())

    var mensualView: some View {
        VStack(spacing: 20) {
            Text("Resumen del Mes")
                .font(.title)
                .foregroundColor(.white)

            // Selección de mes y año
            HStack(spacing: 20) {
                Picker("Mes", selection: $mesSeleccionado) {
                    ForEach(1...12, id: \.self) { month in
                        Text(nombreMes(month)).tag(month)
                    }
                }
                .pickerStyle(.menu)
                .accentColor(.white)
                .frame(maxWidth: .infinity)

                Picker("Año", selection: $anioSeleccionado) {
                    ForEach(2020...Calendar.current.component(.year, from: Date()), id: \.self) { year in
                        Text("\(year)").tag(year)
                    }
                }
                .pickerStyle(.menu)
                .accentColor(.white)
                .frame(maxWidth: .infinity)
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(12)
            .padding(.horizontal)
            
            HStack {
                Text("Clasifica por categoría:")
                    .foregroundColor(.white)
                    .font(.subheadline)

                Spacer()

                Picker("Categoría", selection: $categoriaSeleccionada) {
                    Text("Todo").tag("Todo")
                    ForEach(categorias, id: \.self) { cat in
                        Text(cat).tag(cat)
                    }
                }
                .pickerStyle(.menu)
                .accentColor(Color.moneyPlanLight).bold()
                .background(Color.white.opacity(0.15))
                .cornerRadius(10)
            }
            .padding(.horizontal)

            // Movimientos filtrados
            let movimientosFiltrados = movimientos.filter {
                let comp = Calendar.current.dateComponents([.year, .month], from: $0.fecha)
                let coincideConFecha = comp.month == mesSeleccionado && comp.year == anioSeleccionado
                let coincideConCategoria = categoriaSeleccionada == "Todo" || $0.categoria == categoriaSeleccionada
                return coincideConFecha && coincideConCategoria
            }

            let ingresos = movimientosFiltrados.filter { $0.tipo == .ingreso }.map { $0.cantidad }.reduce(0, +)
            let gastos = movimientosFiltrados.filter { $0.tipo == .gasto }.map { $0.cantidad }.reduce(0, +)

            resumenView(ingresos: ingresos, gastos: gastos, fecha: "\(nombreMes(mesSeleccionado)) \(anioSeleccionado)")

            List(movimientosFiltrados) { mov in
                movimientoRow(mov)
            }
            .listStyle(.plain)
        }
    }

    // MARK: - Elementos reutilizables
    func resumenView(ingresos: Double, gastos: Double, fecha: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("🗓️ \(fecha)")
                .font(.headline)
                .foregroundColor(.white)

            Text("Ingresos: \(ingresos, specifier: "%.2f") €")
                .foregroundColor(.lime)
            Text("Gastos: \(gastos, specifier: "%.2f") €")
                .foregroundColor(.peach)
            Text("Total: \(ingresos - gastos, specifier: "%.2f") €")
                .foregroundColor(.white).bold()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.1))
        .cornerRadius(16)
        .padding(.horizontal)
    }

    func movimientoRow(_ mov: Movimiento) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(mov.tipo == .ingreso ? "+" : "-") \(mov.nombre)")
                    .bold()
                Text(mov.categoria)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Text("\(mov.cantidad, specifier: "%.2f") €")
                .foregroundColor(mov.tipo == .ingreso ? Color.moneyPlanGreen : .peach)
        }
        
        .padding(.vertical, 6)
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }

    func formattedMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date).capitalized
    }
    func nombreMes(_ mes: Int) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_ES") // o "en_US" si quieres en inglés
        return formatter.monthSymbols[mes - 1].capitalized
    }
}

