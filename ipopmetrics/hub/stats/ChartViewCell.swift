//
//  ChartViewController.swift
//  ipopmetrics
//
//  Created by Cristian Petra on 30/08/2017.
//  Copyright © 2017 Popmetrics. All rights reserved.
//

import UIKit
import ScrollableGraphView

protocol ReloadGraphProtocol {
    func reloadGraph(statisticMetric: StatisticMetric)
}

class ChartViewCell: UITableViewCell, ScrollableGraphViewDataSource {
    
    lazy var barChart: ScrollableGraphView = {
        let chart = ScrollableGraphView(frame: CGRect(x: 16, y: 70, width: UIScreen.main.bounds.width - 35, height: 137))
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var previousDateLabel: UILabel!
    @IBOutlet weak var secondValue: UILabel!
    @IBOutlet weak var firstValue: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    var numberOfItems = 30
    var plotOneData: [Double] = [0.0, 2.3, 2.2, 4.5, 6.7, 7.8, 3.2, 4.5, 3.3, 3.5, 7.8, 3.4, 6, 7, 5, 34, 4, 5, 3, 5, 4.5, 3.3, 3.5, 7.8, 3.4, 6, 7, 5, 34, 14, 45, 45, 25, 43, 23]
    var plotTwoData: [Double] = [0.0, 12.3, 12.2, 14.5, 16.7, 17.8, 13.2, 14.5, 13.3, 13.5, 17.8, 13.4, 16, 17, 15, 34, 14, 15, 13, 15, 4.5, 3.3, 3.5, 7.8, 3.4, 6, 7, 5, 34, 34, 14, 45, 45, 25, 43, 23]
    
    var statisticMetric: StatisticMetric!

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    
    func setup() {
        
        barChart.backgroundFillColor = UIColor.white
        barChart.dataSource = self
        
        setupGraph(graphView: barChart)
        self.addSubview(barChart)
    
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
    
    func configure(statisticMetric: StatisticMetric) {
        self.statisticMetric = statisticMetric
        reloadData()
    }
    
    func reloadData() {
        self.infoLabel.text = statisticMetric.label
        self.firstValue.text = "\(Int(statisticMetric.value))"
        self.secondValue.text = "+\(Int(statisticMetric.delta))%"
        let percentageDelta = (statisticMetric.delta * 100) / (statisticMetric.value + statisticMetric.delta)
        self.secondValue.text = "+\(Int(percentageDelta))%"
        
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
        
        let barWidth: CGFloat = (barChart.bounds.width - 16) / CGFloat(numberOfItems)
        let animationDuration: Double = 1
        
        let grayPlot = BarPlot(identifier: "Gray")
        grayPlot.barWidth = barWidth
        grayPlot.barLineWidth = 1
        grayPlot.barLineColor = UIColor.white
        grayPlot.barColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        
        grayPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        grayPlot.animationDuration = animationDuration
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
        pinkPlot.barWidth = barWidth
        pinkPlot.barLineWidth = 1
        pinkPlot.barLineColor = UIColor.white
        pinkPlot.barColor = UIColor(red: 67/255, green: 76/255, blue: 84/255, alpha:1)
        
        pinkPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        pinkPlot.animationDuration = animationDuration
        
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
        graphView.dataPointSpacing = barWidth
        graphView.rightmostPointPadding = 0
        //graphView.rangeMax = Double(numberOfItems)
        graphView.scrollsToTop = false
        graphView.shouldAnimateOnStartup = true
        graphView.shouldAdaptRange = true
        graphView.shouldRangeAlwaysStartAtZero = true
        graphView.leftmostPointPadding = 10
        // Add everything to the graph.
        
        graphView.addPlot(plot: grayPlot)
        graphView.addPlot(plot: pinkPlot)
        
        //graphView.addReferenceLines(referenceLines: referenceLine)
        //graphView.addPlot(plot: dotPlot)
        
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        
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
    
}
