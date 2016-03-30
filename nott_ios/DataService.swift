//
//  DataService.swift
//  nott_ios
//
//  Created by Vidar Fridriksson on 30/03/16.
//  Copyright © 2016 hideout. All rights reserved.
//

import Foundation

class DataService{
    var UserObject = [String:AnyObject]()
    
    
    static let ds = DataService()
    
    
    private init(){
        self.UserObject = [String:AnyObject]()
    }
}
