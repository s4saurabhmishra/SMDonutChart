import SwiftUI

public struct SMDonutChartView: View {
    @ObservedObject private var chartDataObj: ChartDataContainer
    private var lineWidth: CGFloat
    @State private var indexOfTappedSlice = -1
    @State private var isFirst = true
    private var tappedOnSlice: (SMDonutChartDataSource) -> Void
    
    public init(dataObject: ChartDataContainer, lineWidth: CGFloat, onTappedSlice: @escaping (SMDonutChartDataSource) -> Void) {
        self.chartDataObj = dataObject
        self.lineWidth = lineWidth
        self.tappedOnSlice = onTappedSlice
    }
    
    public var body: some View {
        VStack {
            ZStack {
                drawPieChart
                VStack {
                    Text(chartDataObj.getText(indexOfTappedSlice).centerTitle.uppercased())
                    Text(chartDataObj.getText(indexOfTappedSlice).centerPoints.lowercased())
                }
                .padding([.leading, .trailing], lineWidth)
            }
            .frame(width: 200, height: 250)
            .padding()
        }
        .onReceive(chartDataObj.$processedData, perform: { data in
            if data.first?.value == 0 {
                indexOfTappedSlice = -1
                chartDataObj.setValues()
            }
        })
    }

    /// Will draw the circle and slices
    private var drawPieChart: some View {
        ForEach(0 ..< chartDataObj.dataCount, id: \.self) { index in
            Circle()
                .trim(
                    from: index == 0 ? 0.0 : (chartDataObj.getValue(at: index - 1) / 100),
                    to: chartDataObj.getValue(at: index) / 100
                )
                .stroke(chartDataObj.getColor(at: index), lineWidth: lineWidth)
                .onTapGesture {
                    updateIndexSelection(index)
                }
                .scaleEffect(index == indexOfTappedSlice ? 1.1 : 1.0)
        }
    }

    /// Update the selected slice by user
    private func updateIndexSelection(_ index: Int) {
        // Handle the tap on empty space
        if indexOfTappedSlice == index || chartDataObj.isBlankSlice(index) {
            indexOfTappedSlice = -1
        } else {
            indexOfTappedSlice = index
            tappedOnSlice(chartDataObj.getData(at: index))
        }
    }
}

#if DEBUG
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

    struct ConnectActivityGraphView_Previews: PreviewProvider {
        static var previews: some View {
            SMDonutChartView(dataObject: ChartDataContainer(dataModel: ModelData().chartData), lineWidth: 30, onTappedSlice: { data in
                print(data)
            })
        }
    }
#endif
