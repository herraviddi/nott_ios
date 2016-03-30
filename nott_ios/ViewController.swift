//
//  ViewController.swift
//  nott_ios
//
//  Created by Vidar Fridriksson on 30/03/16.
//  Copyright © 2016 hideout. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var screenHeight:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // get the devices screenheight
        screenHeight = UIScreen.mainScreen().bounds.height
        
        navbarSetup()
        mainUISetup()
    }

    // UI Setup
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
    
    func mainUISetup(){
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    // Navigation Actions
    func statsButtonPressed(){
        
    }
    
    func settingsButtonPressed(){
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

