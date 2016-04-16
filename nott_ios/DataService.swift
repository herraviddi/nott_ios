//
//  DataService.swift
//  nott_ios
//
//  Created by Vidar Fridriksson on 30/03/16.
//  Copyright © 2016 hideout. All rights reserved.
//

import Foundation
import Alamofire

class DataService{
    var UserObject = [String:AnyObject]()
    var top3Foods = [String:AnyObject]()
    var foodListArray = NSMutableArray()
    
    static let ds = DataService()
    
    private var _BASE_URL = "https://nott.herokuapp.com/"
    
    var BASE_URL: String{
        return _BASE_URL
    }
    
    private init(){
        self.UserObject = [String:AnyObject]()
        self.top3Foods = [String:AnyObject]()
        self.foodListArray = NSMutableArray()
    }
    
    // TODO login/signup
    
    
    func postIntake(userName:String,foodType:String,foodTitle:String,score:Int,grams:Int,picture:String,timeStamp:String) -> Bool{
        
        var returnBool = false
        
        let data = [
            "user_name" :userName,
            "food_type" :foodType,
            "title" :foodTitle,
            "score" : score,
            "grams" : grams,
            "picture" : picture,
            "timestamp" : timeStamp
        ]
        
        Alamofire.request(.POST, BASE_URL + "food", parameters:data as? [String : AnyObject] , encoding: .JSON)
            .responseJSON { response in
//                print(response.result.description)
                if response.result.isSuccess {
//                    print(response.result.value)
                    if response.response?.statusCode == 400{
                        print("error 400")
                    }else{
                        print("send activity success")
                        returnBool = true
                    }
                }else{
                    print("error in post activity dataservice")
                }
        }

        return returnBool
    }
    
    func postActivity(userName:String,startTime:String,endTime:String,type:String){
        
        let data = [
            "user_name" : userName,
            "activity_type" : type,
            "start_time" : startTime,
            "end_time" : endTime
        ]
        
        
        Alamofire.request(.POST, BASE_URL + "activity", parameters:data , encoding: .JSON)
            .responseJSON { response in
                if response.result.isSuccess {
                    if response.response?.statusCode == 400{
                        print("error 400")
                    }else{
                        print("send activity success")
                    }
                }else{
                    print("error in post activity dataservice")
                }
        }
    
    }


    
    func getFrequentFood(username:String) -> NSMutableArray{
        let getURL = BASE_URL + "get_frequent_food?user_name=" + username
        
        self.foodListArray = []
        Alamofire.request(.GET,getURL , parameters: nil)
            .responseJSON { response in
//                print(response.result.value)
                if let JSON = response.result.value {
                    self.foodListArray.addObject(JSON)
                }
        }
        
        return foodListArray
        
    }
    
    func getUserSleepQualityHistory(username:String) -> NSMutableArray{
        let sleepQArray = NSMutableArray()
        
        let getURL = BASE_URL + "get_sleep_quality_chart?user_name=" + username
//        https://nott.herokuapp.com/get_sleep_quality_chart?user_name=
        
        Alamofire.request(.GET,getURL , parameters: nil)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    sleepQArray.addObject(JSON)
                }
        }
        
        return sleepQArray
    }
    
    func getUserTimeLine(username:String, datestr:String) -> NSMutableArray{
        let dayTimeLine = NSMutableArray()
        //https://nott.herokuapp.com/get_timeline_for_day?user_name=rakel&date_str=2016-04-11
//        let datestr = "2016-04-15" 
        let getURL = BASE_URL + "get_timeline_for_day?user_name=" + username + "&date_str=" + datestr
        
        Alamofire.request(.GET,getURL , parameters: nil)
            .responseJSON { response in
//                print(response.result.value)
                if let JSON = response.result.value {
                    dayTimeLine.addObject(JSON)
                }
        }
        
        return dayTimeLine
    }
    
    
    
    

}
