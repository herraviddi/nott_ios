//
//  ViewController.swift
//  nott_ios
//
//  Created by Vidar Fridriksson on 30/03/16.
//  Copyright © 2016 hideout. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    // MOCK DATA!
    
    var percentagePrediction = 0.254 as CGFloat!
    
    var intakeItems = [
        ["id":1,"order":2,"title":"pizza","image":"tempPizza.png"],
        ["id":2,"order":1,"title":"pasta","image":"tempPasta.png"],
        ["id":3,"order":3,"title":"hamburger","image":"tempHamburger.png"]
    ]
    
    // END OF MOCK DATA!
    
    var circleDiagram = CircleDiagram()
    
    var screenHeight:CGFloat!
    
    var predictionView:UIView!
    
    var vertical_split_intake:UIImageView!
    var vertical_split_device:UIImageView!
    
    // CollectionView Properties
    var intakeLoggingCollectionView:UICollectionView!
    var deviceLoggingCollectionView:UICollectionView!
    
    let intakeLogginIdentifier = "CollectionViewACell"
    let deviceLogginIdentifier = "CollectionViewBCell"

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // get the devices screenheight
        screenHeight = UIScreen.mainScreen().bounds.height
        
        navbarSetup()
        mainUISetup()
        predictionViewSetup()
        setupIntakeLogginView()
        setupDeviceLoggingView()
        
    }

    // MARK: - UI Setup
    
    func mainUISetup(){
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    func navbarSetup(){
        self.title = "Nótt"
        
        // removing the horizontal shadow line on the navbar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        // Stats Button in navigation bar
        let statsBtn = UIButton()
        statsBtn.setImage(UIImage(named: "navbar_statsIcon"), forState: .Normal)
        statsBtn.frame = CGRectMake(0, 0, 30, 30)
        statsBtn.addTarget(self, action: Selector("statsButtonPressed"), forControlEvents: .TouchUpInside)
        
        // Settings Button in navigation bar
        let settingsBtn = UIButton()
        settingsBtn.setImage(UIImage(named: "navbar_settingsIcong"), forState: .Normal)
        settingsBtn.frame = CGRectMake(0, 0, 30, 30)
        settingsBtn.addTarget(self, action: Selector("settingsButtonPressed"), forControlEvents: .TouchUpInside)
        
        // set the buttons to the navbar
        let rightBarButton = UIBarButtonItem()
        rightBarButton.customView = statsBtn
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = settingsBtn
        self.navigationItem.leftBarButtonItem = leftBarButton
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
        
        var popularIntakeImage:UIImage!
        var secondPopularIntakeImage:UIImage!
        var thirdPopularIntakeImage:UIImage!
        
        for item in intakeItems{
//            print(item)
            if item["order"] == 1{
                popularIntakeImage = UIImage(named: (item["image"]!) as! String) as UIImage?
            }
            if item["order"] == 2{
                secondPopularIntakeImage = UIImage(named: (item["image"]!) as! String) as UIImage?
            }
            if item["order"] == 3{
                thirdPopularIntakeImage = UIImage(named: (item["image"]!) as! String) as UIImage?
            }
        }
        
        // second popular Button
        let resizedImage_secondPopularIntake = resizeImage(secondPopularIntakeImage!, newWidth: self.view.frame.size.width*0.4)
        
        let secondPopularIntakeImageAddButton = UIButton(type: UIButtonType.Custom) as UIButton
        secondPopularIntakeImageAddButton.setImage(resizedImage_secondPopularIntake, forState: .Normal)
        secondPopularIntakeImageAddButton.addTarget(self, action: "addIntakeButtonPressed", forControlEvents: .TouchUpInside)
        secondPopularIntakeImageAddButton.layer.cornerRadius = self.view.frame.size.width*0.2/2
        secondPopularIntakeImageAddButton.clipsToBounds = true
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
        let resizedImage_popularIntakeImage = resizeImage(popularIntakeImage!, newWidth: self.view.frame.size.width*0.4)
        
        let popularIntakeImageAddButton = UIButton(type: UIButtonType.Custom) as UIButton
        popularIntakeImageAddButton.setImage(resizedImage_popularIntakeImage, forState: .Normal)
        popularIntakeImageAddButton.addTarget(self, action: "addIntakeButtonPressed", forControlEvents: .TouchUpInside)
        popularIntakeImageAddButton.layer.cornerRadius = self.view.frame.size.width*0.2/2
        popularIntakeImageAddButton.clipsToBounds = true
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
        let resized_thirdPopularIntakeImage = resizeImage(thirdPopularIntakeImage!, newWidth: self.view.frame.size.width*0.4)
        
        let thirdPopularIntakeAddButton = UIButton(type: UIButtonType.Custom) as UIButton
        thirdPopularIntakeAddButton.setImage(resized_thirdPopularIntakeImage, forState: .Normal)
        thirdPopularIntakeAddButton.addTarget(self, action: "addIntakeButtonPressed", forControlEvents: .TouchUpInside)
        thirdPopularIntakeAddButton.layer.cornerRadius = self.view.frame.size.width*0.2/2
        thirdPopularIntakeAddButton.clipsToBounds = true
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
        intakeAddButton.addTarget(self, action: "addIntakeButtonPressed", forControlEvents: .TouchUpInside)
        intakeAddButton.translatesAutoresizingMaskIntoConstraints = false
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
        
        // iPhone Button
        let iPhoneImage = UIImage(named: "iPhone_icon") as UIImage?
        
        let resizedImage_iPhone = resizeImage(iPhoneImage!, newWidth: self.view.frame.size.width*0.2)
        
        let iPhoneAddButton = UIButton(type: UIButtonType.Custom) as UIButton
        iPhoneAddButton.setImage(resizedImage_iPhone, forState: .Normal)
        iPhoneAddButton.addTarget(self, action: "addIntakeButtonPressed", forControlEvents: .TouchUpInside)
        iPhoneAddButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(iPhoneAddButton)
        
        let iPhoneAddButton_widthConstraint = NSLayoutConstraint(item: iPhoneAddButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: (resizedImage_iPhone.size.width))
        self.view.addConstraint(iPhoneAddButton_widthConstraint)
        
        let iPhoneAddButton_heightConstraint = NSLayoutConstraint(item: iPhoneAddButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: (resizedImage_iPhone.size.height))
        self.view.addConstraint(iPhoneAddButton_heightConstraint)
        
        let iPhoneAddButton_verticalConstraint = NSLayoutConstraint(item: iPhoneAddButton, attribute: .Top, relatedBy: .Equal, toItem: vertical_split_device, attribute: .Bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(iPhoneAddButton_verticalConstraint)
        
        let iPhoneAddButton_horizontalConstraint = NSLayoutConstraint(item: iPhoneAddButton, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: -self.view.frame.size.width * 0.015)
        self.view.addConstraint(iPhoneAddButton_horizontalConstraint)
        
        // iPad Button
        let iPadImage = UIImage(named: "iPad_icon") as UIImage?
        
        let resizedImage_iPad = resizeImage(iPadImage!, newWidth: self.view.frame.size.width*0.2)
        
        let iPadAddButton = UIButton(type: UIButtonType.Custom) as UIButton
        iPadAddButton.setImage(resizedImage_iPad, forState: .Normal)
        iPadAddButton.addTarget(self, action: "addIntakeButtonPressed", forControlEvents: .TouchUpInside)
        iPadAddButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(iPadAddButton)
        
        let iPadAddButton_widthConstraint = NSLayoutConstraint(item: iPadAddButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: (resizedImage_iPad.size.width))
        self.view.addConstraint(iPadAddButton_widthConstraint)
        
        let iPadAddButton_heightConstraint = NSLayoutConstraint(item: iPadAddButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: (resizedImage_iPad.size.height))
        self.view.addConstraint(iPadAddButton_heightConstraint)
        
        let iPadAddButton_verticalConstraint = NSLayoutConstraint(item: iPadAddButton, attribute: .Top, relatedBy: .Equal, toItem: vertical_split_device, attribute: .Bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(iPadAddButton_verticalConstraint)
        
        let iPadAddButton_horizontalConstraint = NSLayoutConstraint(item: iPadAddButton, attribute: .Right, relatedBy: .Equal, toItem: iPhoneAddButton, attribute: .CenterX, multiplier: 1, constant: -self.view.frame.size.width * 0.12)
        self.view.addConstraint(iPadAddButton_horizontalConstraint)
        
        
        // Television Button
        let televisionImage = UIImage(named: "tv_icon") as UIImage?
        
        let resizedImage_tv = resizeImage(televisionImage!, newWidth: self.view.frame.size.width*0.2)
        
        let tvAddButton = UIButton(type: UIButtonType.Custom) as UIButton
        tvAddButton.setImage(resizedImage_tv, forState: .Normal)
        tvAddButton.addTarget(self, action: "addIntakeButtonPressed", forControlEvents: .TouchUpInside)
        tvAddButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tvAddButton)
        
        let tvAddButton_widthConstraint = NSLayoutConstraint(item: tvAddButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: (resizedImage_tv.size.width))
        self.view.addConstraint(tvAddButton_widthConstraint)
        
        let tvAddButton_heightConstraint = NSLayoutConstraint(item: tvAddButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: (resizedImage_tv.size.height))
        self.view.addConstraint(tvAddButton_heightConstraint)
        
        let tvAddButton_verticalConstraint = NSLayoutConstraint(item: tvAddButton, attribute: .Top, relatedBy: .Equal, toItem: vertical_split_device, attribute: .Bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(tvAddButton_verticalConstraint)
        
        let tvAddButton_horizontalConstraint = NSLayoutConstraint(item: tvAddButton, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: self.view.frame.size.width * 0.015)
        self.view.addConstraint(tvAddButton_horizontalConstraint)
        
        
        // deviceAddButton
        let image = UIImage(named: "plusButtonImage") as UIImage?
        
        let resizedImage = resizeImage(image!, newWidth: self.view.frame.size.width*0.2)
        
        let deviceAddButton = UIButton(type: UIButtonType.Custom) as UIButton
        deviceAddButton.setImage(resizedImage, forState: .Normal)
        deviceAddButton.addTarget(self, action: "addIntakeButtonPressed", forControlEvents: .TouchUpInside)
        deviceAddButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(deviceAddButton)
        
        let deviceAddButton_widthConstraint = NSLayoutConstraint(item: deviceAddButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: (resizedImage.size.width))
        self.view.addConstraint(deviceAddButton_widthConstraint)
        
        let deviceAddButton_heightConstraint = NSLayoutConstraint(item: deviceAddButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: (resizedImage.size.height))
        self.view.addConstraint(deviceAddButton_heightConstraint)
        
        let deviceAddButton_verticalConstraint = NSLayoutConstraint(item: deviceAddButton, attribute: .Top, relatedBy: .Equal, toItem: vertical_split_device, attribute: .Bottom, multiplier: 1, constant: 0)
        self.view.addConstraint(deviceAddButton_verticalConstraint)
        
        let deviceAddButton_horizontalConstraint = NSLayoutConstraint(item: deviceAddButton, attribute: .Left, relatedBy: .Equal, toItem: tvAddButton, attribute: .CenterX, multiplier: 1, constant: self.view.frame.size.width*0.12)
        self.view.addConstraint(deviceAddButton_horizontalConstraint)
        

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
        print("stats button pressed")
        
    }
    
    func settingsButtonPressed(){
        print("settings button pressed")
        
    }
    

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

