//
//  LiveStreemingModel.swift
//  DJJazzyJeff
//
//  Created by Jigar Khatri on 11/12/22.
//

import Foundation


//HOME SCREEN ..........................

extension LiveStreamingViewController :WebServiceHelperDelegate{
   
    
    func getLiveStreemingData(){
        
        //Declaration URL
        let strURL = "\(Url.LiveStreeming.absoluteString!)"
        
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "LiveStreeming"
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
        
        if data.getStringForID(key: "error") == "0"{
            
            if strRequest == "LiveStreeming" {
                print(data)
                
                if let objData = data["data"] as? NSDictionary{
                    //SET VIDEO
                    if let strLiveURL = objData.getStringForID(key: "streamUrl"){
                        
                        guard let url = URL(string: strLiveURL) else {return}
                        let request = URLRequest(url: url)
                        self.objVideoWebView.load(request)
                        
                        //SET HEIGHT
                        self.con_VideoHeight.constant = manageWidth(size: 220)

                    }
                    
                    //SET CHAT
                    if let strChatURL = objData.getStringForID(key: "chatUrl"){
                        
                        guard let url = URL(string: strChatURL) else {return}
                        let request = URLRequest(url: url)
                        self.objChatWebView.load(request)

                    }
                }
            }
        }
        else{
            indicatorHide()
            self.navigationController?.popViewController(animated: true)
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
