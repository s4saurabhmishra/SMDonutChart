import Foundation
import SwiftUI

enum ChartConstants {
    static let emptyColor = Color.white
    static let emptyValue: CGFloat = 10
}

public struct SMDonutChartDataSource: Equatable {
    var id = UUID()
    var color: Color
    var percent: CGFloat
    var value: CGFloat
    var centerText: String
    var points: Int
    
    public init(color: Color, percent: CGFloat, value: CGFloat, centerText: String, points: Int) {
        self.color = color
        self.percent = percent
        self.value = value
        self.centerText = centerText
        self.points = points
    }
}

public protocol SMDonutChartDataBinding {
    var chartData: [SMDonutChartDataSource] { get }
}

public class ChartDataContainer: ObservableObject {
    @Published var chartData: [SMDonutChartDataSource] = []
    @Published var processedData: [SMDonutChartDataSource] = []
    public init(dataModel: [SMDonutChartDataSource]) {
        chartData = dataModel
        processedData = appendEmptyElement(dataModel)
    }

    /// Function will insert Empty data to show gap in slicing
    private func appendEmptyElement(_ data: [SMDonutChartDataSource]) -> [SMDonutChartDataSource] {
        let emptySlice = SMDonutChartDataSource(color: ChartConstants.emptyColor, percent: 0.0, value: 0, centerText: "", points: Int(ChartConstants.emptyValue))

        var returnData = [SMDonutChartDataSource]()
        for value in data {
            returnData.append(value)
            returnData.append(emptySlice)
        }
        reCalculatePercentage(&returnData)
        return returnData
    }

    private func reCalculatePercentage(_ data: inout [SMDonutChartDataSource]) {
        let totalPoints = data.compactMap { Double($0.points) }.reduce(0, +)
        for (index, item) in data.enumerated() {
            let percentage = (Double(item.points) / totalPoints) * 100
            if var value = data.object(at: index) {
                value.percent = CGFloat(percentage)
                data.insert(value, at: index)
                data.remove(at: index + 1)
            }
        }
    }
}

// MARK: - Public methods

public extension ChartDataContainer {
    func setValues() {
        var value: CGFloat = 0
        for i in 0 ..< processedData.count {
            value += processedData[i].percent
            processedData[i].value = value
        }
    }

    /// Get center text
    func getText(_ index: Int) -> (centerTitle: String, centerPoints: String) {
        var centerText = ""
        var centerPoints = ""
        if index != -1 {
            centerText = processedData[index].centerText
            centerPoints = String(format: NSLocalizedString("+ %d points", comment: ""), processedData[index].points)
        } else {
            centerText = NSLocalizedString("TOTAL", comment: "")
            centerPoints = String(format: NSLocalizedString("+ %d points", comment: ""), getTotalPoints)
        }
        return (centerTitle: centerText, centerPoints: centerPoints)
    }

    func isBlankSlice(_ index: Int) -> Bool {
        processedData[index].color == .white
    }

    func getColor(at index: Int) -> Color {
        processedData[index].color
    }

    func getValue(at index: Int) -> CGFloat {
        processedData[index].value
    }

    var dataCount: Int {
        processedData.count
    }

    private var getTotalPoints: Int {
        var sum = 0
        for data in processedData where data.color != .white {
            sum += data.points
        }
        return sum
    }

    func getData(at index: Int) -> SMDonutChartDataSource {
        processedData[index]
    }
}
