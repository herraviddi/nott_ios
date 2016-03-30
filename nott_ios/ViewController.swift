//
//  ViewController.swift
//  nott_ios
//
//  Created by Vidar Fridriksson on 30/03/16.
//  Copyright © 2016 hideout. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MOCK DATA!
    
    var percentagePrediction = 0.741 as CGFloat!
    
    // END OF MOCK DATA!
    
    var circleDiagram = CircleDiagram()
    
    var screenHeight:CGFloat!
    
    var predictionView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // get the devices screenheight
        screenHeight = UIScreen.mainScreen().bounds.height
        
        navbarSetup()
        mainUISetup()
        predictionViewSetup()
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

