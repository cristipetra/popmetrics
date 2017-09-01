//
//  ChartViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import ScrollableGraphView

class ChartViewController: UIViewController, ScrollableGraphViewDataSource {
    
    @IBOutlet weak var barChart: ScrollableGraphView!
    @IBOutlet weak var containerView: UIView!
    
    
    var numberOfItems = 100
    var plotOneData: [Double] = [0.0]
    var plotTwoData: [Double] = [0.0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barChart.dataSource = self
        
        randomData()
        setupGraph(graphView: barChart)
    }

    
    func randomData() {
        plotOneData = self.generateRandomData(self.numberOfItems, max: 50, shouldIncludeOutliers: true)
        plotTwoData = self.generateRandomData(self.numberOfItems, max: 100, shouldIncludeOutliers: true)
    }
    
    func setupGraph(graphView: ScrollableGraphView) {
        
        let grayPlot = LinePlot(identifier: "Gray")
        grayPlot.lineWidth = 1
        grayPlot.lineColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 0.5)
        grayPlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        grayPlot.shouldFill = true
        grayPlot.fillType = ScrollableGraphViewFillType.solid
        grayPlot.fillColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 0.5)
        
        grayPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        // Setup the second line plot.
        let pinkPlot = LinePlot(identifier: "Pink")
        pinkPlot.lineWidth = 1
        pinkPlot.lineColor = UIColor(red: 252/255, green: 41/255, blue: 139/255, alpha: 0.5)
        pinkPlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        
        pinkPlot.shouldFill = true
        pinkPlot.fillType = ScrollableGraphViewFillType.solid
        pinkPlot.fillColor = UIColor(red: 252/255, green: 41/255, blue: 139/255, alpha: 0.7)
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.white
        graphView.dataPointSpacing = 9
        graphView.rangeMax = Double(numberOfItems)
        graphView.rightmostPointPadding = CGFloat(numberOfItems)
        graphView.scrollsToTop = true
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        
        // Add everything to the graph.
        graphView.addPlot(plot: grayPlot)
        graphView.addPlot(plot: pinkPlot)
        
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        switch(plot.identifier) {
        case "Gray":
            return plotOneData[pointIndex]
        case "Pink":
            return plotTwoData[pointIndex]
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return ""
    }
    
    func numberOfPoints() -> Int {
        return numberOfItems
    }
    
    private func generateRandomData(_ numberOfItems: Int, max: Double, shouldIncludeOutliers: Bool = true) -> [Double] {
        var data = [Double]()
        for _ in 0 ..< numberOfItems {
            var randomNumber = Double(arc4random()).truncatingRemainder(dividingBy: max)
            
            if(shouldIncludeOutliers) {
                if(arc4random() % 100 < 10) {
                    randomNumber *= 3
                }
            }
            
            data.append(randomNumber)
        }
        return data
    }
    
}
