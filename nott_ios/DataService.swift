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
    
    
    
    func getSleepData(username:String,datestr:String) -> NSMutableArray{
        let sleep_data = NSMutableArray()
        let getURL = BASE_URL + "get_sleep_data_for_day?user_name=" + username + "&date_str=" + datestr
        
        Alamofire.request(.GET,getURL , parameters: nil)
            .responseJSON { response in
                if let JSON = response.result.value {
                    sleep_data.addObject(JSON)
                }
        }
        
        return sleep_data
    }
    
    
    func editActivity(username:String,activity_id:Int,activity_type:String,start_time:String,end_time:String){
        let data = [
            "user_name" : username,
            "activity_id" : activity_id,
            "activity_type" : activity_type,
            "start_time" : start_time,
            "end_time" : end_time
        ]
        
        
        
        Alamofire.request(.POST, BASE_URL + "edit_activity", parameters:data as? [String : AnyObject] , encoding: .JSON)
            .responseJSON { response in
                if response.result.isSuccess {
                    if response.response?.statusCode == 400{
                        print("error 400")
                    }else{
                        print("edit activity success")
                    }
                }else{
                    print("error in post activity dataservice")
                }
        }
    }
    
    func edit_food(username:String,food_id:Int,food_type:String,title:String,score:Int,grams:Int,picture:String,timestamp:String){
        
    
     
        let data = [
            "user_name" :username,
            "food_id" : food_id,
            "food_type" :food_type,
            "title" :title,
            "score" : score,
            "grams" : grams,
            "picture" : picture,
            "timestamp" : timestamp
        ]
        
        print(data)
        Alamofire.request(.POST, BASE_URL + "edit_food", parameters:data as? [String : AnyObject] , encoding: .JSON)
            .responseJSON { response in
                //                print(response.result.description)
                if response.result.isSuccess {
                                        print(response.result.value)
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
    
    func delete_food(username:String,food_id:Int){
        let data = [
            "user_name" : username,
            "food_id" : food_id
        ]
        
        print(data)
        
        Alamofire.request(.POST, BASE_URL + "delete_food", parameters:data as? [String : AnyObject] , encoding: .JSON)
            .responseJSON { response in
                //                print(response.result.description)
                if response.result.isSuccess {
                    print(response.result.value)
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
    
    func delete_activity(username:String,activity_id:Int){
        let data = [
            "user_name" : username,
            "activity_id" : activity_id
        ]
        
        print(data)
        
        Alamofire.request(.POST, BASE_URL + "delete_activity", parameters:data as? [String : AnyObject] , encoding: .JSON)
            .responseJSON { response in
                //                print(response.result.description)
                if response.result.isSuccess {
                    print(response.result.value)
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

    

}
