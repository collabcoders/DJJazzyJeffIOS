//
//  WebServiceHelper.swift
//  HealthyBlackMen
//
//  Created by Jigar Khatri on 30/04/21.
//

import UIKit
import Alamofire
import AVFoundation

var webservice_Nool_Load : Bool = false

// MARK: - Protocol -
@objc protocol WebServiceHelperDelegate{
    func appDataDidSuccess(_ data: NSDictionary, request strRequest: String, index : Int)
    func appDataArraySuccess(_ arr: NSArray, request strRequest: String, index : Int)
    func appDataDidFail(_ error: Error, request strRequest: String)
}

class WebServiceHelper: NSObject,InternetAccessDelegate {

    var strMethodName = ""
    var selectIndex : Int = 0
    weak var delegate: WebServiceHelper?
    var strURL : String = ""
    var jsonString = ""
    var methodType : String = ""
    var dictType : [String : Any] = [:]
    var dictHeader : NSDictionary = [:]
    var indicatorShowOrHide : Bool = true
    var serviceWithAlert : Bool = false
    var serviceWithAlertDefault : Bool = false
    var serviceWithAlertErrorMessage : Bool = false
    var imageUpload : UIImage!
    var imageUploadName : String = ""
    var showLogForCallingAPI : Bool = true
    var strAuthorize : String = ""
    var strUploadType : String = ""

    var arr_MutlipleimagesAndVideo : NSMutableArray = []
    var arr_MutlipleimagesAndVideoType : NSMutableArray = []
    var arr_MutlipleimagesAndVideoName : NSMutableArray = []
    var arr_Mutlipleimages : [[String : Any]] = []
    var delegateWeb:WebServiceHelperDelegate?
    
    
    //MARK:- NO INTERNET CONNECTION DELEGATE METHOD
    func ReceiveInternetNotify(strMethodName: String) {
        if strMethodName == "startDownload"{
            callAPI()
        }else if strMethodName == "startDownloadWithImage"{
//            startDownloadWithImage()
        }else if strMethodName == "startUploadingMultipleImagesAndVideo"{
            startUploadingMultipleImagesAndVideo()
        }
    }
    
    struct Item: Decodable {
        let id: String
        let sortingId: String
        let name: String
    }

    struct ErrorData : Decodable {
        let status : String
        let msg: String
    }
    
    // MARK: - StartDowload Method -
    func callAPI(){
        
        if NetworkReachabilityManager()!.isReachable {
            do {
                
                webservice_Nool_Load = true
                DispatchQueue.main.async {
                    if self.indicatorShowOrHide == true{
                        indicatorShow()
                    }
                }

                //CONVERT DIC TO DATA
                var jsonData = try JSONSerialization.data(withJSONObject: self.dictType, options: .prettyPrinted)
                if jsonString != ""{
                    jsonData = jsonString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
                }
                
                //SET REWUEST
                let strUrl = URL(string: "\(self.strURL)")!
                var request = URLRequest(url: strUrl)

                //Declaration for service for get,post or other..
                if methodType == "post"{
                    request.httpMethod = HTTPMethod.post.rawValue
                }
                else  if methodType == "delete"{
                    request.httpMethod = HTTPMethod.delete.rawValue
                }
                else if methodType == "put"{
                    request.httpMethod = HTTPMethod.put.rawValue
                }
                else{
                    request.httpMethod = HTTPMethod.get.rawValue
                }

                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                if let accessToken = UserDefaults.standard.accessToken{
                    request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
                }
                
                //Pass paramater with value data
                if methodType == "post" || methodType == "put"{
                    if dictType.count != 0{
                        request.httpBody = jsonData
                    }
                }
                
                //Calling service
                let manager = AF
                manager.sessionConfiguration.timeoutIntervalForRequest = 10
                manager.request(request).responseJSON {
                    (response) in
                    
                    switch response.result {
                    case .success:
               
                        if let dict = response.value as? NSDictionary{
                            let error : String = dict.getStringForID(key: "error")
                            if error == "INVALID_TOKEN"{
                                indicatorHide()
                                webservice_Nool_Load = false
                            }
                            else{
                                //Check condition for response success or not and notificatino show with coming alert in service response
                                if self.validationForServiceResponse(dict){
                                    webservice_Nool_Load = false
                                    self.delegateWeb?.appDataDidSuccess(dict, request: self.strMethodName, index: self.selectIndex)
                                }else{
                                    webservice_Nool_Load = false
                                    let err = NSError(domain: "data not found", code: 401, userInfo: nil)
                                    self.delegateWeb?.appDataDidFail(err, request: self.strMethodName)
                                }
                            }
                        }
                        else if let arr = response.value as? NSArray{
                            self.delegateWeb?.appDataArraySuccess(arr, request: self.strMethodName, index: self.selectIndex)
                        }
                        else{
                            webservice_Nool_Load = false
                            let err = NSError(domain: "data not found", code: 401, userInfo: nil)
                            self.delegateWeb?.appDataDidFail(err, request: self.strMethodName)

                        }
                        

//                        if self.strMethodName == Application.latest_episode || self.strMethodName == Application.most_watched || self.strMethodName == Application.most_in_country {
////                        if self.strMethodName == Application.latest_episode{
//                            webservice_Nool_Load = false
//
//                            let arr = response.value as! NSArray
//                        }
//                        else{
//                            let dict = response.value as! NSDictionary
//
//
//                        }
                        
                    case .failure(_):
                        webservice_Nool_Load = false
                        let err = NSError(domain: "data not found", code: 401, userInfo: nil)
                        self.delegateWeb?.appDataDidFail(err, request: self.strMethodName)
                    }
                 }
                
            }
            catch {
                
                //Alert show for Header
                webservice_Nool_Load = false
                showAlertMessage(strMessage: "\(self.strMethodName) \(str.somethingWentWrong)")
            }

        }else{
            webservice_Nool_Load = false

            
            let ViewController = getTopViewController!
            var NoInternetNaNavigation: UINavigationController!
            if let view = ViewController.children.last {
                if !(view.isKind(of: NoInternetViewController.self)){
                    let storyBoard: UIStoryboard = UIStoryboard(name: GlobalConstants.LOGIN_MODEL, bundle: nil)
                    if let newViewController = storyBoard.instantiateViewController(withIdentifier: "NoInternetViewController") as? NoInternetViewController{
                        NoInternetNaNavigation = UINavigationController(rootViewController: newViewController)
                        NoInternetNaNavigation.modalPresentationStyle = .fullScreen
                        ViewController.present(NoInternetNaNavigation, animated: true, completion: nil)
                    }
                }
            }
            else{
                if !(ViewController.isKind(of: NoInternetViewController.self)){
                    let storyBoard: UIStoryboard = UIStoryboard(name: GlobalConstants.LOGIN_MODEL, bundle: nil)
                    if let newViewController = storyBoard.instantiateViewController(withIdentifier: "NoInternetViewController") as? NoInternetViewController{
                        NoInternetNaNavigation = UINavigationController(rootViewController: newViewController)
                        NoInternetNaNavigation.modalPresentationStyle = .fullScreen
                        ViewController.present(NoInternetNaNavigation, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
//    func startDownloadWithImage(){
//        if NetworkReachabilityManager()!.isReachable {
//            do {
//
//                webservice_Nool_Load = true
//                //Indication show hide with varible when user calling service
//                (self.indicatorShowOrHide == true) ? (indicatorShow()) : (indicatorHide())
//
//                //Base user for calling service
//                let headers: HTTPHeaders = [:]
//
//
//                //Calling service
//                AF.upload(multipartFormData: { multipartFormData in
//
//                    multipartFormData.append(self.imageUpload!.jpegData(compressionQuality: 0.5)!, withName: self.imageUploadName , fileName: "\(self.imageUploadName).jpg", mimeType: "jpg")
//
//                    for (key, value) in self.dictType  {
//                        multipartFormData.append((value as! String).data(using: .utf8)!, withName: key )
//                    }
//
//                    print(multipartFormData)
//                },
//                to: self.strURL,
//                usingThreshold: UInt64.init(), method: .post,
//                headers: headers).responseJSON { response in
//                    print(response)
//                    switch response.result {
//
//                    case .success:
//                        let dict = response.value as! NSDictionary
//
//
//                        //Check condition for response success or not and notificatino show with coming alert in service response
//                        if self.validationForServiceResponse(dict){
//                            webservice_Nool_Load = false
//                            self.delegateWeb?.appDataDidSuccess(dict, request: self.strMethodName, index: self.selectIndex)
//                        }else{
//                            webservice_Nool_Load = false
//                            let err = NSError(domain: "data not found", code: 401, userInfo: nil)
//                            self.delegateWeb?.appDataDidFail(err, request: self.strMethodName)
//                        }
//
//                    case .failure(_):
//                        webservice_Nool_Load = false
//                        let err = NSError(domain: "data not found", code: 401, userInfo: nil)
//                        self.delegateWeb?.appDataDidFail(err, request: self.strMethodName)
//                    }
//                 }
//            }
//        }else{
//            webservice_Nool_Load = false
//            let ViewController = getTopViewController!
//            var NoInternetNaNavigation: UINavigationController!
//            if let view = ViewController.children.last {
//                if !(view.isKind(of: NoInternetViewController.self)){
//                    let storyBoard: UIStoryboard = UIStoryboard(name: GlobalConstants.LOGIN_MODEL, bundle: nil)
//                    if let newViewController = storyBoard.instantiateViewController(withIdentifier: "NoInternetViewController") as? NoInternetViewController{
//                        NoInternetNaNavigation = UINavigationController(rootViewController: newViewController)
//                        NoInternetNaNavigation.modalPresentationStyle = .fullScreen
//                        ViewController.present(NoInternetNaNavigation, animated: true, completion: nil)
//                    }
//                }
//            }
//            else{
//                if !(ViewController.isKind(of: NoInternetViewController.self)){
//                    let storyBoard: UIStoryboard = UIStoryboard(name: GlobalConstants.LOGIN_MODEL, bundle: nil)
//                    if let newViewController = storyBoard.instantiateViewController(withIdentifier: "NoInternetViewController") as? NoInternetViewController{
//                        NoInternetNaNavigation = UINavigationController(rootViewController: newViewController)
//                        NoInternetNaNavigation.modalPresentationStyle = .fullScreen
//                        ViewController.present(NoInternetNaNavigation, animated: true, completion: nil)
//                    }
//                }
//            }
//        }
//    }
    
    func startUploadingMultipleImagesAndVideo(){
//        if NetworkReachabilityManager()!.isReachable {
//            do {
//                webservice_Nool_Load = true
//
//                //Indication show hide with varible when user calling service
//                (self.indicatorShowOrHide == true) ? (indicatorShow()) : (indicatorHide())
//
//                //Declaratin for Serialization
//                //            print(self.dictType)
//                print(self.arr_MutlipleimagesAndVideo.count)
//                let jsonData = try JSONSerialization.data(withJSONObject: self.dictType, options: .prettyPrinted)
//
//                //Base user for calling service
//                let strUrl = URL(string: self.strURL)!
//                var request = URLRequest(url: strUrl)
//
//                //Declaration for service for get,post or other..
//                request.httpMethod = HTTPMethod.post.rawValue
//
//                //Pass paramater with value data
//                request.httpBody = jsonData
//
//                //Calling service
//                Alamofire.upload(multipartFormData:{ multipartFormData in
//
//                    if self.strUploadType == "OtherItem_Photo"{
//                        for i in (0..<self.arr_Mutlipleimages.count){
//                            let obj = self.arr_Mutlipleimages[i]
//                            let imgData : Data = obj["img"] as! Data
//                            let imgName : String = obj["name"] as! String
//
//                            if self.strUploadType == "OtherItem_Photo"{
//                                multipartFormData.append(imgData, withName: "\(self.imageUploadName)",fileName: imgName, mimeType: "image/jpeg")
//
//                            }
//                        }
//                    }
//                    else{
//
//                        for i in (0..<self.arr_MutlipleimagesAndVideo.count){
//
//                            let imageData = self.arr_MutlipleimagesAndVideo[i]
//                            let imgData : Data = imageData as! Data
//
//                            if (imgData.count != 0){
//
//                                if self.strUploadType == "photo"{
//                                    multipartFormData.append(imgData, withName: "\(self.imageUploadName)",fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
//                                }else{
//                                    multipartFormData.append(imgData, withName: "\(self.imageUploadName)",fileName: "\(Date().timeIntervalSince1970).mov", mimeType: "application/octet-stream")
//                                }
//                            }
//                        }
//                    }
//
//
//                    for (key, value) in self.dictType  {
//                        multipartFormData.append((value as! String).data(using: .utf8)!, withName: key as! String)
//                    }
//                },
//                                 usingThreshold:UInt64.init(),
//                                 to:strUrl,
//                                 method:.post,
//                                 headers:dictHeader as? HTTPHeaders,
//                                 encodingCompletion: { encodingResult in
//                                    switch encodingResult {
//                                    case .success(let upload, _, _):
//                                        upload.responseJSON(completionHandler: { response in
//                                            //Redirect caling view if success
//                                            if !(response.result.error != nil){
//                                                //Check condition for response success or not and notificatino show with coming alert in service response
//
//                                                webservice_Nool_Load = false
//
//                                                if self.validationForServiceResponse(response.result.value ?? ""){
//                                                    self.delegateWeb?.appDataDidSuccess(response.result.value ?? "", request: self.strMethodName)
//                                                }
//                                            }else{
//                                                webservice_Nool_Load = false
//
//                                                indicatorHide()
//                                            }
//                                        })
//                                    case .failure(let encodingError):
//                                        indicatorHide()
//                                        print("en eroor :", encodingError)
//                                        webservice_Nool_Load = false
//                                    }
//                })
//            } catch {
//
//                //Alert show for Header
//                messageBar.MessageShow(title: GlobalConstants.appName as NSString, alertType: MessageView.Layout.cardView, alertTheme: .error, TopBottom: true)
//
//                self.validationForServiceResponse(error.localizedDescription)
//
//                webservice_Nool_Load = false
//            }
//
//        }else{
//            webservice_Nool_Load = false
//            let storyboard = UIStoryboard(name:"Other",bundle: Bundle.main)
//            let view = storyboard.instantiateViewController(withIdentifier: "NoInternetViewController") as! NoInternetViewController
//            view.delegate = self
//            view.strCallingMethodName = "startUploadingMultipleImagesAndVideo"
//            let ViewController = getTopViewController
//            ViewController? .present(view, animated: true, completion: nil)
//
//            let err = NSError(domain: "data not found", code: 401, userInfo: nil)
//            self.delegateWeb?.appDataDidFail(err, request: self.strMethodName)
//        }
    }
    
    
    // MARK: - Other Method -
    func validationForServiceResponse(_ response: NSDictionary) -> Bool{

        DispatchQueue.main.async {
            //Indication show hide with varible when user calling service
            if self.indicatorShowOrHide == true{
                indicatorHide()
            }
        }

        if response["code"] != nil{
            let responseKey = Int(response.getStringForID(key: "code")) ?? 0
            
            //101 invalide user or already registartion with current credincial
            switch responseKey {
            case 100,101,102:
                if self.serviceWithAlert || self.serviceWithAlertErrorMessage {
                    indicatorHide()

                    //Alert show for Header
                    showAlertMessage(strMessage: "\(response["msg"] ?? "")")
                }

                return false
            case 401:
                indicatorHide()

                //USER LOG OUT
                LogOutUser()
                
                //Alert show for Header
                showAlertMessage(strMessage: "\(response["msg"] ?? "")")
                return false
            case 105:
//                //USER LOG OUT
//                LogOtuUser()
//
                return false
            default:
                if self.serviceWithAlert {
                    
//                  messageBar.MessageShow(title: response["msg"]! as! String as NSString, alertType: MessageView.Layout.cardView, alertTheme: .success, TopBottom: true)
                }else if self.serviceWithAlertDefault {
                    indicatorHide()

                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        let alert = UIAlertController(title: str.error, message: response["msg"]! as? String, preferredStyle: UIAlertController.Style.alert)
                        alert.view.tintColor = UIColor.secondary
                        alert.addAction(UIAlertAction(title: str.ok, style: UIAlertAction.Style.default, handler: nil))
                        GlobalConstants.appDelegate?.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    })
                }
                break
            }
        }
        return true
    }
}


func LogOutUser()  {
   
    //REMOVE ALL DATA
    UserDefaults.standard.user = nil
    
    //NVIGATE WELCOME SCREEN
    let storyBoard: UIStoryboard = UIStoryboard(name: GlobalConstants.LOGIN_MODEL, bundle: nil)
    if let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController{
        /* Initiating instance of ui-navigation-controller with view-controller */
        let navigationController = UINavigationController()
        navigationController.viewControllers = [newViewController]
        GlobalConstants.appDelegate?.window?.rootViewController = navigationController
        GlobalConstants.appDelegate?.window?.makeKeyAndVisible()
    }
}

