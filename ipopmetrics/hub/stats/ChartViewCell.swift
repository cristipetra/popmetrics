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
    func reloadGraph(statisticMetric: StatsMetric)
}

class ChartViewCell: UITableViewCell, ScrollableGraphViewDataSource {
    
    lazy var barChart: ScrollableGraphView = {
        let chart = ScrollableGraphView(frame: CGRect(x: 15, y: 90, width: UIScreen.main.bounds.width - 30, height: 137))
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()
    
    @IBOutlet weak var urlLabel: UILabel!
    
    @IBOutlet weak var currentDateLabel: UILabel!
    @IBOutlet weak var previousDateLabel: UILabel!
    @IBOutlet weak var secondValue: UILabel!
    @IBOutlet weak var firstValue: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var containerGraphLabel: UIView!
    
    var periodGraphDateView: PeriodGraphDateView =  PeriodGraphDateView()
    
    
    var numberOfItems = 30
    var plotOneData: [Double] = [0.0, 2.3, 2.2, 4.5, 6.7, 7.8, 3.2, 4.5, 3.3, 3.5, 7.8, 3.4, 6, 7, 5, 34, 4, 5, 3, 5, 4.5, 3.3, 3.5, 7.8, 3.4, 6, 7, 5, 34, 14, 45, 45, 25, 43, 23]
    var plotTwoData: [Double] = [0.0, 12.3, 12.2, 14.5, 16.7, 17.8, 13.2, 14.5, 13.3, 13.5, 17.8, 13.4, 16, 17, 15, 34, 14, 15, 13, 15, 4.5, 3.3, 3.5, 7.8, 3.4, 6, 7, 5, 34, 34, 14, 45, 45, 25, 43, 23]
    
    var statisticMetric: StatsMetric!

    var statsMetricView: StatsMetricViewModel!
    
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
    
        addPeriodGraph()
        
        let nc = NotificationCenter.default
        nc.addObserver(forName:Notification.Popmetrics.ReloadGraph, object:nil, queue:nil, using: handerReloadData)
    }
    
    private func addPeriodGraph() {
        periodGraphDateView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(periodGraphDateView)
        periodGraphDateView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        periodGraphDateView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        periodGraphDateView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -15).isActive = true
        //periodGraphDateView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        periodGraphDateView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 7).isActive = true
    }
    
    func handerReloadData(notification:Notification) -> Void {
        let statisticMetric  = notification.object as! StatsMetric
        print(statisticMetric)
        print(statisticMetric.label)
        self.statisticMetric = statisticMetric
        
        reloadData()
    }
    
    func configure(statisticMetric: StatsMetric) {
        urlLabel.text = UserStore.currentBrand?.domainURL
        self.statisticMetric = statisticMetric
        statsMetricView = StatsMetricViewModel(statsMetric: statisticMetric)
        
        periodGraphDateView.configure(statisticMetric)
        reloadData()
    }
    
    func reloadData() {
        
        if statisticMetric.valueFormatted != "" {
            setDateTime()
        } else {
            self.firstValue.text = "\(Int(statisticMetric.value))"
            
            self.secondValue.text = ""
            self.secondValue.text =  statsMetricView.getPercentageText()
            self.secondValue.textColor = statsMetricView.colorDelta()
        }
        
        reloadGraph()
    }
    
    private func setDateTime() {
        self.firstValue.text = statisticMetric.valueFormatted
        var delta = 0 as Float
        
        delta = statisticMetric.delta
        
        secondValue.text =  delta < 0 ? "\(Int(delta))%" : "+\(Int(delta))%"
        secondValue.textColor = delta < 0 ? PopmetricsColor.salmondColor : PopmetricsColor.calendarCompleteGreen
    }
    
    func reloadGraph() {
        
        plotOneData = statisticMetric.getCurrentPeriodArray()
        plotTwoData = statisticMetric.getPrevPeriodArray()
        
        if(statisticMetric.prevPeriodLabel != "") {
            //previousDateLabel.text = statisticMetric.prevPeriodLabel
        }
        if statisticMetric.currentPeriodLabel != "" {
            //currentDateLabel.text = statisticMetric.currentPeriodLabel
        }
        
        barChart.reload()
        barChart.setNeedsLayout()
    }

    
    func setupGraph(graphView: ScrollableGraphView) {
        
        let barWidth: CGFloat = (barChart.bounds.width - 30) / CGFloat(numberOfItems)
        let animationDuration: Double = 0.4
        
        let grayPlot = BarPlot(identifier: "Gray")
        grayPlot.barWidth = barWidth
        grayPlot.barLineWidth = 1
        grayPlot.barLineColor = UIColor.white
        grayPlot.barColor = UIColor(red: 155/255, green: 155/255, blue: 155/255, alpha: 1)
        
        grayPlot.adaptAnimationType = ScrollableGraphViewAnimationType.elastic
        grayPlot.animationDuration = animationDuration
        
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
        

        
        let referenceLine = ReferenceLines()
        
        referenceLine.shouldShowLabels = false
        referenceLine.referenceLinePosition = .right
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
        
        //graphView.addPlot(plot: grayPlot)
        graphView.addPlot(plot: pinkPlot)
        
        graphView.addReferenceLines(referenceLines: referenceLine)
        //graphView.addPlot(plot: dotPlot)
        
    }
    
    func value(forPlot plot: Plot, atIndex pointIndex: Int) -> Double {
        // Return the data for each plot.
        
        switch(plot.identifier) {
        case "Gray":
            return plotOneData[pointIndex]
        case "Pink":
            return plotOneData[pointIndex]
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

struct StatsMetricViewModel {
    
    var statsMetric: StatsMetric
    
    internal func colorDelta() -> UIColor {
        return getPercentage() < 0 ? PopmetricsColor.salmondColor : PopmetricsColor.calendarCompleteGreen
    }
    
    internal func getPercentage() -> Float {
        if statsMetric.value != 0 {
            return (self.statsMetric.delta * 100) / self.statsMetric.value
        }
        else {
            return 0.0
        }
    }
    
    internal func getPercentageText() -> String {
        let percentage = getPercentage()
        return percentage <= 0 ? "\(Int(percentage))%" : "+\(Int(percentage))%"
    }
    
}
