//
//  ContentView.swift
//  SMDonutChartExample
//
//  Created by Mishra, Saurabh on 24/11/21.
//

import SwiftUI
import SMDonutChart

struct ModelData: SMDonutChartDataBinding {
    var chartData: [SMDonutChartDataSource] {
        [
            SMDonutChartDataSource(color: Color(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)), percent: 8, value: 0, centerText: "PURCHASE", points: 8),
            SMDonutChartDataSource(color: Color(#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)), percent: 15, value: 0, centerText: "SALE", points: 15),
            SMDonutChartDataSource(color: Color(#colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1)), percent: 32, value: 0, centerText: "ABC", points: 32),
            SMDonutChartDataSource(color: Color(#colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)), percent: 45, value: 0, centerText: "XYZ", points: 45)
        ]
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            SMDonutChartView(dataObject: ChartDataContainer(dataModel: ModelData().chartData), lineWidth: 30, onTappedSlice: { data in
                ///Data of Tapped slice on Donut
                print(data)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
