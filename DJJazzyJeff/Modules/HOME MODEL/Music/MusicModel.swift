//
//  MusicModel.swift
//  DJJazzyJeff
//
//  Created by Jigar Khatri on 17/12/22.
//

import Foundation
import ObjectMapper




struct CategoriesModel: Mappable{
    internal var value: String?
    internal var name: String?
    internal var subTitle: String?
    internal var image: String?

    init?(map:Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map:Map){
        value <- map["value"]
        name <- map["name"]
        subTitle <- map["subTitle"]
        image <- map["image"]
    }
}
//MUSIC SCREEN ..........................

extension MusicViewController :WebServiceHelperDelegate{
   
    func getAllMusicAPI(value : String){
        indicatorShow()
        self.isLoading = true
        self.tblView.isHidden = true

        //Declaration URL
        let strURL = "\(Url.AllMusic.absoluteString!)&category=\(value)"
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "AllMusic"
        webHelper.methodType = "get"
        webHelper.strURL = strURL
        webHelper.dictType = [:]
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.showLogForCallingAPI = true
        webHelper.serviceWithAlert = true
        webHelper.indicatorShowOrHide = false
        webHelper.callAPI()
    }
    
    
     func getCategoryAPI(){
 
         //Declaration URL
         let strURL = "\(Url.AllCategory.absoluteString!)"
         
         
         //Create object for webservicehelper and start to call method
         let webHelper = WebServiceHelper()
         webHelper.strMethodName = "AllCategory"
         webHelper.methodType = "get"
         webHelper.strURL = strURL
         webHelper.dictType = [:]
         webHelper.dictHeader = NSDictionary()
         webHelper.delegateWeb = self
         webHelper.showLogForCallingAPI = true
         webHelper.serviceWithAlert = true
         webHelper.indicatorShowOrHide = false
         webHelper.callAPI()
     }
     
    
    func appDataDidSuccess(_ data: NSDictionary, request strRequest: String, index: Int) {
        self.objRefresh?.endRefreshing()
        self.isLoading = false
        if data.getStringForID(key: "error") == "0"{
            


            if strRequest == "AllMusic"{
                if let arrBanner = data["data"] as? NSArray{
                    if arrBanner.count != 0{
                        
                        self.arrAllMusic = []
                        let arrData = Mapper<AllMusicModel>().mapArray(JSONArray: arrBanner as! [[String : Any]])
                        
                        for obj in arrData{
                            if obj.featured ?? 0 >= 0{
                                self.arrAllMusic.append(obj)
                            }
                        }
                        
                        self.arrAllMusic = self.arrAllMusic.sorted(by: { $0.featured ?? 0 > $1.featured ?? 0})
                        
                        //RELOAD TABLE
                        self.tblView.reloadData()
                        
                    }
                }
                
                delay(1.5) {
                    indicatorHide()
                    self.tblView.isHidden = false
                }
            }
            else if strRequest == "AllCategory"{
                if let arrBanner = data["data"] as? NSArray{
                    if arrBanner.count != 0{
                        
                        self.arrCategories = []
                        self.arrCategories = Mapper<CategoriesModel>().mapArray(JSONArray: arrBanner as! [[String : Any]])

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
