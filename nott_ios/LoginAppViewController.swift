//
//  LoginAppViewController.swift
//  nott
//
//  Created by Vidar Fridriksson on 07/04/16.
//  Copyright © 2016 hideout. All rights reserved.
//

import UIKit
import AeroGearPush

class LoginAppViewController: UIViewController,UITextFieldDelegate {

    
    var nameTextField:UITextField!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    override func viewWillAppear(animated: Bool) {
        
        if defaults.objectForKey("loggedIn") != nil {
            let appVC = ViewController()
            self.navigationController?.pushViewController(appVC, animated: false)
        }
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        self.navigationController?.navigationBarHidden = true
        view.backgroundColor = Constants.AppColors.appRedColor
        
        let screenWidth = self.view.frame.size.width
        let screenHeight = self.view.frame.size.height
        
        let appImage = UIImage(imageLiteral: "nott_appIcon")
        let appImageView = UIImageView()
        appImageView.frame = CGRectMake(screenWidth/2 - appImage.size.width/2, screenHeight*0.15, appImage.size.width, appImage.size.height)
        appImageView.image = appImage
        self.view.addSubview(appImageView)
        
        
        let appNameLabel = UILabel()
        appNameLabel.frame = CGRectMake(screenWidth/2 - (screenWidth*0.8/2), screenHeight*0.2, screenWidth*0.8, screenHeight*0.15)
        appNameLabel.text = "nótt"
        appNameLabel.textAlignment = .Center
        appNameLabel.font = UIFont.systemFontOfSize(46, weight: UIFontWeightUltraLight)
        appNameLabel.textColor = Constants.AppColors.appWhiteColor
        self.view.addSubview(appNameLabel)

        nameTextField = UITextField()
        nameTextField.frame = CGRectMake(screenWidth/2 - (screenWidth*0.6/2), screenHeight*0.4, screenWidth*0.6, screenHeight*0.05)
        nameTextField.attributedPlaceholder = NSAttributedString(string: "test subject name",attributes:
            [NSForegroundColorAttributeName:Constants.AppColors.graycolor])
        nameTextField.font = UIFont.systemFontOfSize(16)
        nameTextField.backgroundColor = Constants.AppColors.appWhiteColor
        nameTextField.borderStyle = .RoundedRect
        nameTextField.autocapitalizationType = .None
        nameTextField.autocorrectionType = .No
        
        nameTextField.layer.borderWidth = 1.0
        nameTextField.layer.borderColor = Constants.AppColors.graycolor.CGColor
        nameTextField.layer.cornerRadius = 5.0
        nameTextField.textAlignment = .Center
        nameTextField.textColor = UIColor.blackColor()
        
        self.view.addSubview(nameTextField)
        
        let enterAppButton = UIButton(type: UIButtonType.RoundedRect) as UIButton
        enterAppButton.frame = CGRectMake(screenWidth/2 - (screenWidth*0.6/2), screenHeight*0.5, screenWidth*0.6, screenHeight*0.1)
        enterAppButton.setTitle("enter app", forState: .Normal)
        enterAppButton.titleLabel?.font = UIFont.systemFontOfSize(24, weight: UIFontWeightLight)
        enterAppButton.layer.borderWidth = 1.0
        enterAppButton.layer.borderColor = Constants.AppColors.appWhiteColor.CGColor
        enterAppButton.layer.cornerRadius = 5.0
        enterAppButton.setTitleColor(Constants.AppColors.appWhiteColor, forState: .Normal)
        enterAppButton.backgroundColor = UIColor.clearColor()
        enterAppButton.addTarget(self, action: #selector(LoginAppViewController.enterAppButtonPressed), forControlEvents: .TouchUpInside)

        self.view.addSubview(enterAppButton)
        // Do any additional setup after loading the view.
        

        
    }
    
    func enterAppButtonPressed(){
        
//        let deviceToken = self.defaults.valueForKey("userDeviceToken") as! NSData
//        
//        self.registerDeviceToken(deviceToken)
        
        defaults.setValue(nameTextField.text, forKey: "username")
        defaults.setValue(1, forKey: "loggedIn")
        let appVC = ViewController()
        self.navigationController?.pushViewController(appVC, animated: false)
        
    }
    
    
//    func registerDeviceToken(deviceToken:NSData){
//        let registration = AGDeviceRegistration(serverURL: NSURL(string: "https://aerogear2-hideoutapps.rhcloud.com/ag-push/")!)
//
//        
//        registration.registerWithClientInfo({ (clientInfo: AGClientDeviceInformation!)  in
//            
//            // apply the token, to identify this device
//            clientInfo.deviceToken = deviceToken
////            clientInfo.alias = userID //User id
//            
//            clientInfo.variantID = "2be5381f-d5b1-4486-9630-61c2d2e5665d"
//            clientInfo.variantSecret = "64b701b1-eb67-4c83-b290-0f3219741fe6"
//            
//            // --optional config--
//            // set some 'useful' hardware information params
//            let currentDevice = UIDevice()
//            clientInfo.operatingSystem = currentDevice.systemName
//            clientInfo.osVersion = currentDevice.systemVersion
//            clientInfo.deviceType = currentDevice.model
//            
//            }, success: {
//                print("UPS registration worked");
//                
//            }, failure: { (error:NSError!) -> () in
//                print("UPS registration Error: \(error.localizedDescription)")
//        })
//    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?)  {
        //Hide the keyboard
        nameTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
