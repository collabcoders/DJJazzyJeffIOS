//
//  SignupModel.swift
//  DJ Jazzy Jaff
//
//  Created by Jigar Khatri on 22/11/22.
//

import Foundation
import ObjectMapper


//SIGNUP SCREEN ..........................

extension SingUpViewController :WebServiceHelperDelegate{
    
    struct SingUpParameater: Codable {
        var firstName: String
        var lastName: String
        var email: String
        var phone: String
        var password: String
        var confirmPassword: String
    }
    
   
    
    func signUpAPI(SingUpParameater:SingUpParameater){
        ImpactGenerator()
        indicatorShow()
        guard let parameater = try? SingUpParameater.asDictionary() else {
            showAlertMessage(strMessage: str.invalidRequestParamater)
            return
        }
        
        //Declaration URL
        let strURL = "\(Url.signup.absoluteString!)"
        
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "signup"
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
        indicatorHide()
        if data.getStringForID(key: "error") == "0"{
            if let message = data["msg"] as? String{
                
                
                let alert = UIAlertController(title: str.appName, message: message, preferredStyle: .alert)
                if #available(iOS 13.0, *) {
                    alert.overrideUserInterfaceStyle = .dark
                } else {
                    // Fallback on earlier versions
                }
                
                alert.addAction(UIAlertAction(title: str.ok, style: .default) { action in
                    delay(0) {
                        self.navigationController?.popViewController(animated: true)
                    }
                })
                navigationController?.present(alert, animated: true)
            }
            else{
                delay(0) {
                    self.navigationController?.popViewController(animated: true)
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

