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
    
    
    var numberOfItems = 25
    var plotOneData: [Double] = [0.0, 2.3, 2.2, 4.5, 6.7, 7.8, 3.2, 4.5, 3.3, 3.5, 7.8, 3.4, 6, 7, 5, 34, 4, 5, 3, 5, 4.5, 3.3, 3.5, 7.8, 3.4, 6, 7, 5, 34, 14, 45, 45, 25, 43, 23]
    var plotTwoData: [Double] = [0.0, 12.3, 12.2, 14.5, 16.7, 17.8, 13.2, 14.5, 13.3, 13.5, 17.8, 13.4, 16, 17, 15, 34, 14, 15, 13, 15, 4.5, 3.3, 3.5, 7.8, 3.4, 6, 7, 5, 34, 34, 14, 45, 45, 25, 43, 23]
    
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var previousDateLabel: UILabel!
    
    
    @IBOutlet weak var secondValue: UILabel!
    @IBOutlet weak var firstValue: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    var statisticMetric: StatisticMetric!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barChart.dataSource = self
        
        setupGraph(graphView: barChart)
    
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Popmetrics.ReloadGraph, object:nil, queue:nil, using: handerReloadData)
    }
    
    func handerReloadData(notification:Notification) -> Void {
        let statisticMetric  = notification.object as! StatisticMetric
        print(statisticMetric)
        print(statisticMetric.label)
        self.statisticMetric = statisticMetric
        
        reloadData()
    }
    
    func reloadData() {
        self.infoLabel.text = statisticMetric.label
        self.firstValue.text = "\(Int(statisticMetric.value))"
        self.secondValue.text = "+\(Int(statisticMetric.delta))"
        reloadGraph()
    }
    
    func reloadGraph() {
        
        plotOneData = statisticMetric.getCurrentPeriodArray()
        plotTwoData = statisticMetric.getPrevPeriodArray()
        
        if(statisticMetric.prevPeriodLabel != "") {
            previousDateLabel.text = statisticMetric.prevPeriodLabel
        }
        if statisticMetric.currentPeriodLabel != "" {
            currentDateLabel.text = statisticMetric.currentPeriodLabel
        }
        
        barChart.reload()
        barChart.setNeedsLayout()
    }

    
    func setupGraph(graphView: ScrollableGraphView) {
        
        let grayPlot = BarPlot(identifier: "Gray")
        grayPlot.barWidth = 9
        grayPlot.barLineWidth = 0
        grayPlot.barLineColor = UIColor.white
        grayPlot.barColor = UIColor(red: 122/255, green: 136/255, blue: 150/255, alpha: 0.6)
        grayPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        grayPlot.animationDuration = 1.5
        //        grayPlot.lineWidth = 1
        //        grayPlot.lineColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 0.5)
        //        grayPlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        //
        //        grayPlot.shouldFill = true
        //        grayPlot.fillType = ScrollableGraphViewFillType.solid
        //        grayPlot.fillColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha: 0.5)
        
        grayPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        
        let dotPlot = DotPlot(identifier: "Dot")
        dotPlot.dataPointSize = 1.5
        dotPlot.dataPointFillColor = PopmetricsColor.darkGrey
        
        // Setup the second line plot.
        let pinkPlot = BarPlot(identifier: "Pink")
        pinkPlot.barWidth = 9
        pinkPlot.barLineWidth = 0
        pinkPlot.barLineColor = UIColor.white
        pinkPlot.barColor = UIColor(red: 219/255, green: 14/255, blue: 95/255, alpha: 0.7)
        pinkPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        pinkPlot.animationDuration = 1.5
        //        pinkPlot.lineWidth = 1
        //        pinkPlot.lineColor = UIColor(red: 252/255, green: 41/255, blue: 139/255, alpha: 0.5)
        //        pinkPlot.lineStyle = ScrollableGraphViewLineStyle.smooth
        //
        //        pinkPlot.shouldFill = true
        //        pinkPlot.fillType = ScrollableGraphViewFillType.solid
        //        pinkPlot.fillColor = UIColor(red: 252/255, green: 41/255, blue: 139/255, alpha: 0.7)
        
        let referenceLine = ReferenceLines()
        
        referenceLine.shouldShowLabels = true
        referenceLine.dataPointLabelColor = UIColor.black
        
        // Setup the graph
        graphView.backgroundFillColor = UIColor.white
        graphView.dataPointSpacing = 9.5
        graphView.rangeMax = Double(numberOfItems)
        graphView.rightmostPointPadding = CGFloat(numberOfItems)
        graphView.scrollsToTop = false
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        
        // Add everything to the graph.
        
        graphView.addPlot(plot: grayPlot)
        graphView.addPlot(plot: pinkPlot)
        
        //graphView.addReferenceLines(referenceLines: referenceLine)
        //graphView.addPlot(plot: dotPlot)
        
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        print("ind: \(pointIndex)")
        switch(plot.identifier) {
        case "Gray":
            return plotOneData[pointIndex]
        case "Pink":
            return plotTwoData[pointIndex]
        case "Dot":
            return plotTwoData[pointIndex]
        default:
            return 0
        }
    }
    
    func label(atIndex pointIndex: Int) -> String {
        return "\(pointIndex)"
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
