//
//  MusicModel.swift
//  DJJazzyJeff
//
//  Created by Jigar Khatri on 19/12/22.
//

import Foundation
import ObjectMapper



//MUSIC SCREEN ..........................

extension MusicTabView : WebServiceHelperDelegate{
   
    struct FavoritesParameater: Codable {
        var favId: Int
        var itemId: Int
        var section: String //"video" or "music"

    }

    func updateFavoriteMusic(FavoritesParameater:FavoritesParameater){

        guard let parameater = try? FavoritesParameater.asDictionary() else {
            showAlertMessage(strMessage: str.invalidRequestParamater)
            return
        }

        //Declaration URL
        let strURL = "\(Url.updateFavorites.absoluteString!)"


        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "updateFavorites"
        webHelper.methodType = "post"
        webHelper.strURL = strURL
        webHelper.dictType = parameater
        webHelper.dictHeader = NSDictionary()
        webHelper.delegateWeb = self
        webHelper.showLogForCallingAPI = true
        webHelper.serviceWithAlert = true
        webHelper.indicatorShowOrHide = true
        webHelper.callAPI()
    }



    func appDataDidSuccess(_ data: NSDictionary, request strRequest: String, index: Int) {

        if data.getStringForID(key: "error") == "0"{

            if strRequest == "updateFavorites" {
                
                if data.getStringForID(key: "error") == "0"{
                    //CALL NOTIFICAIOTN
                    NotificationCenter.default.post(name: .removeFavorit, object: nil, userInfo: nil)

                    //SET IMAGE
                    self.imgLike.image = UIImage(named: self.isisFavorite ? "icon_UnLike" : "icon_Like")
                    
                    //SET MESSAGE
                    if let message = data["msg"] as? String{
                        showAlertErrorMessage(strMessage: message)
                    }
                    else{
                        showAlertMessage(strMessage: self.isisFavorite ? str.strRemoveFavorite : str.strSaveFavorite)
                    }
                }
                else{
                    if let message = data["msg"] as? String{
                        showAlertErrorMessage(strMessage: message)
                    }
                    else{
                        showAlertErrorMessage(strMessage: "\(strRequest) \(str.somethingWentWrong)")
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
    }

    func appDataDidFail(_ error: Error, request strRequest: String) {
        indicatorHide()
        showAlertMessage(strMessage: "\(strRequest)-\(str.somethingWentWrong)")
    }
}
