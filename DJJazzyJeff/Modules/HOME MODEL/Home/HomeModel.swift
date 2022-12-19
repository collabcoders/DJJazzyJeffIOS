//
//  HomeModel.swift
//  DJJazzyJeff
//
//  Created by Jigar Khatri on 26/11/22.
//

import Foundation
import ObjectMapper



struct HomeBannerModel: Mappable{
    internal var adId: Int?
    internal var title: String?
    internal var alignment: String?
    internal var description: String?
    internal var url: String?
    internal var image: String?
    internal var button: String?
    internal var seconds: Int?
    internal var order: Int?
    internal var isVideoLoad: Bool = false
    internal var thumbnailImage: UIImage?

    init?(map:Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map:Map){
        adId <- map["adId"]
        title <- map["title"]
        alignment <- map["alignment"]
        description <- map["description"]
        url <- map["url"]
        image <- map["image"]
        button <- map["button"]
        seconds <- map["seconds"]
        order <- map["order"]
    }
}



struct AllVideoModel: Mappable{
    internal var videoId: Int?
    internal var title: String?
    internal var category: String?
    internal var source: String?
    internal var sourceId: String?
    internal var duration: String?
    internal var image: String?
    internal var screenshot: String?
    internal var hls: String?
    internal var featured: Int?

    init?(map:Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map:Map){
        videoId <- map["videoId"]
        title <- map["title"]
        category <- map["category"]
        source <- map["source"]
        sourceId <- map["sourceId"]
        duration <- map["duration"]
        image <- map["image"]
        screenshot <- map["screenshot"]
        hls <- map["hls"]
        featured <- map["featured"]
    }
}

struct AllMusicModel: Mappable{
    internal var musicId: Int?
    internal var favId: Int = 0
    internal var title: String?
    internal var artist: String?
    internal var genre: String?
    internal var category: String?
    internal var duration: String?
    internal var image: String?
    internal var file: String?
    internal var description: String?
    internal var featured: Int?
    internal var date: String?

    init?(map:Map) {
        mapping(map: map)
    }
    
    mutating func mapping(map:Map){
        musicId <- map["musicId"]
        favId <- map["favId"]
        title <- map["title"]
        artist <- map["artist"]
        genre <- map["genre"]
        category <- map["category"]
        duration <- map["duration"]
        image <- map["image"]
        file <- map["file"]
        description <- map["description"]
        featured <- map["featured"]
        date <- map["date"]
    }
}


//HOME SCREEN ..........................

extension HomeViewController :WebServiceHelperDelegate{
   
    
    func getBannerAPI(){
        //SET LOADER
        if self.isLoading == false{
            self.objIndicator.isHidden = false
            self.objIndicator.startAnimating()
            self.viewLoader.isHidden = false
            self.tblView.isHidden = true
        }

        
        //Declaration URL
        let strURL = "\(Url.homeBanner.absoluteString!)"
        
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "homeBanner"
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

    func getAllVideoAPI(){
        //SET LOADER
        if self.isLoading == false{
            self.objIndicator.isHidden = false
            self.objIndicator.startAnimating()
            self.viewLoader.isHidden = false
            self.tblView.isHidden = true
        }

        
        //Declaration URL
        let strURL = "\(Url.AllVideo.absoluteString!)"
        
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "AllVideo"
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
    
    func getAllMusicAPI(){
        //SET LOADER
        if self.isLoading == false{
            self.objIndicator.isHidden = false
            self.objIndicator.startAnimating()
            self.viewLoader.isHidden = false
            self.tblView.isHidden = true
        }

        
        //Declaration URL
        let strURL = "\(Url.AllMusic.absoluteString!)"
        
        
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
    
    
    func appDataDidSuccess(_ data: NSDictionary, request strRequest: String, index: Int) {
        self.objRefresh?.endRefreshing()
        self.isLoading = true
        
        if data.getStringForID(key: "error") == "0"{
            
            if strRequest == "homeBanner" {
               if let arrBanner = data["data"] as? NSArray{
                    if arrBanner.count != 0{
                        self.arrHomeBanner = []
                        self.arrHomeBanner = Mapper<HomeBannerModel>().mapArray(JSONArray: arrBanner as! [[String : Any]])
                        self.arrHomeBanner = self.arrHomeBanner.sorted(by: { $0.order ?? 0 < $1.order ?? 0 })

                        //RELOAD TABLE
                        self.objBannerCollection.reloadData()
                        
                        if self.timerBanner == nil{
                            self.timerBanner = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.scrollBanner), userInfo: nil, repeats: true)
                        }
                        
                        //GET ALL VIDEO
                        self.getAllVideoAPI()
                    }
                   else{
                       //GET ALL VIDEO
                       self.getAllVideoAPI()
                   }
                }
                else{
                    self.getAllVideoAPI()
                }
            }
            else if strRequest == "AllVideo"{
                if let arrBanner = data["data"] as? NSArray{
                     if arrBanner.count != 0{
                         self.arrAllVideo = []
                         let arrData = Mapper<AllVideoModel>().mapArray(JSONArray: arrBanner as! [[String : Any]])
                         
                         for obj in arrData{
                             if obj.featured ?? 0 > 0{
                                 self.arrAllVideo.append(obj)
                             }
                         }
                         
                         self.arrAllVideo = self.arrAllVideo.sorted(by: { $0.featured ?? 0 < $1.featured ?? 0})

                         //RELOAD TABLE
                         self.objVideoCollection.reloadData()
                        
                         //GET ALL MUSIC
                         self.getAllMusicAPI()
                     }
                    else{
                        //GET ALL MUSIC
                        self.getAllMusicAPI()
                    }
                 }
                else{
                    //GET ALL MUSIC
                    self.getAllMusicAPI()
                }
                
              
            }
            else if strRequest == "AllMusic"{
                if let arrBanner = data["data"] as? NSArray{
                     if arrBanner.count != 0{
                         self.arrAllMusic = []
                         let arrData = Mapper<AllMusicModel>().mapArray(JSONArray: arrBanner as! [[String : Any]])
                         
                         for obj in arrData{
                             if obj.featured ?? 0 > 0{
                                 self.arrAllMusic.append(obj)
                             }
                         }
                         
                         self.arrAllMusic = self.arrAllMusic.sorted(by: { $0.featured ?? 0 < $1.featured ?? 0})

                         //RELOAD TABLE
                         self.objMusicCollection.reloadData()
                         
                     }
                 }
                
                delay(1.5) {
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    delay(0.2) {
                        self.setTheView()
                        self.viewLoader.isHidden = true
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
        self.objRefresh?.endRefreshing()
    }
    
    func appDataDidFail(_ error: Error, request strRequest: String) {
        self.objRefresh?.endRefreshing()
        indicatorHide()
        showAlertMessage(strMessage: "\(strRequest)-\(str.somethingWentWrong)")
    }
}
