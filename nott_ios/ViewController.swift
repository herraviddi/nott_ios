//
//  ViewController.swift
//  nott_ios
//
//  Created by Vidar Fridriksson on 30/03/16.
//  Copyright © 2016 hideout. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UINavigationControllerDelegate{

    // MOCK DATA!
    
    var percentagePrediction = 0.92 as CGFloat!
    
    var intakeItems = NSMutableArray()
    
    // END OF MOCK DATA!
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    var imagePicker = UIImagePickerController()

    var circleDiagram = CircleDiagram()
    
    var screenHeight:CGFloat!
    
    var predictionView:UIView!
    
    var vertical_split_intake:UIImageView!
    var vertical_split_device:UIImageView!
    
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
    
    
    
    var deviceImage:UIImage!
    var deviceImageView = UIImageView()
    
    var iPadAddButton:UIButton!
    var iPhoneAddButton:UIButton!
    var tvAddButton:UIButton!
    var deviceAddButton:UIButton!
    
    var deviceStartTimeTextField = UITextField()
    var deviceEndTimeTextField = UITextField()
    var deviceToLog:String!
    
    

    
    var intakeLogViewPopUp = UIView()
    var deviceLogViewPopUP = UIView()

    var blackTransparentOverView = UIView()
    
    var popularIntakeImage:UIImage!
    var secondPopularIntakeImage:UIImage!
    var thirdPopularIntakeImage:UIImage!
    
    
    var top3food = NSMutableArray()
    
    var popularTitle:String!
    var popularType:String!
    var secondTitle:String!
    var secondType:String!
    var thirdTitle:String!
    var thirdType:String!
    var popularFood:NSMutableArray!
    
    
    var progressHUD:ProgressHUD!
    
    
    func getFrequentFood(username:String,completionHandler:((UIBackgroundFetchResult) -> Void)!){
        
        progressHUD = ProgressHUD(text: "Loading Data")
        self.view.addSubview(progressHUD)
        self.view.bringSubviewToFront(progressHUD)
        
        let getURL = "https://nott.herokuapp.com/" + "get_frequent_food?user_name=" + username
        
        let foodListArray = NSMutableArray()
        Alamofire.request(.GET,getURL , parameters: nil)
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    if let JSON = response.result.value {
                        foodListArray.addObject(JSON)
                        completionHandler(UIBackgroundFetchResult.NewData)
                    }
                case .Failure(let error):
                    print("Request failed with error : \(error)")
                }
        }
        
        self.popularFood = foodListArray
    }
    
    func loadUI(){
    
        for food in self.popularFood.valueForKey("top3_food") as! NSArray{
            for item in food as! NSArray{
                self.intakeItems.addObject(["id":(item["id"] as! Int),"order":(item["order"] as! Int),"title":(item["title"] as! String),"image":(item["picture"] as! String),"type":(item["type"] as! String)])
            }
        }
        
        for item in self.intakeItems{
            if item["order"] as! Int == 0{
                self.popularTitle = item["title"] as! String
                self.popularType = item["type"] as! String
                let base64String = item["image"] as! String
                let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                let decodedimage = UIImage(data: decodedData!)
                if decodedimage != nil{
                    self.popularIntakeImage = decodedimage! as UIImage
                }
                
            }
            if item["order"] as! Int == 1{
                self.secondTitle = item["title"] as! String
                self.secondType = item["type"] as! String
                let base64String = item["image"] as! String
                let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                let decodedimage = UIImage(data: decodedData!)
                if decodedimage != nil{
                    self.secondPopularIntakeImage = decodedimage! as UIImage
                }
            }
            if item["order"] as! Int == 2{
                self.thirdTitle = item["title"] as! String
                self.thirdType = item["type"] as! String
                let base64String = item["image"] as! String
                let decodedData = NSData(base64EncodedString: base64String, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                let decodedimage = UIImage(data: decodedData!)
                if decodedimage != nil{
                    self.thirdPopularIntakeImage = decodedimage! as UIImage
                }
            }
        }
        
        progressHUD.removeFromSuperview()
        self.setupIntakeLogginView()
        self.setupDeviceLoggingView()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.getFrequentFood(defaults.valueForKey("username") as! String, completionHandler:{(UIBackgroundFetchResult) -> Void in
            
            print("success")
            self.loadUI()
            
        })
        
        // get the devices screenheight
        screenHeight = UIScreen.mainScreen().bounds.height
        
        navbarSetup()
        mainUISetup()
        predictionViewSetup()

        foodTypePickerView.delegate = self
        foodTypePickerView.dataSource = self
        setupIntakeLogPopUPView()
        setupDeviceLogPopUPView()

    }

    // MARK: - UI Setup
    
    func mainUISetup(){
        self.view.backgroundColor = UIColor.whiteColor()
//        self.view.backgroundColor = Constants.AppColors.appRedColor

    }
    
    func navbarSetup(){
        self.title = defaults.valueForKey("username") as? String
        self.navigationController?.navigationBarHidden = false
        // removing the horizontal shadow line on the navbar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        // Stats Button in navigation bar
        let statsBtn = UIButton()
        statsBtn.setImage(UIImage(named: "navbar_statsIcon"), forState: .Normal)
        statsBtn.frame = CGRectMake(0, 0, 30, 30)
        statsBtn.addTarget(self, action: #selector(ViewController.statsButtonPressed), forControlEvents: .TouchUpInside)
        
        // Settings Button in navigation bar
        let settingsBtn = UIButton()
        settingsBtn.setImage(UIImage(named: "navbar_settingsIcong"), forState: .Normal)
        settingsBtn.frame = CGRectMake(0, 0, 30, 30)
        settingsBtn.addTarget(self, action: #selector(ViewController.settingsButtonPressed), forControlEvents: .TouchUpInside)
        
        // set the buttons to the navbar
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = statsBtn
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = settingsBtn
        self.navigationItem.leftBarButtonItem = leftBarButton
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func predictionViewSetup(){
        
        let navigationBarHeight: CGFloat = self.navigationController!.navigationBar.frame.height
        
        // create a UIView as the container for the prediction header
        predictionView = UIView()
        predictionView.frame = CGRectMake(0, navigationBarHeight, self.view.frame.size.width, (self.view.frame.size.height/2) - navigationBarHeight)
        
        // Prediction header label
        let predictionHeaderLabel = UILabel()
        predictionHeaderLabel.text = "Sleep Quality Prediction"
        predictionHeaderLabel.font = UIFont.systemFontOfSize(24.0, weight: UIFontWeightLight)
        predictionHeaderLabel.textColor = Constants.AppColors.blueColor
        predictionHeaderLabel.textAlignment = .Center
        predictionHeaderLabel.frame = CGRectMake(0, 30, predictionView.frame.size.width, 40)
        
        predictionView.addSubview(predictionHeaderLabel)

        
        // use the diagram class I created and set the values for the circle diagram
        circleDiagram.arcBackgroundColor = Constants.AppColors.graycolor
        circleDiagram.backgroundColor = UIColor.clearColor()
        circleDiagram.arcWidth = 35.0 // width of the diagmra
        circleDiagram.endArc = percentagePrediction // the amount
        circleDiagram.arcColor = Constants.AppColors.blueColor // the color of the diagram
        circleDiagram.frame = CGRectMake((predictionView.frame.size.width/4), predictionView.frame.size.height/4, predictionView.frame.size.width/2, predictionView.frame.size.width/2)
        
        predictionView.addSubview(circleDiagram)
        
        // Percentage Label inside the diagram
        let percentageLabel = UILabel()
        percentageLabel.text = String(percentagePrediction*100) + "%"
        percentageLabel.font = UIFont.systemFontOfSize(24.0, weight: UIFontWeightLight)
        percentageLabel.textColor = Constants.AppColors.blueColor
        percentageLabel.textAlignment = .Center
        percentageLabel.frame = CGRectMake(predictionView.frame.size.width/2 - 40, predictionView.frame.size.height/2, 80, 40)
        
        predictionView.addSubview(percentageLabel)

        // Reason for prediction text
        let reasonTextLabel = UILabel()
        reasonTextLabel.text = "* Extensive iPad use within an hour before bedtime"
        reasonTextLabel.font = UIFont.systemFontOfSize(12.0, weight: UIFontWeightLight)
        reasonTextLabel.textColor = Constants.AppColors.redTextColor
        reasonTextLabel.textAlignment = .Center
        reasonTextLabel.frame = CGRectMake(0, predictionView.frame.size.height - 30, predictionView.frame.size.width, 40)
        
        predictionView.addSubview(reasonTextLabel)
        
        
        self.view.addSubview(predictionView)
    }
    
    func setupIntakeLogginView(){
        // set the intake divider label and image
        // vertical split line
        vertical_split_intake =  UIImageView()
        vertical_split_intake.image = UIImage(named: "vertical_doublesplit_line")
        vertical_split_intake.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(vertical_split_intake)
        
        let vertical_split_intake_widthConstraint = NSLayoutConstraint(item: vertical_split_intake, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: self.view.frame.width)
        self.view.addConstraint(vertical_split_intake_widthConstraint)
        
        let vertical_split_intake_heightConstraint = NSLayoutConstraint(item: vertical_split_intake, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: self.view.frame.height*0.05)
        self.view.addConstraint(vertical_split_intake_heightConstraint)
        
        let vertical_split_intake_verticalConstraint = NSLayoutConstraint(item: vertical_split_intake, attribute: .Top, relatedBy: .Equal, toItem: predictionView, attribute: .Bottom, multiplier: 1, constant: self.view.frame.height*0.02)
        self.view.addConstraint(vertical_split_intake_verticalConstraint)
        
        let vertical_split_intake_horizontalConstraint = NSLayoutConstraint(item: vertical_split_intake, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
        self.view.addConstraint(vertical_split_intake_horizontalConstraint)
        
        let or_label = UILabel()
        or_label.text = "intake"
        or_label.textColor = Constants.AppColors.graycolor
        //        or_label.font = textFont
        or_label.textAlignment = .Center
        or_label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(or_label)
        
        let or_label_widthConstraint = NSLayoutConstraint(item: or_label, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 100)
        self.view.addConstraint(or_label_widthConstraint)
        
        let or_label_heightConstraint = NSLayoutConstraint(item: or_label, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: 50)
        self.view.addConstraint(or_label_heightConstraint)
        
        let or_label_verticalConstraint = NSLayoutConstraint(item: or_label, attribute: .CenterY, relatedBy: .Equal, toItem: vertical_split_intake, attribute: .CenterY, multiplier: 1, constant: -5)
        self.view.addConstraint(or_label_verticalConstraint)
        
        let or_label_horizontalConstraint = NSLayoutConstraint(item: or_label, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        self.view.addConstraint(or_label_horizontalConstraint)
        
        // second popular Button
        
        let secondPopularIntakeImageAddButton = UIButton(type: UIButtonType.Custom) as UIButton

        if (secondPopularIntakeImage != nil){
            let resizedImage_secondPopularIntake = resizeImage(secondPopularIntakeImage!, newWidth: self.view.frame.size.width*0.4)
            secondPopularIntakeImageAddButton.setImage(resizedImage_secondPopularIntake, forState: .Normal)
        }else{
            secondPopularIntakeImageAddButton.setTitle("2", forState: .Normal)
            secondPopularIntakeImageAddButton.enabled = false
        }
        
        secondPopularIntakeImageAddButton.addTarget(self, action: #selector(ViewController.addIntakeButtonPressed), forControlEvents: .TouchUpInside)
        secondPopularIntakeImageAddButton.layer.cornerRadius = self.view.frame.size.width*0.2/2
        secondPopularIntakeImageAddButton.clipsToBounds = true
        secondPopularIntakeImageAddButton.layer.borderColor = UIColor.blackColor().CGColor
        secondPopularIntakeImageAddButton.layer.borderWidth = 0.8
        secondPopularIntakeImageAddButton.tag = 2
        secondPopularIntakeImageAddButton.contentMode = UIViewContentMode.ScaleAspectFill
        secondPopularIntakeImageAddButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(secondPopularIntakeImageAddButton)
        
        let secondPopularIntakeImageAddButton_widthConstraint = NSLayoutConstraint(item: secondPopularIntakeImageAddButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: self.view.frame.size.width*0.2)
        self.view.addConstraint(secondPopularIntakeImageAddButton_widthConstraint)
        
        let secondPopularIntakeImageAddButton_heightConstraint = NSLayoutConstraint(item: secondPopularIntakeImageAddButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: self.view.frame.size.width*0.2)
        self.view.addConstraint(secondPopularIntakeImageAddButton_heightConstraint)
        
        let secondPopularIntakeImageAddButton_verticalConstraint = NSLayoutConstraint(item: secondPopularIntakeImageAddButton, attribute: .Top, relatedBy: .Equal, toItem: vertical_split_intake, attribute: .Bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(secondPopularIntakeImageAddButton_verticalConstraint)
        
        let secondPopularIntakeImageAddButton_horizontalConstraint = NSLayoutConstraint(item: secondPopularIntakeImageAddButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: -self.view.frame.size.width * 0.015)
        self.view.addConstraint(secondPopularIntakeImageAddButton_horizontalConstraint)
        
        
        // first popular Button
        let popularIntakeImageAddButton = UIButton(type: UIButtonType.Custom) as UIButton

        if (popularIntakeImage != nil){
            let resizedImage_popularIntakeImage = resizeImage(popularIntakeImage!, newWidth: self.view.frame.size.width*0.4)
            popularIntakeImageAddButton.setImage(resizedImage_popularIntakeImage, forState: .Normal)
        }else{
            popularIntakeImageAddButton.setTitle("1", forState: .Normal)
            popularIntakeImageAddButton.enabled = false
        }
        
        popularIntakeImageAddButton.addTarget(self, action: #selector(ViewController.addIntakeButtonPressed), forControlEvents: .TouchUpInside)
        popularIntakeImageAddButton.layer.cornerRadius = self.view.frame.size.width*0.2/2
        popularIntakeImageAddButton.clipsToBounds = true
        popularIntakeImageAddButton.layer.borderColor = UIColor.blackColor().CGColor
        popularIntakeImageAddButton.layer.borderWidth = 0.8
        popularIntakeImageAddButton.tag = 1
        popularIntakeImageAddButton.contentMode = UIViewContentMode.ScaleAspectFill
        popularIntakeImageAddButton.translatesAutoresizingMaskIntoConstraints = false
        

        self.view.addSubview(popularIntakeImageAddButton)
        
        let popularIntakeImageAddButton_widthConstraint = NSLayoutConstraint(item: popularIntakeImageAddButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant:self.view.frame.size.width*0.2)
        self.view.addConstraint(popularIntakeImageAddButton_widthConstraint)
        
        let popularIntakeImageAddButton_heightConstraint = NSLayoutConstraint(item: popularIntakeImageAddButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: self.view.frame.size.width*0.2)
        self.view.addConstraint(popularIntakeImageAddButton_heightConstraint)
        
        let popularIntakeImageAddButton_verticalConstraint = NSLayoutConstraint(item: popularIntakeImageAddButton, attribute: .Top, relatedBy: .Equal, toItem: vertical_split_intake, attribute: .Bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(popularIntakeImageAddButton_verticalConstraint)
        
        let popularIntakeImageAddButton_horizontalConstraint = NSLayoutConstraint(item: popularIntakeImageAddButton, attribute: .Right, relatedBy: .Equal, toItem: secondPopularIntakeImageAddButton, attribute: .CenterX, multiplier: 1, constant: -self.view.frame.size.width * 0.12)
        self.view.addConstraint(popularIntakeImageAddButton_horizontalConstraint)
        
        
        // third popular Button
        let thirdPopularIntakeAddButton = UIButton(type: UIButtonType.Custom) as UIButton
        
        if thirdPopularIntakeImage != nil{
            let resized_thirdPopularIntakeImage = resizeImage(thirdPopularIntakeImage!, newWidth: self.view.frame.size.width*0.4)
            
            thirdPopularIntakeAddButton.setImage(resized_thirdPopularIntakeImage, forState: .Normal)
    
        }else{
            thirdPopularIntakeAddButton.setTitle("3", forState: .Normal)
            thirdPopularIntakeAddButton.enabled = false
        }
        thirdPopularIntakeAddButton.addTarget(self, action: #selector(ViewController.addIntakeButtonPressed), forControlEvents: .TouchUpInside)
        thirdPopularIntakeAddButton.layer.cornerRadius = self.view.frame.size.width*0.2/2
        thirdPopularIntakeAddButton.clipsToBounds = true
        thirdPopularIntakeAddButton.layer.borderColor = UIColor.blackColor().CGColor
        thirdPopularIntakeAddButton.layer.borderWidth = 0.8
        thirdPopularIntakeAddButton.tag = 3
        thirdPopularIntakeAddButton.contentMode = UIViewContentMode.ScaleAspectFill
        thirdPopularIntakeAddButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(thirdPopularIntakeAddButton)
        
        let thirdPopularIntakeAddButton_widthConstraint = NSLayoutConstraint(item: thirdPopularIntakeAddButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: self.view.frame.size.width*0.2)
        self.view.addConstraint(thirdPopularIntakeAddButton_widthConstraint)
        
        let thirdPopularIntakeAddButton_heightConstraint = NSLayoutConstraint(item: thirdPopularIntakeAddButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: self.view.frame.size.width*0.2)
        self.view.addConstraint(thirdPopularIntakeAddButton_heightConstraint)
        
        let thirdPopularIntakeAddButton_verticalConstraint = NSLayoutConstraint(item: thirdPopularIntakeAddButton, attribute: .Top, relatedBy: .Equal, toItem: vertical_split_intake, attribute: .Bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(thirdPopularIntakeAddButton_verticalConstraint)
        
        let thirdPopularIntakeAddButton_horizontalConstraint = NSLayoutConstraint(item: thirdPopularIntakeAddButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: self.view.frame.size.width * 0.015)
        self.view.addConstraint(thirdPopularIntakeAddButton_horizontalConstraint)
//
        
        // intakeAddButton
        let image = UIImage(named: "plusButtonImage") as UIImage?
        
        let resizedImage = resizeImage(image!, newWidth: self.view.frame.size.width*0.2)
        
        
        let intakeAddButton = UIButton(type: UIButtonType.Custom) as UIButton
        intakeAddButton.setImage(resizedImage, forState: .Normal)
        intakeAddButton.addTarget(self, action: #selector(ViewController.addIntakeButtonPressed), forControlEvents: .TouchUpInside)
        intakeAddButton.translatesAutoresizingMaskIntoConstraints = false
        intakeAddButton.tag = 0
        self.view.addSubview(intakeAddButton)
        
        let intakeAddButton_widthConstraint = NSLayoutConstraint(item: intakeAddButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: (resizedImage.size.width))
        self.view.addConstraint(intakeAddButton_widthConstraint)
        
        let intakeAddButton_heightConstraint = NSLayoutConstraint(item: intakeAddButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: (resizedImage.size.height))
        self.view.addConstraint(intakeAddButton_heightConstraint)
        
        let intakeAddButton_verticalConstraint = NSLayoutConstraint(item: intakeAddButton, attribute: .Top, relatedBy: .Equal, toItem: vertical_split_intake, attribute: .Bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(intakeAddButton_verticalConstraint)
        
        let intakeAddButton_horizontalConstraint = NSLayoutConstraint(item: intakeAddButton, attribute: .Left, relatedBy: .Equal, toItem: thirdPopularIntakeAddButton, attribute: .CenterX, multiplier: 1, constant: self.view.frame.size.width*0.12)
        self.view.addConstraint(intakeAddButton_horizontalConstraint)
        
        
    }
    
    func setupDeviceLoggingView(){
        // set the intake divider label and image
        // vertical split line
        vertical_split_device =  UIImageView()
        vertical_split_device.image = UIImage(named: "vertical_doublesplit_line")
        vertical_split_device.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(vertical_split_device)
        
        let vertical_split_intake_widthConstraint = NSLayoutConstraint(item: vertical_split_device, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: self.view.frame.width)
        self.view.addConstraint(vertical_split_intake_widthConstraint)
        
        let vertical_split_intake_heightConstraint = NSLayoutConstraint(item: vertical_split_device, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: self.view.frame.height*0.05)
        self.view.addConstraint(vertical_split_intake_heightConstraint)
        
        let vertical_split_intake_verticalConstraint = NSLayoutConstraint(item: vertical_split_device, attribute: .Top, relatedBy: .Equal, toItem: vertical_split_intake, attribute: .Bottom, multiplier: 1, constant: self.view.frame.height*0.15)
        self.view.addConstraint(vertical_split_intake_verticalConstraint)
        
        let vertical_split_intake_horizontalConstraint = NSLayoutConstraint(item: vertical_split_device, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
        self.view.addConstraint(vertical_split_intake_horizontalConstraint)
        
        let or_label = UILabel()
        or_label.text = "device use"
        or_label.textColor = Constants.AppColors.graycolor
        //        or_label.font = textFont
        or_label.textAlignment = .Center
        or_label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(or_label)
        
        let or_label_widthConstraint = NSLayoutConstraint(item: or_label, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: 100)
        self.view.addConstraint(or_label_widthConstraint)
        
        let or_label_heightConstraint = NSLayoutConstraint(item: or_label, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: 50)
        self.view.addConstraint(or_label_heightConstraint)
        
        let or_label_verticalConstraint = NSLayoutConstraint(item: or_label, attribute: .CenterY, relatedBy: .Equal, toItem: vertical_split_device, attribute: .CenterY, multiplier: 1, constant: -5)
        self.view.addConstraint(or_label_verticalConstraint)
        
        let or_label_horizontalConstraint = NSLayoutConstraint(item: or_label, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 0)
        self.view.addConstraint(or_label_horizontalConstraint)
        

        
        // iPad Button
        let iPadImage = UIImage(named: "iPad_icon") as UIImage?
        
        let resizedImage_iPad = resizeImage(iPadImage!, newWidth: self.view.frame.size.width*0.2)
        
        iPadAddButton = UIButton(type: UIButtonType.Custom) as UIButton
        iPadAddButton.setImage(resizedImage_iPad, forState: .Normal)
        iPadAddButton.addTarget(self, action: #selector(ViewController.addDeviceUseButtonPressed(_:)), forControlEvents: .TouchUpInside)
        iPadAddButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(iPadAddButton)
        
        let iPadAddButton_widthConstraint = NSLayoutConstraint(item: iPadAddButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: (resizedImage_iPad.size.width))
        self.view.addConstraint(iPadAddButton_widthConstraint)
        
        let iPadAddButton_heightConstraint = NSLayoutConstraint(item: iPadAddButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: (resizedImage_iPad.size.height))
        self.view.addConstraint(iPadAddButton_heightConstraint)
        
        let iPadAddButton_verticalConstraint = NSLayoutConstraint(item: iPadAddButton, attribute: .Top, relatedBy: .Equal, toItem: vertical_split_device, attribute: .Bottom, multiplier: 1, constant: self.view.frame.size.height * 0.01)
        self.view.addConstraint(iPadAddButton_verticalConstraint)
        
        let iPadAddButton_horizontalConstraint = NSLayoutConstraint(item: iPadAddButton, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
        self.view.addConstraint(iPadAddButton_horizontalConstraint)
        
        
        // iPhone Button
        let iPhoneImage = UIImage(named: "iPhone_icon") as UIImage?
        
        let resizedImage_iPhone = resizeImage(iPhoneImage!, newWidth: self.view.frame.size.width*0.2)
        
        iPhoneAddButton = UIButton(type: UIButtonType.Custom) as UIButton
        iPhoneAddButton.setImage(resizedImage_iPhone, forState: .Normal)
        iPhoneAddButton.addTarget(self, action: #selector(ViewController.addDeviceUseButtonPressed(_:)), forControlEvents: .TouchUpInside)
        iPhoneAddButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(iPhoneAddButton)
        
        let iPhoneAddButton_widthConstraint = NSLayoutConstraint(item: iPhoneAddButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: (resizedImage_iPhone.size.width))
        self.view.addConstraint(iPhoneAddButton_widthConstraint)
        
        let iPhoneAddButton_heightConstraint = NSLayoutConstraint(item: iPhoneAddButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: (resizedImage_iPhone.size.height))
        self.view.addConstraint(iPhoneAddButton_heightConstraint)
        
        let iPhoneAddButton_verticalConstraint = NSLayoutConstraint(item: iPhoneAddButton, attribute: .Top, relatedBy: .Equal, toItem: vertical_split_device, attribute: .Bottom, multiplier: 1, constant: self.view.frame.size.height * 0.01)
        self.view.addConstraint(iPhoneAddButton_verticalConstraint)
        
        let iPhoneAddButton_horizontalConstraint = NSLayoutConstraint(item: iPhoneAddButton, attribute: .Right, relatedBy: .Equal, toItem: iPadAddButton, attribute: .Left, multiplier: 1, constant: -self.view.frame.size.width * 0.04)
        self.view.addConstraint(iPhoneAddButton_horizontalConstraint)
        
        
        // Television Button
        let televisionImage = UIImage(named: "tv_icon") as UIImage?
        
        let resizedImage_tv = resizeImage(televisionImage!, newWidth: self.view.frame.size.width*0.2)
        
        tvAddButton = UIButton(type: UIButtonType.Custom) as UIButton
        tvAddButton.setImage(resizedImage_tv, forState: .Normal)
        tvAddButton.addTarget(self, action: #selector(ViewController.addDeviceUseButtonPressed(_:)), forControlEvents: .TouchUpInside)
        tvAddButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tvAddButton)
        
        let tvAddButton_widthConstraint = NSLayoutConstraint(item: tvAddButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: (resizedImage_tv.size.width))
        self.view.addConstraint(tvAddButton_widthConstraint)
        
        let tvAddButton_heightConstraint = NSLayoutConstraint(item: tvAddButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: (resizedImage_tv.size.height))
        self.view.addConstraint(tvAddButton_heightConstraint)
        
        let tvAddButton_verticalConstraint = NSLayoutConstraint(item: tvAddButton, attribute: .Top, relatedBy: .Equal, toItem: vertical_split_device, attribute: .Bottom, multiplier: 1, constant: self.view.frame.size.height * 0.01)
        self.view.addConstraint(tvAddButton_verticalConstraint)
        
        let tvAddButton_horizontalConstraint = NSLayoutConstraint(item: tvAddButton, attribute: .Left, relatedBy: .Equal, toItem: iPadAddButton, attribute: .Right, multiplier: 1, constant: self.view.frame.size.width * 0.04)
        self.view.addConstraint(tvAddButton_horizontalConstraint)
        
    }

    func respondToIntakeSwipeDown(gesture:UIGestureRecognizer){
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
                
            case UISwipeGestureRecognizerDirection.Down:
                print("Swiped down")
                
                self.blackTransparentOverView.removeFromSuperview()
                UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn, animations: {
                    self.intakeLogViewPopUp.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*0.4)
                    }, completion: { finished in
                        print("Intake logpop closed!")
                })
                
            default:
                break
                
            }
        }
        
        
        

    }
    
    func respondToDeviceSwipeDown(gesture:UIGestureRecognizer){
        self.blackTransparentOverView.removeFromSuperview()
        UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn, animations: {
            self.deviceLogViewPopUP.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*0.4)
            }, completion: { finished in
                print("Intake logpop closed!")
                //                    self.intakeLogViewPopUp.removeFromSuperview()
        })
    }
    
    
    func setupIntakeLogPopUPView()  {
        intakeLogViewPopUp.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*0.6)
        intakeLogViewPopUp.backgroundColor = Constants.AppColors.popBackgroundColor
        self.view.addSubview(self.intakeLogViewPopUp)
        
        self.view.bringSubviewToFront(self.intakeLogViewPopUp)
        
        
        let swipedownIntake = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.respondToIntakeSwipeDown(_:)))
        swipedownIntake.direction = UISwipeGestureRecognizerDirection.Down
        intakeLogViewPopUp.addGestureRecognizer(swipedownIntake)
        
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
        happyAddButton.addTarget(self, action: #selector(ViewController.happyButtonPressed), forControlEvents: .TouchUpInside)
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
        mediumAddButton.addTarget(self, action: #selector(ViewController.mediumButtonPressed), forControlEvents: .TouchUpInside)
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
        unhappyAddButton.addTarget(self, action: #selector(ViewController.unhappyButtonPressed), forControlEvents: .TouchUpInside)
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
        cancelButton.addTarget(self, action: #selector(ViewController.cancelIntakeButtonPressed), forControlEvents: .TouchUpInside)
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
        submitButton.addTarget(self, action: #selector(ViewController.submitIntakeButtonPressed), forControlEvents: .TouchUpInside)
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
    
    func submitIntakeButtonPressed(){
        if foodTypePickerTextfield.text != "" && intakeTitleTextfield.text != "" && emojiLevel != nil && mealPhotoImage != nil && intakeTimeTextfield.text != ""{
            let imageData = UIImagePNGRepresentation(mealPhotoImage)
            let base64String = imageData!.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
            
            postIntake(defaults.valueForKey("username") as! String, foodType: foodTypePickerTextfield.text!, foodTitle: intakeTitleTextfield.text!, score: emojiLevel, grams: 0, picture: base64String, timeStamp: intakeTimeTextfield.text!, completionHandler:{(UIBackgroundFetchResult) -> Void in
                
                print("success")
                
                self.blackTransparentOverView.removeFromSuperview()
                UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn, animations: {
                    self.intakeLogViewPopUp.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*0.4)
                    }, completion: { finished in
                        print("Intake logpop closed!")
                        //                    self.intakeLogViewPopUp.removeFromSuperview()
                })
                
                
                // refresh fields
                self.foodTypePickerTextfield.text = nil
                self.intakeTimeTextfield.text = nil
                self.emojiLevel = nil
                self.mealPhotoImage = nil
                self.addIntakeButtonImage = UIImage(named: "noPhoto")
                self.intakeTimeTextfield.text = nil
                
                self.progressHUD.removeFromSuperview()

                
            })

            
        }else{
            print("missing content for log")
            displayAlertMessage("Oooppss incomplete log", alertDescription: "You have to fill in all fields before submitting")
        }
        
        
        
       
    }
    
    func postIntake(userName:String,foodType:String,foodTitle:String,score:Int,grams:Int,picture:String,timeStamp:String,completionHandler:((UIBackgroundFetchResult) -> Void)!){
        
        progressHUD = ProgressHUD(text: "Submitting...")
        self.view.addSubview(progressHUD)
        self.view.bringSubviewToFront(progressHUD)
        
        
        let data = [
            "user_name" :userName,
            "food_type" :foodType,
            "title" :foodTitle,
            "score" : score,
            "grams" : grams,
            "picture" : picture,
            "timestamp" : timeStamp
        ]
        
        Alamofire.request(.POST, "https://nott.herokuapp.com/" + "food", parameters:data as? [String : AnyObject] , encoding: .JSON)
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    print("submit success")
                    completionHandler(UIBackgroundFetchResult.NewData)
                case .Failure(let error):
                    print("Request failed with error : \(error)")
                }
        }
        
    }
    
    func submitDeviceLogButtonPressed(){
        
        if deviceStartTimeTextField.text != "" && deviceEndTimeTextField.text != ""{
            
            postActivity(defaults.valueForKey("username") as! String, startTime: deviceStartTimeTextField.text!, endTime: deviceEndTimeTextField.text!, type: deviceToLog, completionHandler: {(UIBackgroundFetchResult) -> Void in

                self.blackTransparentOverView.removeFromSuperview()
                UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn, animations: {
                    self.deviceLogViewPopUP.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*0.4)
                    }, completion: { finished in
                })
            })
    
            deviceStartTimeTextField.text = ""
            deviceEndTimeTextField.text = ""
            deviceToLog = ""
            
            self.progressHUD.removeFromSuperview()

        }else{
            displayAlertMessage("Ooopppsss incomplete log", alertDescription: "make sure you fill out both fields")
        }
        
        
    }
    
    func postActivity(userName:String,startTime:String,endTime:String,type:String,completionHandler:((UIBackgroundFetchResult) -> Void)!){
        
        progressHUD = ProgressHUD(text: "Submitting...")
        self.view.addSubview(progressHUD)
        self.view.bringSubviewToFront(progressHUD)
        
        let data = [
            "user_name" : userName,
            "activity_type" : type,
            "start_time" : startTime,
            "end_time" : endTime
        ]
        
        
        Alamofire.request(.POST, "https://nott.herokuapp.com/" + "activity", parameters:data , encoding: .JSON)
            .responseJSON { response in
                switch response.result {
                case .Success(_):
                    print("submit success")
                    completionHandler(UIBackgroundFetchResult.NewData)
                case .Failure(let error):
                    print("Request failed with error : \(error)")
                }
        }
        
    }
    
    func displayAlertMessage(alertTitle:String, alertDescription:String) -> Void {
        // hide activityIndicator view and display alert message
        //        self.activityIndicatorView.hidden = true
        let alert = UIAlertController(title: alertTitle, message: alertDescription, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func addDeviceUseButtonPressed(sender:UIButton!){
        
        blackTransparentOverView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        blackTransparentOverView.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.5)
        self.view.addSubview(blackTransparentOverView)
        
        self.view.bringSubviewToFront(self.deviceLogViewPopUP)
        
        UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn, animations: {
            self.deviceLogViewPopUP.frame = CGRectMake(0, self.view.frame.size.height*0.45, self.view.frame.size.width, self.view.frame.size.height*0.55)
            }, completion: { finished in
        })
        
        if sender == iPadAddButton{
            deviceImage = UIImage(named: "iPad_icon")
            deviceImageView.image = deviceImage
            deviceToLog = "iPad"
            
        }
        else if sender == iPhoneAddButton{
            deviceImage = UIImage(named: "iPhone_icon")
            deviceImageView.image = deviceImage
            deviceToLog = "iPhone"
        }
        else if sender == tvAddButton{
            deviceImage = UIImage(named: "tv_icon")
            deviceImageView.image = deviceImage
            deviceToLog = "tv"
        }

    }
    
    func setupDeviceLogPopUPView(){
        deviceLogViewPopUP.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*0.6)
        deviceLogViewPopUP.backgroundColor = Constants.AppColors.popBackgroundColor
        self.view.addSubview(self.deviceLogViewPopUP)
        
        self.view.bringSubviewToFront(self.deviceLogViewPopUP)
        
        let swipedownDevice = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.respondToDeviceSwipeDown(_:)))
        swipedownDevice.direction = UISwipeGestureRecognizerDirection.Down
        intakeLogViewPopUp.addGestureRecognizer(swipedownDevice)
        
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
        cancelButton.addTarget(self, action: #selector(ViewController.cancelDeviceButtonPressed), forControlEvents: .TouchUpInside)
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
        submitButton.addTarget(self, action: #selector(ViewController.submitDeviceLogButtonPressed), forControlEvents: .TouchUpInside)
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
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    // MARK: - Navigation Actions
    func statsButtonPressed(){
        let statsVC = StatsViewController()
        self.navigationController?.pushViewController(statsVC, animated: true)
        
    }
    
    func settingsButtonPressed(){
        defaults.setValue(nil, forKey: "loggedIn")
        defaults.setValue(nil, forKey: "username")
        self.navigationController?.popToRootViewControllerAnimated(true)
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
    
    func addIntakeButtonPressed(sender:UIButton){

        if sender.tag == 0{
            print("no default")
        }
        if sender.tag == 1 {
            print("no 1")
            mealPhotoImage = popularIntakeImage
            mealPhotoImageView.image = popularIntakeImage
            foodTypePickerTextfield.text = popularType
            intakeTitleTextfield.text = popularTitle
        }
        if sender.tag == 2 {
            print("no 2")
            mealPhotoImage = secondPopularIntakeImage
            mealPhotoImageView.image = secondPopularIntakeImage
            foodTypePickerTextfield.text = secondType
            intakeTitleTextfield.text = secondTitle
        
        }
        if sender.tag == 3 {
            print("no 3")
            mealPhotoImage = thirdPopularIntakeImage
            mealPhotoImageView.image = thirdPopularIntakeImage
            foodTypePickerTextfield.text = thirdType
            intakeTitleTextfield.text = thirdTitle
            
        }
        
        blackTransparentOverView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        blackTransparentOverView.backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.5)
        self.view.addSubview(blackTransparentOverView)
        
        self.view.bringSubviewToFront(self.intakeLogViewPopUp)
        
        UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn, animations: {
            self.intakeLogViewPopUp.frame = CGRectMake(0, self.view.frame.size.height*0.45, self.view.frame.size.width, self.view.frame.size.height*0.55)
            }, completion: { finished in
        })
    }
    
    func addDoneButtonOnKeyboard(textField:UITextField){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.BlackTranslucent
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: #selector(ViewController.doneButtonAction))
        
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
    
    func foodPickerDoneAction(){
        if selectedFoodType == nil{
            foodTypePickerTextfield.text = ""
        }else{
            foodTypePickerTextfield.text = selectedFoodType
        }
        
        
        foodTypePickerTextfield.resignFirstResponder()
        
    }

    func doneButtonAction(){
        deviceEndTimeTextField.resignFirstResponder()
        deviceStartTimeTextField.resignFirstResponder()
        intakeTitleTextfield.resignFirstResponder()
        intakeTimeTextfield.resignFirstResponder()
    }

    func setDatePickerOnDeviceStartTimeTextField(textfield:UITextField){
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        textfield.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(ViewController.handleDeviceStartTimeDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
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
        datePickerView.addTarget(self, action: #selector(ViewController.handleDeviceEndTimeDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    func handleDeviceEndTimeDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        deviceEndTimeTextField.text = dateFormatter.stringFromDate(sender.date)
    }
    
    func setDatePickerOnIntakeTimeTextField(textfield:UITextField){
        let datePickerView  : UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.DateAndTime
        textfield.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(ViewController.handleIntakeTimeDatePicker(_:)), forControlEvents: UIControlEvents.ValueChanged)

    }
    
    func handleIntakeTimeDatePicker(sender: UIDatePicker) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        intakeTimeTextfield.text = dateFormatter.stringFromDate(sender.date)
    }
    


    func cancelDeviceButtonPressed(){
        blackTransparentOverView.removeFromSuperview()
        UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseIn, animations: {
            self.deviceLogViewPopUP.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height*0.4)
            }, completion: { finished in
        })
        
        deviceStartTimeTextField.text = ""
        deviceEndTimeTextField.text = ""
        deviceToLog = ""
    }
    
    func cancelIntakeButtonPressed(){
        blackTransparentOverView.removeFromSuperview()
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

