//
//  DrawChart.swift
//  ChartTest
//
//  Created by Panagiotis Diakas on 07.08.19.
//  Copyright © 2019 Panagiotis Diakas. All rights reserved.
//

import Foundation
import Charts

class DrawChart{
    
    var chartData = [ChartDataEntry]()
    var counter = 0.0

    func drawChart(chart: inout LineChartView){
        chart.dragEnabled = false
        chart.setScaleEnabled(true) // functionality??
        //chartView.chartDescription?.text = "Random Chart" // set a chart name
        //chartView.xAxis.drawAxisLineEnabled = false // no functionality
        //chartView.xAxis.drawGridLinesEnabled = false  // remove the vertical grid lines
        chart.drawGridBackgroundEnabled = false      // the background color of the view -> maybe turn this one dark blue
        chart.xAxis.drawAxisLineEnabled = false     // "cap" of the xAxis
        chart.xAxis.drawGridLinesEnabled = false    // turn grid line on/off
        chart.xAxis.drawLabelsEnabled = false
        
        chart.leftAxis.drawAxisLineEnabled = true   // YAxis line
        chart.leftAxis.drawGridLinesEnabled = true // horizontal lines on each number
        chart.leftAxis.enabled = true
        chart.leftAxis.setLabelCount(6, force: true)    // sets the number of labels on the yAxis
        chart.leftAxis.axisMinimum = 0.0    // set the yAxis minimum
        chart.leftAxis.axisMaximum = 5000.0 // set the yAxis maximum
        chart.leftAxis.labelFont = UIFont(name: "SourceCodePro-Regular", size: 12)! // set an indivual font to the yAxis
        chart.leftAxis.labelTextColor = .white  //change the color of the font
        //chartView.rightAxis.drawAxisLineEnabled = false // no effect
        //chartView.rightAxis.drawGridLinesEnabled = false // no effect
        chart.legend.enabled = false // we dont need a legend because we have only one clear line
        //chartView.xAxis.enabled = false
        chart.rightAxis.enabled = false
        chart.data?.setDrawValues(false)    // show the value of each dot  functionality???
        chart.backgroundColor = midBlue
        
        chartData.append(ChartDataEntry(x: 0.0, y: 0.0))
        
        let line = LineChartDataSet(entries: chartData, label: "Number")
        line.colors = [lightBlue]  // change the color of the "line"
        line.drawCirclesEnabled = false
        line.drawValuesEnabled = false
        line.mode = .cubicBezier
        
        let data = LineChartData()
        data.addDataSet(line)
        chart.data = data
        
        counter += 1
    }
    
    func updateGraph(View: inout LineChartView, signal: String){
        let newEntry = ChartDataEntry(x: counter, y: Double(signal)!)
        counter += 1
        
        let viewData = View.data?.getDataSetByIndex(0)
        _ = viewData?.addEntry(newEntry)
        
        View.data?.notifyDataChanged()
        View.notifyDataSetChanged()
        // MARK: Change the value for Max Values Displayed
        View.setVisibleXRangeMaximum(50.0)
        View.moveViewToX(Double(self.counter)) // Double(View.data!.entryCount)

    }// updateGraph()
    
    
    func drawChart(chart: inout LineChartView, data: [ChartDataEntry]){
        chart.dragEnabled = false
        chart.setScaleEnabled(true)
        chart.drawGridBackgroundEnabled = false      // the background color of the view -> maybe turn this one dark blue
        chart.xAxis.drawAxisLineEnabled = false     // "cap" of the xAxis
        chart.xAxis.drawGridLinesEnabled = false    // turn grid line on/off
        chart.xAxis.drawLabelsEnabled = false
        
        chart.leftAxis.drawAxisLineEnabled = true   // YAxis line
        chart.leftAxis.drawGridLinesEnabled = true // horizontal lines on each number
        chart.leftAxis.enabled = true
        chart.leftAxis.setLabelCount(6, force: true)    // sets the number of labels on the yAxis
        chart.leftAxis.axisMinimum = 0.0    // set the yAxis minimum
        chart.leftAxis.axisMaximum = 5000.0 // set the yAxis maximum
        //chart.leftAxis.labelFont = UIFont(name: "SourceCodePro-Regular", size: 12)! // set an indivual font to the yAxis
        chart.leftAxis.labelTextColor = .white  //change the color of the font
        chart.legend.enabled = false // we dont need a legend because we have only one clear line
        chart.rightAxis.enabled = false
        chart.data?.setDrawValues(false)    // show the value of each dot  functionality???
        chart.backgroundColor = midBlue
        
        let line = LineChartDataSet(entries: data, label: "Number")
        line.colors = [lightBlue]  // change the color of the "line"
        line.drawCirclesEnabled = false
        line.drawValuesEnabled = false
        line.mode = .cubicBezier
        
        let data = LineChartData()
        data.addDataSet(line)
        chart.data = data
    }
}
