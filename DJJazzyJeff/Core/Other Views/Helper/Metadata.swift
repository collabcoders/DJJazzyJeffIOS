//
//  Metadata.swift
//  BAYNOUNAH
//
//  Created by Jigar Khatri on 22/06/22.
//

import Foundation
import UIKit

enum Application {
    
//    static let appName: String = str.appName

    static let PageLimit = checkDeviceiPad() ? 15 : 10
    static let top10Limit = 10

    static let key = "ec86e6e258c39066f60a61a42d756a57"
    static let userID = "186"

    
    static let channelID = "248"
    static let Series_genre_id = "206"
    static let Movies_genre_id = "193"
    static let mvideos_genre_id = "194"
    static let Weekend_genre_id = "207"
    static let Kids_genre_id = "192"


    //TYPE
    static let categories = "categories"
    static let custom_carousel = "custom_carousel"
    static let custom_categories = "custom_categories"
    static let latest_episode = "latest_episode"
    static let latest_videos_in_show = "latest_videos_in_show"
    static let live_channels = "live_channels"
    static let most_watched = "most_watched"
    static let resume_watching = "resume_watching"
    static let recommendation_module = "recommendation_module"
    static let custom_videos = "custom_videos"
    static let favorite_carousel = "favorite_carousel"
    static let most_in_country = "most_in_country"

    

    //APP STORE URL
    static let appURL = "itms-apps://itunes.apple.com/app/"
    static let appStoreId = "1047544600"

    //OTHER KEY
    static let googleApiKey = ""
    static let VERSION = "\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "")"



    //Base URL
    static let BaseURLDev = "https://www.mixapps.io/api/App/"
    static let BaseURLLive = ""
    static let BaseURL = BaseURLDev
    static let appAPPName = "?app=djjazzyjeff"
    static let appAPPID = "?appId=djjazzyjeff"


    

    
    //IMAGE / VIDEO URL
    static let imgURL = "https://www.mixapps.io/content/djjazzyjeff/"
//    static let vidoeURL = ""
    
    //URL
    static let termsCondition = ""

    //DATE FORMET
    static let strDateFormet = "MMM dd, yyyy"
    static let pickerDateFormet = "yyyy-MM-dd"
    static let pickerDateFormet2 = "yyyy-MM-dd'T'HH:mm:ss"
    static let yearOf = 10
    static let HHMMSS = "HH:mm:ss"
    static let serverDateFormet = "yyyy-MM-dd HH:mm:ss"
    static let MMM_dd = "MMM dd"
    
    
 
}


enum API_ERROR {
    static let objError : [String : String] = ["USER_NOT_FOUND": "User not found",
                                               "AUTH_NOT_VALID" : "These credentials do not match our records.",
                                               "USER_EXISTS" : "User already exist"]
}



//IN-APP TYPE
enum RegisteredPurchase: String {
    case consumablePurchase
    case renewingPurchase
}




class NetworkActivityIndicatorManager: NSObject {

    private static var loadingCount = 0

    class func networkOperationStarted() {

        #if os(iOS)
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        loadingCount += 1
        #endif
    }

    class func networkOperationFinished() {
        #if os(iOS)
        if loadingCount > 0 {
            loadingCount -= 1
        }
        if loadingCount == 0 {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
        #endif
    }
}



struct AppUtility {

    static func PortraitMode(){
        //SET PORTRAIT MODE
        AppUtility.lockOrientation(.portrait)
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    /// OPTIONAL Added method to adjust lock and rotate to the desired orientation
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
   
        self.lockOrientation(orientation)
    
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}
