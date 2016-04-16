//
//  StatsViewController.swift
//  nott_ios
//
//  Created by Vidar Fridriksson on 13/04/16.
//  Copyright © 2016 hideout. All rights reserved.
//

import UIKit
import Charts

class StatsViewController: UIViewController,ChartViewDelegate,UITableViewDataSource,UITableViewDelegate {

    var chartsUIView:UIView!
    var timeLineUIView:UIView!
    
    var tableView = UITableView()
    var refreshControl = UIRefreshControl()

    let dateLabel = UILabel()
    var sleepChartView = LineChartView()
    var sleepDataEntries = NSMutableArray()
    var dateDataEntries:NSArray!
    var chart1Data = LineChartData()
    var line1dataSet = LineChartDataSet()
    
    var timeLineData = NSMutableArray()
    
    var defaults = NSUserDefaults.standardUserDefaults()
    var sleepQu = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "history"
        self.view.backgroundColor = UIColor.whiteColor()
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height

        

        let progressHUD = ProgressHUD(text: "Loading Data")
        self.view.addSubview(progressHUD)
        self.view.bringSubviewToFront(progressHUD)
        
        chartsUIView = UIView()
        chartsUIView.frame = CGRectMake(0, navigationBarHeight, self.view.frame.size.width, (self.view.frame.size.height-navigationBarHeight)/2)
        self.view.addSubview(chartsUIView)
        
        
        timeLineUIView = UIView()
        timeLineUIView.frame = CGRectMake(0, (self.view.frame.size.height-navigationBarHeight)/2 + navigationBarHeight, self.view.frame.size.width, (self.view.frame.size.height-navigationBarHeight)/2)
        
        self.view.addSubview(timeLineUIView)
        
        
        // get the sleep quality data from API
        let sleepQualityData = DataService.ds.getUserSleepQualityHistory(defaults.valueForKey("username") as! String)
        
        // get the current date
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        let currentDate = dateformatter.stringFromDate(NSDate())
        // get the timeline for current date
        let timeLineFetchData = DataService.ds.getUserTimeLine(defaults.valueForKey("username") as! String, datestr: currentDate)
        
        // set the chart delegate
        sleepChartView.delegate = self
        
        // delay settings the chart data, allow time to load from API
        delay(2.0, closure: {
            for data in sleepQualityData.valueForKey("efficiency") as! NSArray{
                for sleepData in data as! NSArray{
                    self.sleepDataEntries.addObject(sleepData.valueForKey("efficiency")!)
                    self.sleepQu.addObject(sleepData.valueForKey("date")!)
                }
                self.dateDataEntries = self.sleepQu
                
            }
            
            for data in timeLineFetchData.valueForKey("objects_for_timeline") as! NSArray{
                for item in data as! NSArray{
                    self.timeLineData.addObject(item)
                }
            }
            
//            print(timeLineFetchData)
//            print(self.timeLineData[0].valueForKey("id")!)
            self.setupSleepChart()
            self.setupTimeLineView()
            self.drawTimeLine()
            progressHUD.removeFromSuperview()

        })

        
    }

    
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        let progressHUD = ProgressHUD(text: "loading...")
        self.view.addSubview(progressHUD)
        self.view.bringSubviewToFront(progressHUD)
        
        let chosenDate = String(dateDataEntries[entry.xIndex])
        
        let timeLineFetchData = DataService.ds.getUserTimeLine(defaults.valueForKey("username") as! String, datestr: chosenDate)
        self.timeLineData = NSMutableArray()
        

//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
////        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
////        dateFormatter.locale = NSLocale.currentLocale()
//        let date = dateFormatter.dateFromString(chosenDate)
        
        
        dateLabel.text = chosenDate
        
        delay(1.2, closure: {
            for data in timeLineFetchData.valueForKey("objects_for_timeline") as! NSArray{
                for item in data as! NSArray{
                    self.timeLineData.addObject(item)
                }
            }
            self.tableView.reloadData()
            progressHUD.removeFromSuperview()
        })
        
        
    }
    
    
    func setupSleepChart(){
        self.sleepChartView.rightAxis.enabled = true
        self.sleepChartView.rightAxis.labelTextColor = UIColor.clearColor()
        self.sleepChartView.leftAxis.forceLabelsEnabled = true
        
        let maxScore = 99.0
        self.sleepChartView.leftAxis.customAxisMax = maxScore + 1.0
        self.sleepChartView.leftAxis.labelCount = Int(maxScore)+1
        
        self.sleepChartView.leftAxis.valueFormatter = NSNumberFormatter()
        self.sleepChartView.leftAxis.valueFormatter?.minimumFractionDigits = 0
        self.sleepChartView.leftAxis.customAxisMin = 0
        
        self.sleepChartView.rightAxis.customAxisMax = maxScore + 1.0
        self.sleepChartView.rightAxis.labelCount = Int(maxScore)+1
        
        self.sleepChartView.rightAxis.valueFormatter = NSNumberFormatter()
        self.sleepChartView.rightAxis.valueFormatter?.minimumFractionDigits = 0
        self.sleepChartView.rightAxis.customAxisMin = 0
        
        
        self.sleepChartView.descriptionText = ""
        
        self.sleepChartView.scaleYEnabled = false
        self.sleepChartView.moveViewToX(Int(view.frame.width))
//        self.sleepChartView.setScaleMinima(10.0, scaleY: 0.0)
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< dateDataEntries.count {
            yVals1.append(ChartDataEntry(value: sleepDataEntries[i] as! Double, xIndex: i))
        }
        
//        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
        
        
        sleepChartView.frame = CGRectMake(self.view.frame.width * 0.03, self.view.frame.size.height * 0.04, self.view.frame.size.width*0.94, self.view.frame.size.height*0.4)
        sleepChartView.tintColor = UIColor.redColor()
        sleepChartView.backgroundColor = UIColor.clearColor()
        sleepChartView.descriptionTextColor = UIColor.blackColor()
        sleepChartView.leftAxis.labelTextColor = UIColor.blackColor()
        sleepChartView.rightAxis.labelTextColor = UIColor.blackColor()
        sleepChartView.xAxis.labelTextColor = UIColor.blackColor()
        sleepChartView.legend.textColor = UIColor.blackColor()
        
        sleepChartView.noDataText = "there is no data here"
        
        line1dataSet = LineChartDataSet(yVals: yVals1, label: "Sleep Quality")
        line1dataSet.setColor(UIColor.redColor())
        line1dataSet.setCircleColor(UIColor.redColor())
        line1dataSet.valueTextColor = UIColor.clearColor()
        
        chart1Data = LineChartData(xVals: dateDataEntries! as? [NSObject], dataSet: line1dataSet)
        
//        chart1Data = LineChartData(xVals: dateDataEntries, dataSet: line1dataSet)
        
        sleepChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .EaseInBounce)
        sleepChartView.data = chart1Data
        
        self.chartsUIView.addSubview(sleepChartView)
    }
    
    
    func setupTimeLineView(){
        let topBanner = UIView()
        topBanner.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.09)
        topBanner.backgroundColor = Constants.AppColors.appPurpleColor
        timeLineUIView.addSubview(topBanner)
        
        dateLabel.frame = CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.01, self.view.frame.size.width*0.5, self.view.frame.size.height*0.07)
        dateLabel.text = "Today"
        dateLabel.font = UIFont.systemFontOfSize(24, weight: UIFontWeightLight)
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.textAlignment = .Left
        topBanner.addSubview(dateLabel)
        
        self.tableView.frame = CGRectMake(0, self.view.frame.size.height*0.09, self.view.frame.size.width, self.timeLineUIView.frame.size.height-self.view.frame.size.height*0.09)
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clearColor()
        self.timeLineUIView.addSubview(self.tableView)
        
        // Refresh Control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(StatsViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
    }
    
    func refresh(){
        self.tableView.reloadData()
        stopRefresh()
        
    }
    func stopRefresh(){
        if self.refreshControl.refreshing
        {
            self.refreshControl.endRefreshing()
        }
        NSLog("stopping")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 70
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeLineData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //
        var emojiImage = UIImage()
        var iconImage = UIImage()
        var titleText:String!
        if (timeLineData[indexPath.row].valueForKey("type") as! String) == "activity" {
            iconImage = UIImage(imageLiteral: (timeLineData[indexPath.row].valueForKey("activity_type")as! String) + "_icon")
            titleText = (timeLineData[indexPath.row].valueForKey("activity_type")as! String)
            
        }else{
            let base64String = (timeLineData[indexPath.row].valueForKey("picture") as! String)
            let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            let decodedimage = UIImage(data: decodedData!)
            if decodedimage != nil{
                iconImage = decodedimage! as UIImage
            }
            titleText = (timeLineData[indexPath.row].valueForKey("title") as! String)
            
            if (timeLineData[indexPath.row].valueForKey("score") as! NSNumber) == 1{
                emojiImage = UIImage(imageLiteral: "sadEmoji")
            }
            if (timeLineData[indexPath.row].valueForKey("score") as! NSNumber) == 2{
                emojiImage = UIImage(imageLiteral: "mediumEmoji")
            }
            if (timeLineData[indexPath.row].valueForKey("score") as! NSNumber) == 3{
                emojiImage = UIImage(imageLiteral: "happyEmoji")
            }
            
        }


        
        if let cell = self.tableView.dequeueReusableCellWithIdentifier("identifier") as? TimeLineTableViewCell{
            cell.timeLabel.text = (timeLineData[indexPath.row].valueForKey("time") as! String)
            cell.titleLabel.text = titleText
            cell.itemIcon.image = iconImage
            cell.emojiLevelIcon.image = emojiImage
            cell.backgroundColor = UIColor.clearColor()
            return cell
        }else{
            let cell = TimeLineTableViewCell()
            cell.timeLabel.text = (timeLineData[indexPath.row].valueForKey("time") as! String)
            cell.titleLabel.text = titleText
            cell.itemIcon.image = iconImage
            cell.emojiLevelIcon.image = emojiImage
            cell.backgroundColor = UIColor.clearColor()
            
            return cell
        }
        
    }
    
    
    func drawTimeLine(){
        let circlePath = UIBezierPath()
        
        circlePath.moveToPoint(CGPoint(x: 52.0, y:self.view.frame.size.height*0.09))
        circlePath.addLineToPoint(CGPoint(x: 52.0, y: self.view.frame.size.height*0.91))
        
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.CGPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor(red: 191.0/255, green: 190.0/255, blue: 206.0/255, alpha: 1.0).CGColor
        //you can change the line width
        shapeLayer.lineWidth = 2.5
        
        
        self.timeLineUIView.layer.insertSublayer(shapeLayer, atIndex: 1)
        
        
    }

    
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}
