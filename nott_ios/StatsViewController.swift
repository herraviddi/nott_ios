//
//  StatsViewController.swift
//  nott_ios
//
//  Created by Vidar Fridriksson on 13/04/16.
//  Copyright © 2016 hideout. All rights reserved.
//

import UIKit
import Charts
import Alamofire

class StatsViewController: UIViewController,ChartViewDelegate,UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UINavigationControllerDelegate {

    var intakeLogViewPopUp = UIView()
    var deviceLogViewPopUP = UIView()
    
    var username:String!
    var food_id:Int!
    var activity_id:Int!
    var score:Int!
    
    var deviceUsageData:NSMutableArray!
    
    var progressHUD:ProgressHUD!
    
    var timeLineFetchData:NSMutableArray!
    
    var lowerViewBannerActionItemButton = UIButton()
    
    // intake popup elements
    var mealPhotoImage:UIImage!
    var mealPhotoImageView = UIImageView()
    var addPhotoButton = UIButton()
    var addIntakeButtonImage:UIImage!
    var emojiLevel:Int!
    var happyAddButton:UIButton!
    var mediumAddButton:UIButton!
    var unhappyAddButton:UIButton!
    var intakeTitleTextfield = UITextField()
    var intakeTimeTextfield = UITextField()
    var foodTypePickerTextfield = UITextField()
    var foodTypePickerView = UIPickerView()
    var foodTypeArray = ["","Dinner","Candy","Drink","Snacks"]
    var selectedFoodType: String!
    
    var imagePicker = UIImagePickerController()
    
    
    // device popup elements
    var deviceImage:UIImage!
    var deviceImageView = UIImageView()
    
    var deviceStartTimeTextField = UITextField()
    var deviceEndTimeTextField = UITextField()
    var deviceToLog:String!



    
    var longPressRecognizer : UILongPressGestureRecognizer!

    var chartsUIView:UIView!
    var timeLineUIView:UIView!
    var sleepDetailView:UIView!
    
    var sleepDetailVisible = false
    
    var sleepQualityButton:UIButton!
    var deviceUsageButton:UIButton!
    
    var upperView:UIView!
    var lowerView:UIView!
    
    var tableView = UITableView()
    var refreshControl = UIRefreshControl()

    let dateLabel = UILabel()
    var sleepChartView = LineChartView()
    var sleepDataEntries = NSMutableArray()
    var dateDataEntries:NSArray!
    var chart1Data = LineChartData()
    var line1dataSet = LineChartDataSet()
    

    var iPadDataEntries = NSMutableArray()
    var iPhoneDataEntries = NSMutableArray()
    var tvDataEntries = NSMutableArray()
    
    var deviceChartView = BarChartView()
    var deviceDateEntries:NSArray!

    
    var timeLineData = NSMutableArray()
    
    var defaults = NSUserDefaults.standardUserDefaults()
    var sleepQu = NSMutableArray()
    var deviceUse = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "history"
        self.view.backgroundColor = UIColor.whiteColor()
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height


        
        
        chartsUIView = UIView()
        chartsUIView.frame = CGRectMake(0, navigationBarHeight, self.view.frame.size.width, (self.view.frame.size.height-navigationBarHeight)/2)
        self.view.addSubview(chartsUIView)
        

        sleepQualityButton = UIButton(type: UIButtonType.Custom) as UIButton
        sleepQualityButton.backgroundColor = Constants.AppColors.appPurpleColor
//        sleepQualityButton.setTitle("Sleep!", forState: .Normal)
        sleepQualityButton.titleLabel!.font = UIFont.systemFontOfSize(26, weight: UIFontWeightUltraLight)
        sleepQualityButton.layer.borderWidth = 0.1
        sleepQualityButton.layer.cornerRadius = 10.0
        sleepQualityButton.clipsToBounds = true
        sleepQualityButton.enabled = false
        sleepQualityButton.alpha = 1.5
                sleepQualityButton.addTarget(self, action: #selector(StatsViewController.sleepQualityButtonPressed), forControlEvents: .TouchUpInside)
        sleepQualityButton.frame = CGRectMake(self.view.frame.size.width*0.20, chartsUIView.frame.size.height*0.87, self.view.frame.size.width*0.25, self.view.frame.size.height*0.07)
        if let sleepImage = UIImage(named: "sleepButton") {
            sleepQualityButton.setImage(sleepImage, forState: .Normal)
        }
        self.view.addSubview(sleepQualityButton)
        
        deviceUsageButton = UIButton(type: UIButtonType.Custom) as UIButton
        deviceUsageButton.backgroundColor = Constants.AppColors.appPurpleColor
//        deviceUsageButton.setTitle("Devices!", forState: .Normal)
        deviceUsageButton.titleLabel!.font = UIFont.systemFontOfSize(26, weight: UIFontWeightUltraLight)
        deviceUsageButton.layer.borderWidth = 0.1
        deviceUsageButton.layer.cornerRadius = 10.0
        deviceUsageButton.clipsToBounds = true
        deviceUsageButton.alpha = 1.0
        deviceUsageButton.addTarget(self, action: #selector(StatsViewController.deviceUsageButtonPressed), forControlEvents: .TouchUpInside)
        deviceUsageButton.frame = CGRectMake(self.view.frame.size.width*0.55, chartsUIView.frame.size.height*0.87, self.view.frame.size.width*0.25, self.view.frame.size.height*0.07)
        if let deviceImage = UIImage(named: "devicesButton") {
            deviceUsageButton.setImage(deviceImage, forState: .Normal)
        }
        self.view.addSubview(deviceUsageButton)
        
        
        lowerView = UIView()
        lowerView.frame = CGRectMake(0, self.view.frame.size.height*0.5, self.view.frame.size.width, self.view.frame.size.height*0.5)
        
        self.view.addSubview(lowerView)
        
        let topBanner = UIView()
        topBanner.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.09)
        topBanner.backgroundColor = Constants.AppColors.appPurpleColor
        lowerView.addSubview(topBanner)
        
        dateLabel.frame = CGRectMake(self.view.frame.size.width*0.1, self.view.frame.size.height*0.01, self.view.frame.size.width*0.5, self.view.frame.size.height*0.07)
        dateLabel.text = "Today"
        dateLabel.font = UIFont.systemFontOfSize(24, weight: UIFontWeightLight)
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.textAlignment = .Left
        topBanner.addSubview(dateLabel)
        
        
        lowerViewBannerActionItemButton = UIButton(type: .System) as UIButton
        lowerViewBannerActionItemButton.frame = CGRectMake(self.view.frame.size.width*0.7, 7, self.view.frame.size.width*0.3, self.view.frame.size.height*0.07)

        lowerViewBannerActionItemButton.backgroundColor = UIColor.clearColor()
        lowerViewBannerActionItemButton.titleLabel?.font = UIFont.systemFontOfSize(18, weight: UIFontWeightLight)
        lowerViewBannerActionItemButton.setTitle("details", forState: .Normal)
        lowerViewBannerActionItemButton.alpha = 0.8
        lowerViewBannerActionItemButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        lowerViewBannerActionItemButton.addTarget(self, action: #selector(StatsViewController.lowerviewOptionButtonPressed), forControlEvents: .TouchUpInside)
        topBanner.addSubview(lowerViewBannerActionItemButton)
        topBanner.bringSubviewToFront(lowerViewBannerActionItemButton)

        
        let swipeRight = UISwipeGestureRecognizer(target: self, action:  #selector(StatsViewController.respondToLowerSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        lowerView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action:  #selector(StatsViewController.respondToLowerSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        lowerView.addGestureRecognizer(swipeLeft)

        
        
        
        timeLineUIView = UIView()
        timeLineUIView.frame = CGRectMake(0, self.view.frame.size.height*0.09, self.view.frame.size.width, lowerView.frame.size.height-self.view.frame.size.height*0.09)
        self.lowerView.addSubview(timeLineUIView)
        
        sleepDetailView = UIView()
        sleepDetailView.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.size.height*0.09, self.view.frame.size.width, lowerView.frame.size.height)
        
        
        self.lowerView.addSubview(sleepDetailView)
        
        
        let sleepDetailNoDataLabel = UILabel()
        sleepDetailNoDataLabel.frame = CGRectMake(self.view.frame.size.width/2 - (self.view.frame.size.width*0.7)/2, sleepDetailView.frame.size.height/2-100, (self.view.frame.size.width*0.7), 100)
        sleepDetailNoDataLabel.text = "The detail data is not ready...sorry"
        sleepDetailNoDataLabel.font = UIFont.systemFontOfSize(16, weight: UIFontWeightLight)
        sleepDetailNoDataLabel.textColor = Constants.AppColors.appRedColor
        sleepDetailNoDataLabel.textAlignment = .Center
        self.sleepDetailView.addSubview(sleepDetailNoDataLabel)
        
        
        longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(StatsViewController.longpressed))
        longPressRecognizer.minimumPressDuration = 1.0
        self.tableView.addGestureRecognizer(longPressRecognizer)
        
        
        // get the sleep quality data from API
        let sleepQualityData = DataService.ds.getUserSleepQualityHistory(defaults.valueForKey("username") as! String)
        
        // get the device usage data from the API
        getDeviceUsageData(defaults.valueForKey("username") as! String, completionHandler: {(UIBackgroundFetchResult) -> Void in
        })
        
        
        // get the current date
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "YYYY-MM-dd"
        let currentDate = dateformatter.stringFromDate(NSDate())
        
        
        getUserTimeLine(defaults.valueForKey("username") as! String, datestr: currentDate, completionHandler: {(UIBackgroundFetchResult) -> Void in
            
            for data in sleepQualityData.valueForKey("efficiency") as! NSArray{
                for sleepData in data as! NSArray{
                    self.sleepDataEntries.addObject(sleepData.valueForKey("efficiency")!)
                    self.sleepQu.addObject(sleepData.valueForKey("date")!)
                }
                self.dateDataEntries = self.sleepQu
                
            }
            for data in self.deviceUsageData.valueForKey("device_usage") as! NSArray{
                for devicedata in data as! NSArray{
                    
                    self.tvDataEntries.addObject(devicedata.valueForKey("tv_duration")!)
                    
                    self.iPadDataEntries.addObject(devicedata.valueForKey("iPad_duration")!)
                    self.iPhoneDataEntries.addObject(devicedata.valueForKey("iPhone_duration")!)
                    
                    self.deviceUse.addObject(devicedata.valueForKey("date")!)
                }
                self.deviceDateEntries = self.deviceUse
            }
            
            for data in self.timeLineFetchData.valueForKey("objects_for_timeline") as! NSArray{
                for item in data as! NSArray{
                    self.timeLineData.addObject(item)
                }
            }
            
            self.setupSleepChart()
            self.setupTimeLineView()
            
            
            
            self.progressHUD.removeFromSuperview()
        })
        
        // set the chart delegate
        sleepChartView.delegate = self
        
        foodTypePickerView.delegate = self
//        foodTypePickerView.dataSource = self
        
        setupIntakeLogPopUPView()
        setupDeviceLogPopUPView()

    
    }
    
    func getDeviceUsageData(username:String,completionHandler:((UIBackgroundFetchResult) -> Void)!){
        
        let deviceArray = NSMutableArray()
        let getURL = "https://nott.herokuapp.com/" + "get_device_usage_chart?user_name=" + username
        
        Alamofire.request(.GET,getURL , parameters: nil)
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    if let JSON = response.result.value {
                        deviceArray.addObject(JSON)
                        completionHandler(UIBackgroundFetchResult.NewData)
                    }
                case .Failure(let error):
                    print("Request failed with error : \(error)")
                }

        }
        
        deviceUsageData = deviceArray

        
    }
    
    
    func getUserTimeLine(username:String,datestr:String,completionHandler:((UIBackgroundFetchResult) -> Void)!){
        
        progressHUD = ProgressHUD(text: "Loading Data")
        self.view.addSubview(progressHUD)
        self.view.bringSubviewToFront(progressHUD)
        
        
        let dayTimeLine = NSMutableArray()

        let getURL = "https://nott.herokuapp.com/" + "get_timeline_for_day?user_name=" + username + "&date_str=" + datestr
        
        Alamofire.request(.GET,getURL , parameters: nil)
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    if let JSON = response.result.value {
                        dayTimeLine.addObject(JSON)
                        completionHandler(UIBackgroundFetchResult.NewData)
                    }
                case .Failure(let error):
                    print("Request failed with error : \(error)")
                }
        }
        
        timeLineFetchData = dayTimeLine
    }
    
    
    func longpressed(gestureRecognizer:UILongPressGestureRecognizer){
        
        let cellCGPoint = gestureRecognizer.locationInView(self.tableView)
        let cellIndexPath = self.tableView.indexPathForRowAtPoint(cellCGPoint)
        
        if cellIndexPath == nil{
            print("longpress detected but not on tableviewcell")
            
        }else{
            print("longpress detected on cell")
            if (timeLineData[(cellIndexPath?.row)!].valueForKey("type")!) as! String == "activity" {
                self.username = defaults.valueForKey("username") as! String
                self.activity_id = (timeLineData[(cellIndexPath?.row)!].valueForKey("id")!) as! Int
                let activity_type = (timeLineData[(cellIndexPath?.row)!].valueForKey("activity_type")!)
                let start_time = (timeLineData[(cellIndexPath?.row)!].valueForKey("start_time")!)
                let end_time = (timeLineData[(cellIndexPath?.row)!].valueForKey("end_time")!)
                
                
                deviceStartTimeTextField.text = start_time as! String
                deviceEndTimeTextField.text = end_time as! String
                if (activity_type as! String) == "iPad"{
                    deviceImage = UIImage(named: "iPad_icon")
                    deviceImageView.image = deviceImage
                    deviceToLog = "iPad"
                }else if (activity_type as! String) == "iPhone"{
                    deviceImage = UIImage(named: "iPhone_icon")
                    deviceImageView.image = deviceImage
                    deviceToLog = "iPad"
                }else if (activity_type as! String) == "tv"{
                    deviceImage = UIImage(named: "tv_icon")
                    deviceImageView.image = deviceImage
                    deviceToLog = "iPad"
                }
//
                self.view.bringSubviewToFront(self.deviceLogViewPopUP)
                UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn, animations: {
                    self.deviceLogViewPopUP.frame = CGRectMake(0, self.view.frame.size.height*0.45, self.view.frame.size.width, self.view.frame.size.height*0.55)
                    }, completion: { finished in
                })

                
            }else{
                
                self.view.bringSubviewToFront(self.intakeLogViewPopUp)
                self.username = defaults.valueForKey("username") as! String
                self.food_id = (timeLineData[(cellIndexPath?.row)!].valueForKey("id")!) as! Int
                let food_type = (timeLineData[(cellIndexPath?.row)!].valueForKey("type")!)
                let title = (timeLineData[(cellIndexPath?.row)!].valueForKey("title")!)
                self.score = (timeLineData[(cellIndexPath?.row)!].valueForKey("score")!) as! Int
//                let grams = 0
                let base64String = (timeLineData[(cellIndexPath?.row)!].valueForKey("picture")!)
//                let base64String = item["image"] as! String
                let decodedData = NSData(base64EncodedString: base64String as! String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                let decodedimage = UIImage(data: decodedData!)
                if decodedimage != nil{
                    self.mealPhotoImage = decodedimage! as UIImage
                    mealPhotoImageView.image = mealPhotoImage
                }

                
                
                let timestamp = (timeLineData[(cellIndexPath?.row)!].valueForKey("timestamp")!)
                
                foodTypePickerTextfield.text = food_type as? String
                intakeTitleTextfield.text = title as? String
                intakeTimeTextfield.text = timestamp as? String
                
                
                UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn, animations: {
                    self.intakeLogViewPopUp.frame = CGRectMake(0, self.view.frame.size.height*0.45, self.view.frame.size.width, self.view.frame.size.height*0.55)
                    }, completion: { finished in
                })

                

            }
        }
        
    }
    
    func sleepQualityButtonPressed(){
        sleepQualityButton.alpha = 0.7
        deviceUsageButton.alpha = 1.0
        sleepQualityButton.enabled = false
        deviceUsageButton.enabled = true
        self.deviceChartView.removeFromSuperview()
        self.setupSleepChart()
        
    }
    
    func deviceUsageButtonPressed(){
        progressHUD = ProgressHUD(text: "Loading device usage..")
        self.view.addSubview(progressHUD)
        self.view.bringSubviewToFront(progressHUD)
        
        getDeviceUsageData(defaults.valueForKey("username") as! String, completionHandler: {(UIBackgroundFetchResult) -> Void in
            self.sleepQualityButton.enabled = true
            self.deviceUsageButton.enabled = false
            self.sleepQualityButton.alpha = 1.0
            self.deviceUsageButton.alpha = 0.7
            self.sleepChartView.removeFromSuperview()
            self.setupDeviceChart()
            
            self.progressHUD.removeFromSuperview()
            
        })

    }
    
    func lowerviewOptionButtonPressed(){
        if !sleepDetailVisible{
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
                self.sleepDetailView.frame = CGRectMake(0, self.view.frame.size.height*0.09, self.view.frame.size.width, self.lowerView.frame.size.height)
                }, completion: { finished in
            })
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
                self.timeLineUIView.frame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height*0.09, self.view.frame.size.width, self.lowerView.frame.size.height)
                }, completion: { finished in
            })
            sleepDetailVisible = true
            lowerViewBannerActionItemButton.setTitle("timeline", forState: .Normal)
        }else if sleepDetailVisible{
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
                self.sleepDetailView.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.size.height*0.09, self.view.frame.size.width, self.lowerView.frame.size.height)
                }, completion: { finished in
            })
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
                self.timeLineUIView.frame = CGRectMake(0, self.view.frame.size.height*0.09, self.view.frame.size.width, self.lowerView.frame.size.height)
                }, completion: { finished in
            })
            
            sleepDetailVisible = false
            lowerViewBannerActionItemButton.setTitle("details", forState: .Normal)
        }


    }
    
    func respondToLowerSwipeGesture(gesture: UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped right")
                
                if !sleepDetailVisible{
                    UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
                        self.sleepDetailView.frame = CGRectMake(0, self.view.frame.size.height*0.09, self.view.frame.size.width, self.lowerView.frame.size.height)
                        }, completion: { finished in
                    })
                    UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
                        self.timeLineUIView.frame = CGRectMake(self.view.frame.size.width, self.view.frame.size.height*0.09, self.view.frame.size.width, self.lowerView.frame.size.height)
                        }, completion: { finished in
                    })
                    sleepDetailVisible = true
                }
                


            case UISwipeGestureRecognizerDirection.Left:
                print("swiped left")
                if sleepDetailVisible{
                    UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
                        self.sleepDetailView.frame = CGRectMake(-self.view.frame.size.width, self.view.frame.size.height*0.09, self.view.frame.size.width, self.lowerView.frame.size.height)
                        }, completion: { finished in
                    })
                    UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseIn, animations: {
                        self.timeLineUIView.frame = CGRectMake(0, self.view.frame.size.height*0.09, self.view.frame.size.width, self.lowerView.frame.size.height)
                        }, completion: { finished in
                    })
                    
                    sleepDetailVisible = false
                }
                
            default:
                break
                
            }
        }
        
    }
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {

        let chosenDate = String(dateDataEntries[entry.xIndex])
        
        getUserTimeLine(defaults.valueForKey("username") as! String, datestr: chosenDate, completionHandler: {(UIBackgroundFetchResult) -> Void in
            self.timeLineData = NSMutableArray()
            
            self.dateLabel.text = chosenDate

            for data in self.timeLineFetchData.valueForKey("objects_for_timeline") as! NSArray{
                for item in data as! NSArray{
                    self.timeLineData.addObject(item)
                }
            }
            self.tableView.reloadData()
            self.progressHUD.removeFromSuperview()

        })
        
    }
    
    func setupDeviceChart(){
        
        deviceChartView.frame = CGRectMake(self.view.frame.width * 0.03, self.view.frame.size.height * 0.04, self.view.frame.size.width*0.94, self.view.frame.size.height*0.3)
        deviceChartView.tintColor = UIColor.redColor()
        deviceChartView.backgroundColor = UIColor.clearColor()
        deviceChartView.descriptionTextColor = UIColor.blackColor()
        deviceChartView.leftAxis.labelTextColor = UIColor.blackColor()
        deviceChartView.rightAxis.labelTextColor = UIColor.blackColor()
        deviceChartView.xAxis.labelTextColor = UIColor.blackColor()
        deviceChartView.legend.textColor = UIColor.blackColor()
        deviceChartView.noDataText = "there is no data here"
        deviceChartView.descriptionText = ""
        deviceChartView.scaleYEnabled = false
        
        
        var iPhonedataEntries: [BarChartDataEntry] = []
        var tvdataEntries: [BarChartDataEntry] = []
        var iPaddataEntries: [BarChartDataEntry] = []

        
        for i in 0..<deviceDateEntries.count {
            let dataEntry = BarChartDataEntry(value: (self.iPhoneDataEntries[i] as! NSString).doubleValue, xIndex: i)
            iPhonedataEntries.append(dataEntry)
        }
        for i in 0..<deviceDateEntries.count {
            let dataEntry = BarChartDataEntry(value: (self.tvDataEntries[i] as! NSString).doubleValue, xIndex: i)
            tvdataEntries.append(dataEntry)
        }
        for i in 0..<deviceDateEntries.count {
            let dataEntry = BarChartDataEntry(value: (self.iPadDataEntries[i] as! NSString).doubleValue, xIndex: i)
            iPaddataEntries.append(dataEntry)
        }
        
        let iPhonechartDataSet = BarChartDataSet(yVals: iPhonedataEntries, label: "iPhone usage")
        let tvchartDataSet = BarChartDataSet(yVals: tvdataEntries, label: "tv usage")
        let iPadchartDataSet = BarChartDataSet(yVals: iPaddataEntries, label: "iPad usage")
        
        iPhonechartDataSet.valueTextColor = UIColor.clearColor()
        iPadchartDataSet.valueTextColor = UIColor.clearColor()
        tvchartDataSet.valueTextColor = UIColor.clearColor()
        
        iPadchartDataSet.barSpace = 1.5
        
        iPhonechartDataSet.colors = [UIColor.blueColor()]
        iPadchartDataSet.colors = [UIColor.redColor()]
        tvchartDataSet.colors = [UIColor.greenColor()]
    
        let dataSets: [BarChartDataSet] = [iPhonechartDataSet,tvchartDataSet,iPadchartDataSet]
        
        let data = BarChartData(xVals: deviceDateEntries! as? [NSObject], dataSets: dataSets)
        
        deviceChartView.data = data
        
        self.chartsUIView.addSubview(deviceChartView)
    }
    
    func setupSleepChart(){
        self.sleepChartView.rightAxis.enabled = true
        self.sleepChartView.rightAxis.labelTextColor = UIColor.clearColor()
        self.sleepChartView.leftAxis.forceLabelsEnabled = true
        
        let maxScore = 99.0
        self.sleepChartView.leftAxis.customAxisMax = maxScore + 1.0
//        self.sleepChartView.leftAxis.labelCount = (Int(maxScore)+1) 
        self.sleepChartView.leftAxis.labelCount = 5
        
        self.sleepChartView.leftAxis.valueFormatter = NSNumberFormatter()
        self.sleepChartView.leftAxis.valueFormatter?.minimumFractionDigits = 0
        self.sleepChartView.leftAxis.customAxisMin = 0
        
        self.sleepChartView.rightAxis.customAxisMax = maxScore + 1.0
//        self.sleepChartView.rightAxis.labelCount = Int(maxScore)+1
        self.sleepChartView.rightAxis.labelCount = 5
        
        self.sleepChartView.rightAxis.valueFormatter = NSNumberFormatter()
        self.sleepChartView.rightAxis.valueFormatter?.minimumFractionDigits = 0
        self.sleepChartView.rightAxis.customAxisMin = 0
        
        
        self.sleepChartView.descriptionText = ""
        
        self.sleepChartView.scaleYEnabled = false
        self.sleepChartView.moveViewToX(Int(view.frame.width))
        self.sleepChartView.setScaleMinima(5.0, scaleY: 0.0)
        
        var yVals1 : [ChartDataEntry] = [ChartDataEntry]()
        
        for i in 0 ..< dateDataEntries.count {
            yVals1.append(ChartDataEntry(value: sleepDataEntries[i] as! Double, xIndex: i))
        }
        
//        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
        
        
        sleepChartView.frame = CGRectMake(self.view.frame.width * 0.03, self.view.frame.size.height * 0.04, self.view.frame.size.width*0.94, self.view.frame.size.height*0.3)
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
        self.drawTimeLine()
        
        self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.timeLineUIView.frame.size.height)
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "identifier")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clearColor()
//        self.tableView.userInteractionEnabled = false
        self.timeLineUIView.addSubview(self.tableView)
        
        // Refresh Control
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(StatsViewController.refresh), forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)
        
    }
    
    func refresh(){
        refreshTimeLine()
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
            cell.selectionStyle = .None
            return cell
        }else{
            let cell = TimeLineTableViewCell()
            cell.timeLabel.text = (timeLineData[indexPath.row].valueForKey("time") as! String)
            cell.titleLabel.text = titleText
            cell.itemIcon.image = iconImage
            cell.emojiLevelIcon.image = emojiImage
            cell.backgroundColor = UIColor.clearColor()
            cell.selectionStyle = .None
            
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            
            let progressHUD = ProgressHUD(text: "deleting...")
            self.view.addSubview(progressHUD)
            self.view.bringSubviewToFront(progressHUD)
            
            if (timeLineData[indexPath.row].valueForKey("type") as! String) == "activity" {
                
                DataService.ds.delete_activity(defaults.valueForKey("username") as! String, activity_id: (timeLineData[(indexPath.row)].valueForKey("id")!)as! Int)
                
            }else{

                DataService.ds.delete_food(defaults.valueForKey("username") as! String, food_id: (timeLineData[(indexPath.row)].valueForKey("id")!) as! Int)
                
            }
            
            
            getUserTimeLine(defaults.valueForKey("username") as! String, datestr: dateDataEntries[indexPath.row] as! String, completionHandler: {(UIBackgroundFetchResult) -> Void in
                for data in self.timeLineFetchData.valueForKey("objects_for_timeline") as! NSArray{
                    for item in data as! NSArray{
                        self.timeLineData.addObject(item)
                    }
                }
                self.tableView.reloadData()
                progressHUD.removeFromSuperview()
                
            })

        }
    }
    
    func drawTimeLine(){
        let circlePath = UIBezierPath()
        
        circlePath.moveToPoint(CGPoint(x: 52.0, y:0))
        circlePath.addLineToPoint(CGPoint(x: 52.0, y: self.timeLineUIView.frame.size.height))
        
        
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
    
    
    func setupIntakeLogPopUPView()  {
        intakeLogViewPopUp.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*0.6)
        intakeLogViewPopUp.backgroundColor = Constants.AppColors.popBackgroundColor
        self.view.addSubview(self.intakeLogViewPopUp)
        
        self.view.bringSubviewToFront(self.intakeLogViewPopUp)
        
        
        //image view
        mealPhotoImage = UIImage(named: "")
        mealPhotoImageView.image = mealPhotoImage
        mealPhotoImageView.layer.cornerRadius = view.frame.size.height*0.2 / 2
        mealPhotoImageView.translatesAutoresizingMaskIntoConstraints = false
        mealPhotoImageView.clipsToBounds = true
        intakeLogViewPopUp.addSubview(mealPhotoImageView)
        mealPhotoImageView.hidden = false
        
        let mealPhotoImageView_widthConstraint = NSLayoutConstraint(item: mealPhotoImageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: view.frame.size.height*0.2)
        self.view.addConstraint(mealPhotoImageView_widthConstraint)
        
        let mealPhotoImageView_heightConstraint = NSLayoutConstraint(item: mealPhotoImageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: view.frame.size.height*0.2)
        self.view.addConstraint(mealPhotoImageView_heightConstraint)
        
        let mealPhotoImageView_verticalConstraint = NSLayoutConstraint(item: mealPhotoImageView, attribute: .Top, relatedBy: .Equal, toItem: intakeLogViewPopUp, attribute: .Top, multiplier: 1, constant: self.view.frame.size.width*0.1)
        self.view.addConstraint(mealPhotoImageView_verticalConstraint)
        
        let mealPhotoImageView_horizontalConstraint = NSLayoutConstraint(item: mealPhotoImageView, attribute: .Left, relatedBy: .Equal, toItem: intakeLogViewPopUp, attribute: .Left, multiplier: 1, constant:self.view.frame.size.width*0.06)
        self.view.addConstraint(mealPhotoImageView_horizontalConstraint)
        
        
        addIntakeButtonImage = UIImage(named: "noPhoto")
        // add photo button
        addPhotoButton.hidden = true
        addPhotoButton = UIButton(type: UIButtonType.Custom) as UIButton
        addPhotoButton.backgroundColor = UIColor.clearColor()
        addPhotoButton.setImage(addIntakeButtonImage, forState: .Normal)
        //        addPhotoButton.setTitle("add photo", forState: .Normal)
        addPhotoButton.layer.borderWidth = 1.0
        addPhotoButton.layer.cornerRadius = self.view.frame.size.height*0.2 / 2
        
        addPhotoButton.layer.borderColor = Constants.AppColors.graycolor.CGColor
        addPhotoButton.addTarget(self, action: #selector(ViewController.addPhotoButtonPressed), forControlEvents: .TouchUpInside)
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        intakeLogViewPopUp.addSubview(addPhotoButton)
        
        let addPhotoButton_widthConstraint = NSLayoutConstraint(item: addPhotoButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: self.view.frame.size.height * 0.2)
        self.view.addConstraint(addPhotoButton_widthConstraint)
        
        let addPhotoButton_heightConstraint = NSLayoutConstraint(item: addPhotoButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: self.view.frame.size.height * 0.2)
        self.view.addConstraint(addPhotoButton_heightConstraint)
        
        let addPhotoButton_verticalConstraint = NSLayoutConstraint(item: addPhotoButton, attribute: .Top, relatedBy: .Equal, toItem: intakeLogViewPopUp, attribute: .Top, multiplier: 1, constant: self.view.frame.size.width*0.1)
        self.view.addConstraint(addPhotoButton_verticalConstraint)
        
        let addPhotoButton_horizontalConstraint = NSLayoutConstraint(item: addPhotoButton, attribute: .Left, relatedBy: .Equal, toItem: intakeLogViewPopUp, attribute: .Left, multiplier: 1, constant: self.view.frame.size.width*0.06)
        self.view.addConstraint(addPhotoButton_horizontalConstraint)
        
        // food type picker textfield
        foodTypePickerTextfield.attributedPlaceholder = NSAttributedString(string:"type",
                                                                           attributes:[NSForegroundColorAttributeName: Constants.AppColors.graycolor])
        
        foodTypePickerTextfield.font = UIFont.systemFontOfSize(16)
        addDoneButtonOnKeyboard(foodTypePickerTextfield)
        foodTypePickerTextfield.backgroundColor = UIColor.clearColor()
        foodTypePickerTextfield.borderStyle = .RoundedRect
        foodTypePickerTextfield.layer.borderWidth = 1.0
        foodTypePickerTextfield.layer.borderColor = Constants.AppColors.graycolor.CGColor
        foodTypePickerTextfield.layer.cornerRadius = 10.0
        
        foodTypePickerTextfield.textAlignment = .Center
        foodTypePickerTextfield.textColor = UIColor.blackColor()
        foodTypePickerTextfield.translatesAutoresizingMaskIntoConstraints = false
        intakeLogViewPopUp.addSubview(foodTypePickerTextfield)
        
        let foodTypePickerTextfield_widthConstraint = NSLayoutConstraint(item: foodTypePickerTextfield, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: self.view.frame.size.width * 0.5)
        self.view.addConstraint(foodTypePickerTextfield_widthConstraint)
        
        let foodTypePickerTextfield_heightConstraint = NSLayoutConstraint(item: foodTypePickerTextfield, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: self.view.frame.size.height * 0.06)
        self.view.addConstraint(foodTypePickerTextfield_heightConstraint)
        
        let foodTypePickerTextfield_verticalConstraint = NSLayoutConstraint(item: foodTypePickerTextfield, attribute: .Top, relatedBy: .Equal, toItem: intakeLogViewPopUp, attribute: .Top, multiplier: 1, constant: self.view.frame.size.width*0.1)
        self.view.addConstraint(foodTypePickerTextfield_verticalConstraint)
        
        let foodTypePickerTextfield_horizontalConstraint = NSLayoutConstraint(item: foodTypePickerTextfield, attribute: .Left, relatedBy: .Equal, toItem: addPhotoButton, attribute: .Right, multiplier: 1, constant: self.view.frame.size.width*0.04)
        self.view.addConstraint(foodTypePickerTextfield_horizontalConstraint)
        
        
        foodTypePickerView.backgroundColor = UIColor.whiteColor()
        
        foodTypePickerView.showsSelectionIndicator = true
        addDoneButtonOnCountryPicker(foodTypePickerTextfield)
        
        foodTypePickerTextfield.inputView = foodTypePickerView
        
        
        
        // intake title textfield
        intakeTitleTextfield.attributedPlaceholder = NSAttributedString(string:"title",
                                                                        attributes:[NSForegroundColorAttributeName: Constants.AppColors.graycolor])
        
        intakeTitleTextfield.font = UIFont.systemFontOfSize(16)
        addDoneButtonOnKeyboard(intakeTitleTextfield)
        intakeTitleTextfield.backgroundColor = UIColor.clearColor()
        intakeTitleTextfield.borderStyle = .RoundedRect
        intakeTitleTextfield.layer.borderWidth = 1.0
        intakeTitleTextfield.layer.borderColor = Constants.AppColors.graycolor.CGColor
        intakeTitleTextfield.layer.cornerRadius = 10.0
        
        intakeTitleTextfield.textAlignment = .Center
        intakeTitleTextfield.textColor = UIColor.blackColor()
        intakeTitleTextfield.translatesAutoresizingMaskIntoConstraints = false
        intakeLogViewPopUp.addSubview(intakeTitleTextfield)
        
        let intakeTitleTextfield_widthConstraint = NSLayoutConstraint(item: intakeTitleTextfield, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: self.view.frame.size.width * 0.5)
        self.view.addConstraint(intakeTitleTextfield_widthConstraint)
        
        let intakeTitleTextfield_heightConstraint = NSLayoutConstraint(item: intakeTitleTextfield, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: self.view.frame.size.height * 0.06)
        self.view.addConstraint(intakeTitleTextfield_heightConstraint)
        
        let intakeTitleTextfield_verticalConstraint = NSLayoutConstraint(item: intakeTitleTextfield, attribute: .CenterY, relatedBy: .Equal, toItem: addPhotoButton, attribute: .CenterY, multiplier: 1, constant: 0)
        self.view.addConstraint(intakeTitleTextfield_verticalConstraint)
        
        let intakeTitleTextfield_horizontalConstraint = NSLayoutConstraint(item: intakeTitleTextfield, attribute: .Left, relatedBy: .Equal, toItem: addPhotoButton, attribute: .Right, multiplier: 1, constant: self.view.frame.size.width*0.04)
        self.view.addConstraint(intakeTitleTextfield_horizontalConstraint)
        
        
        // intake time textfield
        intakeTimeTextfield.attributedPlaceholder = NSAttributedString(string:"time",
                                                                       attributes:[NSForegroundColorAttributeName: Constants.AppColors.graycolor])
        
        intakeTimeTextfield.font = UIFont.systemFontOfSize(16)
        addDoneButtonOnKeyboard(intakeTimeTextfield)
        intakeTimeTextfield.backgroundColor = UIColor.clearColor()
        intakeTimeTextfield.borderStyle = .RoundedRect
        intakeTimeTextfield.layer.borderWidth = 1.0
        intakeTimeTextfield.layer.borderColor = Constants.AppColors.graycolor.CGColor
        intakeTimeTextfield.layer.cornerRadius = 10.0
        setDatePickerOnIntakeTimeTextField(intakeTimeTextfield)
        intakeTimeTextfield.textAlignment = .Center
        intakeTimeTextfield.textColor = UIColor.blackColor()
        intakeTimeTextfield.translatesAutoresizingMaskIntoConstraints = false
        intakeLogViewPopUp.addSubview(intakeTimeTextfield)
        
        let intakeTimeTextfield_widthConstraint = NSLayoutConstraint(item: intakeTimeTextfield, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: self.view.frame.size.width * 0.5)
        self.view.addConstraint(intakeTimeTextfield_widthConstraint)
        
        let intakeTimeTextfield_heightConstraint = NSLayoutConstraint(item: intakeTimeTextfield, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: self.view.frame.size.height * 0.06)
        self.view.addConstraint(intakeTimeTextfield_heightConstraint)
        
        let intakeTimeTextfield_verticalConstraint = NSLayoutConstraint(item: intakeTimeTextfield, attribute: .Bottom, relatedBy: .Equal, toItem: addPhotoButton, attribute: .Bottom, multiplier: 1, constant:  0)
        self.view.addConstraint(intakeTimeTextfield_verticalConstraint)
        
        let intakeTimeTextfield_horizontalConstraint = NSLayoutConstraint(item: intakeTimeTextfield, attribute: .Left, relatedBy: .Equal, toItem: addPhotoButton, attribute: .Right, multiplier: 1, constant: self.view.frame.size.width*0.04)
        self.view.addConstraint(intakeTimeTextfield_horizontalConstraint)
        
        // happy
        let happyImage = UIImage(named: "happyEmoji") as UIImage?
        
        let happy_resizedImage = resizeImage(happyImage!, newWidth: self.view.frame.size.width*0.2)
        
        happyAddButton = UIButton(type: UIButtonType.Custom) as UIButton
        happyAddButton.setImage(happy_resizedImage, forState: .Normal)
        happyAddButton.addTarget(self, action: #selector(StatsViewController.happyButtonPressed), forControlEvents: .TouchUpInside)
        happyAddButton.translatesAutoresizingMaskIntoConstraints = false
        happyAddButton.alpha = 0.3
        intakeLogViewPopUp.addSubview(happyAddButton)
        
        let happyAddButton_widthConstraint = NSLayoutConstraint(item: happyAddButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: (happy_resizedImage.size.width))
        self.view.addConstraint(happyAddButton_widthConstraint)
        
        let happyAddButton_heightConstraint = NSLayoutConstraint(item: happyAddButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: (happy_resizedImage.size.height))
        self.view.addConstraint(happyAddButton_heightConstraint)
        
        let happyAddButton_verticalConstraint = NSLayoutConstraint(item: happyAddButton, attribute: .Top, relatedBy: .Equal, toItem: intakeTimeTextfield, attribute: .Bottom, multiplier: 1, constant: self.view.frame.size.height*0.03)
        self.view.addConstraint(happyAddButton_verticalConstraint)
        
        let happyAddButton_horizontalConstraint = NSLayoutConstraint(item: happyAddButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: -self.view.frame.size.width*0.2)
        self.view.addConstraint(happyAddButton_horizontalConstraint)
        
        // medium
        let mediumImage = UIImage(named: "mediumEmoji") as UIImage?
        
        let medium_resizedImage = resizeImage(mediumImage!, newWidth: self.view.frame.size.width*0.2)
        
        mediumAddButton = UIButton(type: UIButtonType.Custom) as UIButton
        mediumAddButton.setImage(medium_resizedImage, forState: .Normal)
        mediumAddButton.addTarget(self, action: #selector(StatsViewController.mediumButtonPressed), forControlEvents: .TouchUpInside)
        mediumAddButton.translatesAutoresizingMaskIntoConstraints = false
        mediumAddButton.alpha = 0.3
        intakeLogViewPopUp.addSubview(mediumAddButton)
        
        let mediumAddButton_widthConstraint = NSLayoutConstraint(item: mediumAddButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: (medium_resizedImage.size.width))
        self.view.addConstraint(mediumAddButton_widthConstraint)
        
        let mediumAddButton_heightConstraint = NSLayoutConstraint(item: mediumAddButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: (medium_resizedImage.size.height))
        self.view.addConstraint(mediumAddButton_heightConstraint)
        
        let mediumAddButton_verticalConstraint = NSLayoutConstraint(item: mediumAddButton, attribute: .Top, relatedBy: .Equal, toItem: intakeTimeTextfield, attribute: .Bottom, multiplier: 1, constant: self.view.frame.size.height*0.03)
        self.view.addConstraint(mediumAddButton_verticalConstraint)
        
        let mediumAddButton_horizontalConstraint = NSLayoutConstraint(item: mediumAddButton, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
        self.view.addConstraint(mediumAddButton_horizontalConstraint)
        
        // unhappy
        let unhappyImage = UIImage(named: "sadEmoji") as UIImage?
        
        let unhappy_resizedImage = resizeImage(unhappyImage!, newWidth: self.view.frame.size.width*0.2)
        
        unhappyAddButton = UIButton(type: UIButtonType.Custom) as UIButton
        unhappyAddButton.setImage(unhappy_resizedImage, forState: .Normal)
        unhappyAddButton.addTarget(self, action: #selector(StatsViewController.unhappyButtonPressed), forControlEvents: .TouchUpInside)
        unhappyAddButton.translatesAutoresizingMaskIntoConstraints = false
        unhappyAddButton.alpha = 0.3
        intakeLogViewPopUp.addSubview(unhappyAddButton)
        
        let unhappyAddButton_widthConstraint = NSLayoutConstraint(item: unhappyAddButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: (unhappy_resizedImage.size.width))
        self.view.addConstraint(unhappyAddButton_widthConstraint)
        
        let unhappyAddButton_heightConstraint = NSLayoutConstraint(item: unhappyAddButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: (unhappy_resizedImage.size.height))
        self.view.addConstraint(unhappyAddButton_heightConstraint)
        
        let unhappyAddButton_verticalConstraint = NSLayoutConstraint(item: unhappyAddButton, attribute: .Top, relatedBy: .Equal, toItem: intakeTimeTextfield, attribute: .Bottom, multiplier: 1, constant: self.view.frame.size.height*0.03)
        self.view.addConstraint(unhappyAddButton_verticalConstraint)
        
        let unhappyAddButton_horizontalConstraint = NSLayoutConstraint(item: unhappyAddButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: self.view.frame.size.width*0.2)
        self.view.addConstraint(unhappyAddButton_horizontalConstraint)
        
        
        // cancel button
        let cancelButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        cancelButton.setTitle("cancel", forState: .Normal)
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.cornerRadius = 10.0
        cancelButton.layer.borderColor = Constants.AppColors.cancelButtonColor.CGColor
        cancelButton.setTitleColor(Constants.AppColors.cancelButtonColor, forState: .Normal)
        cancelButton.addTarget(self, action: #selector(StatsViewController.cancelIntakeButtonPressed), forControlEvents: .TouchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        intakeLogViewPopUp.addSubview(cancelButton)
        
        let cancelButton_widthConstraint = NSLayoutConstraint(item: cancelButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: self.view.frame.size.width * 0.35)
        self.view.addConstraint(cancelButton_widthConstraint)
        
        let cancelButton_heightConstraint = NSLayoutConstraint(item: cancelButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: self.view.frame.size.height * 0.08)
        self.view.addConstraint(cancelButton_heightConstraint)
        
        let cancelButton_verticalConstraint = NSLayoutConstraint(item: cancelButton, attribute: .Top, relatedBy: .Equal, toItem: unhappyAddButton, attribute: .Bottom, multiplier: 1, constant: view.frame.height*0.03)
        self.view.addConstraint(cancelButton_verticalConstraint)
        
        let cancelButton_horizontalConstraint = NSLayoutConstraint(item: cancelButton, attribute: .Left, relatedBy: .Equal, toItem: intakeLogViewPopUp, attribute: .Left, multiplier: 1, constant: view.frame.width * 0.1)
        self.view.addConstraint(cancelButton_horizontalConstraint)
        
        
        // Submit button
        let submitButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        submitButton.setTitle("Submit", forState: .Normal)
        submitButton.titleLabel!.font = UIFont.systemFontOfSize(26, weight: UIFontWeightUltraLight)
        submitButton.layer.borderWidth = 1.0
        submitButton.layer.cornerRadius = 10.0
        submitButton.layer.borderColor = Constants.AppColors.submitButtonColor.CGColor
        submitButton.setTitleColor(Constants.AppColors.submitButtonColor, forState: .Normal)
        submitButton.addTarget(self, action: #selector(StatsViewController.submitIntakeButtonPressed), forControlEvents: .TouchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        intakeLogViewPopUp.addSubview(submitButton)
        
        let submitButton_widthConstraint = NSLayoutConstraint(item: submitButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: self.view.frame.size.width * 0.35)
        self.view.addConstraint(submitButton_widthConstraint)
        
        let submitButton_heightConstraint = NSLayoutConstraint(item: submitButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: self.view.frame.size.height * 0.08)
        self.view.addConstraint(submitButton_heightConstraint)
        
        let submitButton_verticalConstraint = NSLayoutConstraint(item: submitButton, attribute: .Top, relatedBy: .Equal, toItem: unhappyAddButton, attribute: .Bottom, multiplier: 1, constant: view.frame.height * 0.03)
        self.view.addConstraint(submitButton_verticalConstraint)
        
        let submitButton_horizontalConstraint = NSLayoutConstraint(item: submitButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -(view.frame.width * 0.1))
        self.view.addConstraint(submitButton_horizontalConstraint)
        
    }
    
    
    func setDatePickerOnIntakeTimeTextField(textfield:UITextField){
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        textfield.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(StatsViewController.handleIntakeTimeDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func addDoneButtonOnKeyboard(textField:UITextField){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.BlackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(StatsViewController.doneButtonAction))
        
        done.tintColor = UIColor.whiteColor()
        var items = [AnyObject]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        
        textField.inputAccessoryView = doneToolbar
        
    }
    
    func addDoneButtonOnCountryPicker(textField:UITextField){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.BlackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(ViewController.foodPickerDoneAction))
        
        done.tintColor = UIColor.whiteColor()
        var items = [AnyObject]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()
        
        
        textField.inputAccessoryView = doneToolbar
        
    }

    // MARK: - Camera Action functions
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        mealPhotoImageView.hidden = false
        addPhotoButton.setTitle("", forState: .Normal)
        mealPhotoImage = resizeImage(image, newWidth: view.frame.size.width*0.7)
        
        mealPhotoImageView.image = mealPhotoImage
    }
    
    func addPhotoButtonPressed(){
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        imagePicker.cameraDevice = .Rear
        imagePicker.cameraViewTransform = CGAffineTransformScale(imagePicker.cameraViewTransform, 1,     1)
        
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    // MARK: UIPickerView Functions
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return foodTypeArray.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return self.foodTypeArray[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        selectedFoodType = self.foodTypeArray[row]
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)  {
        //Hide the keyboard
        intakeTimeTextfield.resignFirstResponder()
        intakeTitleTextfield.resignFirstResponder()
        if let touch = touches.first {
            
            let position = touch.locationInView(view)
            print(position)
        }
    }
    
    func cancelIntakeButtonPressed(){
//        blackTransparentOverView.removeFromSuperview()
        UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn, animations: {
            self.intakeLogViewPopUp.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*0.4)
            }, completion: { finished in
                //                self.intakeLogViewPopUp.removeFromSuperview()
        })
        
        // refresh fields
        foodTypePickerTextfield.text = ""
        intakeTimeTextfield.text = ""
        emojiLevel = nil
        mealPhotoImage = nil
        intakeTitleTextfield.text = ""
    }
    
    func handleIntakeTimeDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        intakeTimeTextfield.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func submitIntakeButtonPressed(){
        if foodTypePickerTextfield.text != "" && intakeTitleTextfield.text != "" && mealPhotoImage != nil && intakeTimeTextfield.text != ""{
            let imageData = UIImagePNGRepresentation(mealPhotoImage)
            let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            
            
            DataService.ds.edit_food(self.username, food_id:self.food_id,food_type: foodTypePickerTextfield.text!, title: intakeTitleTextfield.text!, score: self.score, grams: 0, picture: base64String, timestamp: intakeTimeTextfield.text!)
            
            
//            blackTransparentOverView.removeFromSuperview()
            UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn, animations: {
                self.intakeLogViewPopUp.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*0.4)
                }, completion: { finished in
                    print("Intake logpop closed!")
                    //                    self.intakeLogViewPopUp.removeFromSuperview()
            })
            refreshTimeLine()
            
            
            // refresh fields
            foodTypePickerTextfield.text = nil
            intakeTimeTextfield.text = nil
            emojiLevel = nil
            mealPhotoImage = nil
            addIntakeButtonImage = UIImage(named: "noPhoto")
            intakeTimeTextfield.text = nil
        }else{
            print("missing content for log")
//            displayAlertMessage("Oooppss incomplete log", alertDescription: "You have to fill in all fields before submitting")
        }
        
        
        
        
    }
    
    func doneButtonAction(){
        deviceEndTimeTextField.resignFirstResponder()
        deviceStartTimeTextField.resignFirstResponder()
        intakeTitleTextfield.resignFirstResponder()
        intakeTimeTextfield.resignFirstResponder()
    }
    
    func setupDeviceLogPopUPView(){
        deviceLogViewPopUP.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*0.6)
        deviceLogViewPopUP.backgroundColor = Constants.AppColors.popBackgroundColor
        self.view.addSubview(self.deviceLogViewPopUP)
        
        self.view.bringSubviewToFront(self.deviceLogViewPopUP)
        
        //image view
        deviceImageView.layer.cornerRadius = view.frame.size.height*0.2 / 2
        deviceImageView.translatesAutoresizingMaskIntoConstraints = false
        deviceImageView.clipsToBounds = true
        deviceLogViewPopUP.addSubview(deviceImageView)
        
        let deviceImageView_widthConstraint = NSLayoutConstraint(item: deviceImageView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: view.frame.size.height*0.2)
        self.view.addConstraint(deviceImageView_widthConstraint)
        
        let deviceImageView_heightConstraint = NSLayoutConstraint(item: deviceImageView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: view.frame.size.height*0.2)
        self.view.addConstraint(deviceImageView_heightConstraint)
        
        let deviceImageView_verticalConstraint = NSLayoutConstraint(item: deviceImageView, attribute: .Top, relatedBy: .Equal, toItem: deviceLogViewPopUP, attribute: .Top, multiplier: 1, constant: self.view.frame.size.width*0.1)
        self.view.addConstraint(deviceImageView_verticalConstraint)
        
        let deviceImageView_horizontalConstraint = NSLayoutConstraint(item: deviceImageView, attribute: .Left, relatedBy: .Equal, toItem: deviceLogViewPopUP, attribute: .Left, multiplier: 1, constant:self.view.frame.size.width*0.06)
        self.view.addConstraint(deviceImageView_horizontalConstraint)
        
        
        // device start time textfield
        deviceStartTimeTextField.attributedPlaceholder = NSAttributedString(string:"start time",
                                                                            attributes:[NSForegroundColorAttributeName: Constants.AppColors.graycolor])
        
        deviceStartTimeTextField.font = UIFont.systemFontOfSize(16)
        addDoneButtonOnKeyboard(deviceStartTimeTextField)
        deviceStartTimeTextField.backgroundColor = UIColor.clearColor()
        deviceStartTimeTextField.borderStyle = .RoundedRect
        deviceStartTimeTextField.layer.borderWidth = 1.0
        deviceStartTimeTextField.layer.borderColor = Constants.AppColors.graycolor.CGColor
        deviceStartTimeTextField.layer.cornerRadius = 10.0
        setDatePickerOnDeviceStartTimeTextField(deviceStartTimeTextField)
        
        deviceStartTimeTextField.textAlignment = .Center
        deviceStartTimeTextField.textColor = UIColor.blackColor()
        deviceStartTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        deviceLogViewPopUP.addSubview(deviceStartTimeTextField)
        
        let deviceStartTimeTextField_widthConstraint = NSLayoutConstraint(item: deviceStartTimeTextField, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: self.view.frame.size.width * 0.5)
        self.view.addConstraint(deviceStartTimeTextField_widthConstraint)
        
        let deviceStartTimeTextField_heightConstraint = NSLayoutConstraint(item: deviceStartTimeTextField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: self.view.frame.size.height * 0.06)
        self.view.addConstraint(deviceStartTimeTextField_heightConstraint)
        
        let deviceStartTimeTextField_verticalConstraint = NSLayoutConstraint(item: deviceStartTimeTextField, attribute: .Top, relatedBy: .Equal, toItem: deviceImageView, attribute: .Top, multiplier: 1, constant: self.view.frame.size.height * 0.02)
        self.view.addConstraint(deviceStartTimeTextField_verticalConstraint)
        
        let deviceStartTimeTextField_horizontalConstraint = NSLayoutConstraint(item: deviceStartTimeTextField, attribute: .Left, relatedBy: .Equal, toItem: deviceImageView, attribute: .Right, multiplier: 1, constant: self.view.frame.size.width*0.04)
        self.view.addConstraint(deviceStartTimeTextField_horizontalConstraint)
        
        
        // device end time  textfield
        deviceEndTimeTextField.attributedPlaceholder = NSAttributedString(string:"end time",
                                                                          attributes:[NSForegroundColorAttributeName: Constants.AppColors.graycolor])
        
        deviceEndTimeTextField.font = UIFont.systemFontOfSize(16)
        addDoneButtonOnKeyboard(deviceEndTimeTextField)
        deviceEndTimeTextField.backgroundColor = UIColor.clearColor()
        deviceEndTimeTextField.borderStyle = .RoundedRect
        deviceEndTimeTextField.layer.borderWidth = 1.0
        deviceEndTimeTextField.layer.borderColor = Constants.AppColors.graycolor.CGColor
        deviceEndTimeTextField.layer.cornerRadius = 10.0
        setDatePickerOnDeviceEndTimeTextField(deviceEndTimeTextField)
        deviceEndTimeTextField.textAlignment = .Center
        deviceEndTimeTextField.textColor = UIColor.blackColor()
        deviceEndTimeTextField.translatesAutoresizingMaskIntoConstraints = false
        deviceLogViewPopUP.addSubview(deviceEndTimeTextField)
        
        let deviceEndTimeTextField_widthConstraint = NSLayoutConstraint(item: deviceEndTimeTextField, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: self.view.frame.size.width * 0.5)
        self.view.addConstraint(deviceEndTimeTextField_widthConstraint)
        
        let deviceEndTimeTextField_heightConstraint = NSLayoutConstraint(item: deviceEndTimeTextField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: self.view.frame.size.height * 0.06)
        self.view.addConstraint(deviceEndTimeTextField_heightConstraint)
        
        let deviceEndTimeTextField_verticalConstraint = NSLayoutConstraint(item: deviceEndTimeTextField, attribute: .Bottom, relatedBy: .Equal, toItem: deviceImageView, attribute: .Bottom, multiplier: 1, constant:  -self.view.frame.size.height * 0.02)
        self.view.addConstraint(deviceEndTimeTextField_verticalConstraint)
        
        let deviceEndTimeTextField_horizontalConstraint = NSLayoutConstraint(item: deviceEndTimeTextField, attribute: .Left, relatedBy: .Equal, toItem: deviceImageView, attribute: .Right, multiplier: 1, constant: self.view.frame.size.width*0.04)
        self.view.addConstraint(deviceEndTimeTextField_horizontalConstraint)
        
        
        // cancel button
        let cancelButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        cancelButton.setTitle("cancel", forState: .Normal)
        cancelButton.layer.borderWidth = 1.0
        cancelButton.layer.cornerRadius = 10.0
        cancelButton.layer.borderColor = Constants.AppColors.cancelButtonColor.CGColor
        cancelButton.setTitleColor(Constants.AppColors.cancelButtonColor, forState: .Normal)
        cancelButton.addTarget(self, action: #selector(StatsViewController.cancelDeviceButtonPressed), forControlEvents: .TouchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        deviceLogViewPopUP.addSubview(cancelButton)
        
        let cancelButton_widthConstraint = NSLayoutConstraint(item: cancelButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: self.view.frame.size.width * 0.35)
        self.view.addConstraint(cancelButton_widthConstraint)
        
        let cancelButton_heightConstraint = NSLayoutConstraint(item: cancelButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: self.view.frame.size.height * 0.08)
        self.view.addConstraint(cancelButton_heightConstraint)
        
        let cancelButton_verticalConstraint = NSLayoutConstraint(item: cancelButton, attribute: .Top, relatedBy: .Equal, toItem: deviceImageView, attribute: .Bottom, multiplier: 1, constant: view.frame.height*0.1)
        self.view.addConstraint(cancelButton_verticalConstraint)
        
        let cancelButton_horizontalConstraint = NSLayoutConstraint(item: cancelButton, attribute: .Left, relatedBy: .Equal, toItem: deviceLogViewPopUP, attribute: .Left, multiplier: 1, constant: view.frame.width * 0.1)
        self.view.addConstraint(cancelButton_horizontalConstraint)
        
        
        // Submit button
        let submitButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        //        submitButton.backgroundColor =
        submitButton.setTitle("Submit", forState: .Normal)
        submitButton.titleLabel!.font = UIFont.systemFontOfSize(26, weight: UIFontWeightUltraLight)
        submitButton.layer.borderWidth = 1.0
        submitButton.layer.cornerRadius = 10.0
        submitButton.layer.borderColor = Constants.AppColors.submitButtonColor.CGColor
        submitButton.setTitleColor(Constants.AppColors.submitButtonColor, forState: .Normal)
        submitButton.addTarget(self, action: #selector(StatsViewController.submitDeviceLogButtonPressed), forControlEvents: .TouchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        deviceLogViewPopUP.addSubview(submitButton)
        
        let submitButton_widthConstraint = NSLayoutConstraint(item: submitButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: self.view.frame.size.width * 0.35)
        self.view.addConstraint(submitButton_widthConstraint)
        
        let submitButton_heightConstraint = NSLayoutConstraint(item: submitButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: self.view.frame.size.height * 0.08)
        self.view.addConstraint(submitButton_heightConstraint)
        
        let submitButton_verticalConstraint = NSLayoutConstraint(item: submitButton, attribute: .Top, relatedBy: .Equal, toItem: deviceImageView, attribute: .Bottom, multiplier: 1, constant: view.frame.height * 0.1)
        self.view.addConstraint(submitButton_verticalConstraint)
        
        let submitButton_horizontalConstraint = NSLayoutConstraint(item: submitButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: -(view.frame.width * 0.1))
        self.view.addConstraint(submitButton_horizontalConstraint)
        
    }

    func setDatePickerOnDeviceStartTimeTextField(textfield:UITextField){
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        textfield.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(StatsViewController.handleDeviceStartTimeDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func handleDeviceStartTimeDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        deviceStartTimeTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func setDatePickerOnDeviceEndTimeTextField(textfield:UITextField){
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        textfield.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(StatsViewController.handleDeviceEndTimeDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func handleDeviceEndTimeDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        deviceEndTimeTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func submitDeviceLogButtonPressed(){
        
        if deviceStartTimeTextField.text != "" && deviceEndTimeTextField.text != ""{

            DataService.ds.editActivity(defaults.valueForKey("username") as! String, activity_id: self.activity_id, activity_type: deviceToLog, start_time: deviceStartTimeTextField.text!, end_time: deviceEndTimeTextField.text!)
            
            UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn, animations: {
                self.deviceLogViewPopUP.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*0.4)
                }, completion: { finished in
            })
            
            refreshTimeLine()
            
            
            deviceStartTimeTextField.text = ""
            deviceEndTimeTextField.text = ""
            deviceToLog = ""
        }else{
//            displayAlertMessage("Ooopppsss incomplete log", alertDescription: "make sure you fill out both fields")
        }
        
        
    }
    
    func refreshTimeLine(){
        let progressHUD = ProgressHUD(text: "Refreshing Data")
        self.view.addSubview(progressHUD)
        self.view.bringSubviewToFront(progressHUD)
        
        getUserTimeLine(defaults.valueForKey("username") as! String, datestr: dateLabel.text!, completionHandler: {(UIBackgroundFetchResult) -> Void in
            self.timeLineData = NSMutableArray()
            
            
            for data in self.timeLineFetchData.valueForKey("objects_for_timeline") as! NSArray{
                for item in data as! NSArray{
                    self.timeLineData.addObject(item)
                }
            }
            self.tableView.reloadData()
            progressHUD.removeFromSuperview()
            
        })


    }
    
    func cancelDeviceButtonPressed(){
        UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn, animations: {
            self.deviceLogViewPopUP.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*0.4)
            }, completion: { finished in
        })
        
        deviceStartTimeTextField.text = ""
        deviceEndTimeTextField.text = ""
        deviceToLog = ""
    }

    func happyButtonPressed(){
        emojiLevel = 3
        happyAddButton.alpha = 0.9
        mediumAddButton.alpha = 0.3
        unhappyAddButton.alpha = 0.3
        
    }
    
    func mediumButtonPressed(){
        emojiLevel = 2
        happyAddButton.alpha = 0.3
        mediumAddButton.alpha = 0.9
        unhappyAddButton.alpha = 0.3
    }
    
    func unhappyButtonPressed(){
        emojiLevel = 1
        happyAddButton.alpha = 0.3
        mediumAddButton.alpha = 0.3
        unhappyAddButton.alpha = 0.9
    }
    

}
