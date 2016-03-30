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
    }

    // UI Setup
    func navbarSetup(){
        self.title = "Nótt"
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

