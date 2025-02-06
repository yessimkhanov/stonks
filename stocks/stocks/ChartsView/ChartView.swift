//
//  ChartView.swift
//  stocks
//
//  Created by Алдияр Есимханов on 11.01.2025.
//

import Foundation
import SwiftUI
import SwiftUICharts

struct ChartView: View {
    @ObservedObject var store: ChartsStore
    
    private var viewState: ChartsStore.ViewState? {
        return store.viewState
    }
    var onDismiss: (() -> Void)?
    
    var body: some View {
        VStack {
            tabBar()
            subTabBar()
            Rectangle()
                .frame(height: 48)
                .opacity(0)
            priceLabel()
            Spacer()
            lineChart(viewState)
            Rectangle()
                .frame(height: 54)
                .opacity(0)
            chartButtons()
            Rectangle()
                .frame(height: 52)
                .opacity(0)
            buyButton()
        }
    }
    
    @ViewBuilder
    private func tabBar() -> some View {
        if let viewState = viewState {
            HStack {
                Button {
                    onDismiss?()
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .frame(width: 20, height: 14)
                        .padding(.leading, 18)
                        .foregroundStyle(.black)
                        .padding(.top, 20)
                }
                Spacer()
                VStack (spacing: 4) {
                    Text(viewState.company.abbreviation)
                        .font(.custom("Montserrat-Bold", size: 18))
                        .foregroundStyle(.black)
                        .padding(.top, 22)
                    Text(viewState.company.name)
                        .font(.custom("Montserrat", size: 12))
                        .frame(height: 16)
                }
                Spacer()
                Button {
                    store.favouriteButtonPressed()
                } label: {
                    Image(systemName: viewState.isFavorite ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(viewState.isFavorite ? Color(rgb: 0xFFCA1C) : .black)
                }
                .padding(.trailing, 17)
                .padding(.top, 15)
            }
        }
    }
    
    @ViewBuilder
    private func subTabBar() -> some View {
        if let viewState = viewState {
            let buttons: [String] = ["Chart", "Summary", "News", "Forecasts", "Ideas", "Insights"]
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(buttons, id: \.self) { title in
                        Button{
                            store.subBarButtonPressed(buttonTitle: title)
                        } label: {
                            Text(title)
                                .font(.custom("Montserrat-Bold", size: viewState.selectedSubBar == title ? 18 : 14))
                                .foregroundStyle(viewState.selectedSubBar == title ? Color.black : Color(rgb: 0xBABABA))
                        }
                        .background(Color.white)
                    }
                }
            }
            .padding(.leading, 20)
            .padding(.trailing, 10)
            .scrollIndicators(.hidden)
        }
    }
    
    @ViewBuilder
    private func priceLabel() -> some View {
        if let viewState = viewState {
            Text("$\(String(format: "%.2f", viewState.company.price))")
                .font(.custom("Montserrat-Bold", size: 28))
                .padding(.horizontal, 133)
            Text(viewState.company.change)
                .font(.custom("Montserrat", size: 12))
                .foregroundStyle(viewState.company.change.charAt(0) == "-" ? Color(rgb: 0xB22424) : Color(rgb: 0x24B25D))
        }
    }
    
    @ViewBuilder
    private func lineChart(_ viewState: ChartsStore.ViewState?) -> some View {
        if let viewState = viewState {
            LineChart()
                .data(viewState.data)
                .chartStyle(
                    ChartStyle(
                        backgroundColor: .white,
                        foregroundColor: [ColorGradient(.gray, .black)]
                    )
                )
                .frame(height: 260)
        }
    }
    
    @ViewBuilder
    private func chartButtons() -> some View {
        let buttons: [String] = ["D", "W", "M", "6M", "1Y", "All"]
        if let viewState = viewState {
            HStack (spacing: 10){
                ForEach(buttons, id: \.self) { title in
                    Button {
                        store.periodButtonPressed(buttonTitle: title)
                    } label: {
                        Text(title)
                            .font(.custom("Montserrat", size: 12))
                            .foregroundStyle(viewState.selectedPeriod == title ? Color.white : Color.black)
                            .padding(.vertical, 14)
                            .padding(.horizontal, 16)
                    }
                    .background(viewState.selectedPeriod == title ? Color.black : Color(rgb: 0xF0F4F7))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
    }
    
    @ViewBuilder
    private func buyButton() -> some View {
        if let viewState = viewState {
            Button {
                store.buyButtonPressed()
            } label: {
                Text("Buy for $\(String(format: "%.2f", viewState.company.price))")
                    .foregroundStyle(.white)
                    .font(.custom("Montserrat-Bold", size: 16))
            }
            .padding(.horizontal, 16)
            .frame(width: 328, height: 56)
            .background(.black)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
