//
//  FavoritesModel.swift
//  DJJazzyJeff
//
//  Created by Jigar Khatri on 19/12/22.
//

import Foundation
import ObjectMapper


struct FacoritesModel: Mappable{
    internal var artist: String?
    internal var date: String?
    internal var duration: String?
    internal var favId: Int?
    internal var file: String?
    internal var image: String?
    internal var itemId: Int?
    internal var title: String?
    internal var type: String?

 
    init?(map:Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map:Map){
        artist <- map["artist"]
        date <- map["date"]
        duration <- map["duration"]
        favId <- map["favId"]
        file <- map["file"]
        image <- map["image"]
        itemId <- map["itemId"]
        title <- map["title"]
        type <- map["type"]
    }
}

//FACORITES SCREEN ..........................

extension FavoritesViewController :WebServiceHelperDelegate{
   
   
    func getFavoritesMusicAPI(){
        indicatorShow()
        
        if isLoading == true{
            self.tblView.isHidden = true
        }

        //Declaration URL
        let strURL = "\(Url.FavoritesList.absoluteString!)"
        
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "FavoritesList"
        webHelper.methodType = "get"
        webHelper.strURL = strURL
        webHelper.dictType = [:]
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.showLogForCallingAPI = true
        webHelper.serviceWithAlert = true
        webHelper.indicatorShowOrHide = isLoading
        webHelper.callAPI()
    }
    
    
    func appDataDidSuccess(_ data: NSDictionary, request strRequest: String, index: Int) {
        self.objRefresh?.endRefreshing()
        if data.getStringForID(key: "error") == "0"{
            
            if strRequest == "FavoritesList"{
                if let arrBanner = data["data"] as? NSArray{
                    if arrBanner.count != 0{
                        
                        self.arrFavoriteMusic = []
                        self.arrFavoriteMusic = Mapper<FacoritesModel>().mapArray(JSONArray: arrBanner as! [[String : Any]])
                      
                        //RELOAD TABLE
                        self.tblView.reloadData()
                        
                    }
                }
                
                if isLoading{
                    indicatorHide()
                    self.isLoading = false
                    self.tblView.isHidden = false
                }
                else{
                    delay(1.5) {
                        indicatorHide()
                        self.isLoading = false
                        self.tblView.isHidden = false
                    }
                }
               
            }

        }
        else{
            indicatorHide()
            if let message = data["msg"] as? String{
                showAlertErrorMessage(strMessage: message)
            }
            else{
                showAlertErrorMessage(strMessage: "\(strRequest) \(str.somethingWentWrong)")
            }
        }
    }

    func appDataArraySuccess(_ arr: NSArray, request strRequest: String, index: Int) {
        indicatorHide()
        self.objRefresh?.endRefreshing()
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        self.objRefresh?.endRefreshing()
        indicatorHide()
        showAlertMessage(strMessage: "\(strRequest)-\(str.somethingWentWrong)")
    }
}
