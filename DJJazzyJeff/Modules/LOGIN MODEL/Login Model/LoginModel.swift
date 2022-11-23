//
//  LoginModel.swift
//  BAYNOUNAH
//
//  Created by Jigar Khatri on 22/06/22.
//

import Foundation
import ObjectMapper


class User : NSObject,NSCoding {
    var memberId: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var plan: String?
    var token: String?

    
    override init() {
        super.init()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(memberId, forKey: "memberId")
        coder.encode(firstName, forKey: "firstName")
        coder.encode(lastName, forKey: "lastName")
        coder.encode(email, forKey: "email")
        coder.encode(plan, forKey: "plan")
        coder.encode(token, forKey: "token")
    }
    
    required init?(coder: NSCoder) {
        self.memberId = coder.decodeObject(forKey: "memberId") as? String
        self.firstName = coder.decodeObject(forKey: "firstName") as? String
        self.lastName = coder.decodeObject(forKey: "lastName") as? String
        self.email = coder.decodeObject(forKey: "email") as? String
        self.plan = coder.decodeObject(forKey: "plan") as? String
        self.token = coder.decodeObject(forKey: "token") as? String
    }
}




//LOGIN SCREEN ..........................

extension LoginViewController :WebServiceHelperDelegate{
    
    struct LoginParameater: Codable {
        var username: String
        var password: String
    }
    
    struct ForgetPasswordParameater: Codable {
        var email: String
    }
    
   
    
    func loginAPI(LoginParameater:LoginParameater){
        ImpactGenerator()
        indicatorShow()
        guard let parameater = try? LoginParameater.asDictionary() else {
            showAlertMessage(strMessage: str.invalidRequestParamater)
            return
        }
        
        //Declaration URL
        let strURL = "\(Url.login.absoluteString!)"
        
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "login"
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
    
    func forgetPasswordAPI(ForgetPasswordParameater:ForgetPasswordParameater){
        ImpactGenerator()
        indicatorShow()
        guard let parameater = try? ForgetPasswordParameater.asDictionary() else {
            showAlertMessage(strMessage: str.invalidRequestParamater)
            return
        }
        
        //Declaration URL
        let strURL = "\(Url.forgetPassword.absoluteString!)"
        
        
        //Create object for webservicehelper and start to call method
        let webHelper = WebServiceHelper()
        webHelper.strMethodName = "forgetPassword"
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

            if strRequest == "login" {
                let userData = data["data"] as! NSDictionary
              
                //SAVE USER DATA
                let userObj = User()
                userObj.memberId = userData.getStringForID(key: "memberId")
                userObj.firstName = userData.getStringForID(key: "firstName")
                userObj.lastName = userData.getStringForID(key: "lastName")
                userObj.email = userData.getStringForID(key: "email")
                userObj.plan = userData.getStringForID(key: "plan")
                userObj.token = userData.getStringForID(key: "token")

                //SAVE OBJECT
                UserDefaults.standard.user = userObj

              
                //MOVE TO HOME SCREEN
                let storyBoard: UIStoryboard = UIStoryboard(name: GlobalConstants.HOME_MODEL, bundle: nil)
                if let newViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController{
                    /* Initiating instance of ui-navigation-controller with view-controller */
                    let navigationController = UINavigationController()
                    navigationController.viewControllers = [newViewController]
                    GlobalConstants.appDelegate?.window?.rootViewController = navigationController
                    GlobalConstants.appDelegate?.window?.makeKeyAndVisible()
                }

                
               
            }
            else if strRequest == "forgetPassword"{
                print(data)
                if let message = data["msg"] as? String{
                    showAlertMessage(strMessage: message)
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
