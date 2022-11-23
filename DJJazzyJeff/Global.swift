//
//  Global.swift
//  Aeshee
//
//  Created by Apple on 25/10/18.
//  Created by Jigar Khatri on 30/04/21.
//

import Foundation
import UIKit
import AVFoundation
import IQKeyboardManagerSwift
import Nuke
import ObjectMapper
import KRProgressHUD

struct GlobalConstants
{
    // Constant define here.
    static let developerTest : Bool = false
    static let appLive : Bool = true
    
    //Implementation View height
    
    
    static let screenHeightDeveloper : Double =  checkDeviceiPad() ? 1024 : 926
    static let screenWidthDeveloper : Double = checkDeviceiPad() ? 768 : 428


    static let PageLimit: Int = 10
    static let spacing: Int = checkDeviceiPad() ? 16 : 8
    static let corner: Int = checkDeviceiPad() ? 10 : 5
    

    
    //Name And Appdelegate Object
    static let appDelegate = (UIApplication.shared.delegate as? AppDelegate)
    
    
    //System width height
    static let windowWidth: Double = UIApplication.shared.statusBarOrientation.isLandscape ? Double(UIScreen.main.bounds.size.height) : Double(UIScreen.main.bounds.size.width)
    static let windowHeight: Double = UIApplication.shared.statusBarOrientation.isLandscape ? Double(UIScreen.main.bounds.size.width) : Double(UIScreen.main.bounds.size.height)

//    static let windowHeight: Double = Double(UIScreen.main.bounds.size.height)
    
    
    //STOREBORD NAME
    static let LOGIN_MODEL = "Login"
    static let TABBAR = "TabBar"
    
    static let HOME_MODEL = "Home"
    static let HOME_IPAD_MODEL = "Home_iPad"
    static let PLAYER_MODEL = "Player"
    static let ACCOUNT_MODEL = "Account"

    
    
    
    //FONT NAME
    static let APP_FONT_Bold = "HelveticaNeue-Bold"
    static let APP_FONT_Medium = "HelveticaNeue-Medium"
    static let APP_FONT_Regular = "HelveticaNeue-Regular"

    
    
    //IPHONE NAME
    static let iPhone4_4s = "iPhones4 or 4S"
    static let iPhone5_5c_5s_SE = "iPhones 5/5s/5c/SE"
    static let iPhone6_6s_7_8 = "iPhones 6/6s/7/8"
    static let iPhone6P_6s_6sP_7P_8P = "iPhones 6+/6S+/7+/8+"
    static let iPhoneXR = "iPhone_XR"
    static let iPhoneX_XS = "iPhones X/XS"
    static let iPhoneXSMax = "iPhone XSMax"
    static let iPhoneUnknown = "unknown"
    
    
    
    //Device Token
    static let DeviceToken = UserDefaults.standard.object(forKey: "DeviceToken")
    
}
let isRTL = UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft


//GET VIEW TOP
var getTopViewController: UIViewController? {
    
    guard let rootViewController = GlobalConstants.appDelegate?.window?.rootViewController else {
        return nil
    }
    
    return getVisibleViewController(rootViewController)
}


func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {
    
    if let presentedViewController = rootViewController.presentedViewController {
        return getVisibleViewController(presentedViewController)
    }
    
    if let navigationController = rootViewController as? UINavigationController {
        return navigationController.visibleViewController
    }
    
    if let tabBarController = rootViewController as? UITabBarController {
        return tabBarController.selectedViewController
    }
    
    return rootViewController
}
//............................... MANAGE ...............................................//

//MARK: - MANAGE FONT

func CheckFontNameList (){
    //CHECK FONT NAME
    for fontFamilyName in UIFont.familyNames{
        for fontName in UIFont.fontNames(forFamilyName: fontFamilyName){
            print("Family: \(fontFamilyName)     Font: \(fontName)")
        }
    }
}

func checkDeviceiPad() -> Bool{
    return UIDevice.current.userInterfaceIdiom == .pad ? true : false
}
func checkLandscape() -> Bool{
    if UIDevice.current.orientation == UIDeviceOrientation.landscapeLeft {
        return true
    } else if UIDevice.current.orientation == UIDeviceOrientation.landscapeRight {
        return true
    } else if UIDevice.current.orientation == UIDeviceOrientation.portrait {
        return false
    } else if UIDevice.current.orientation == UIDeviceOrientation.portraitUpsideDown {
        return false
    }
    return false
}

func manageFont(font : Double) -> CGFloat{
    let cal : Double = GlobalConstants.windowWidth * font
    return CGFloat(cal / GlobalConstants.screenWidthDeveloper)
}

//MARK: - MANAGE HEIGHT
func manageHeight(size : Double) -> CGFloat{
    let cal : Double = GlobalConstants.windowHeight * size
    return CGFloat(cal / GlobalConstants.screenHeightDeveloper)
}

//MARK: - MANAGE WIDGH
func manageWidth(size : Double) -> CGFloat{
        
    let cal : Double = GlobalConstants.windowWidth * size
    return CGFloat(cal / GlobalConstants.screenWidthDeveloper)
}

//MAKE
// For Swift 5
func delay(_ delay:Double, closure:@escaping ()->()) {
 let when = DispatchTime.now() + delay
 DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
}

 // For Swift 5
func main_thread(closure:@escaping ()->()) {
  //    DispatchQueue.global(qos: .background).async {
 let when = DispatchTime.now()
 DispatchQueue.main.asyncAfter(deadline: when, execute: closure)
  //    }
}

//............................... SET COLOR ...............................................//

// MARK: - SET COLOR
func colorFromRGB(valueRed: CGFloat, valueGreen: CGFloat, valueBlue: CGFloat) -> UIColor {
    return UIColor(red: valueRed / 255.0, green: valueGreen / 255.0, blue: valueBlue / 255.0, alpha: 1.0)
    
}

func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

//SET IMAGE COLOR
func imgColor (imgColor : UIImageView ,  colorHex : UIColor?){
    let templateImage = imgColor.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
    imgColor.image = templateImage
    imgColor.tintColor = colorHex
}


func buttonImageColor (btnImage : UIButton, imageName : String , colorHex: UIColor?){
    let buttonImage = UIImage(named: imageName)
    btnImage.setImage(buttonImage?.withRenderingMode(.alwaysTemplate), for: .normal)
    btnImage.tintColor = colorHex
}


//............................... SET THE FONT ...............................................//

func SetTheFont(fontName :String, size :Double) -> UIFont {
    return UIFont(name: fontName, size: manageFont(font: size))!
}

//............................... ALERT MESSAGE ...............................................//
func showAlertMessage(strMessage: String) {

    let alert = UIAlertController(title: Application.appName, message: strMessage, preferredStyle: UIAlertController.Style.alert)
    if #available(iOS 13.0, *) {
        alert.overrideUserInterfaceStyle = .dark
    } else {
        // Fallback on earlier versions
    }
    alert.addAction(UIAlertAction(title: str.ok, style: UIAlertAction.Style.default, handler: nil))
    getTopViewController?.present(alert, animated: true, completion: nil)
}

func showAlertErrorMessage(strMessage: String) {

    let alert = UIAlertController(title: str.error, message: strMessage, preferredStyle: UIAlertController.Style.alert)
    if #available(iOS 13.0, *) {
        alert.overrideUserInterfaceStyle = .dark
    } else {
        // Fallback on earlier versions
    }
    alert.addAction(UIAlertAction(title: str.ok, style: UIAlertAction.Style.default, handler: nil))
    getTopViewController?.present(alert, animated: true, completion: nil)
}


func showAlertMessage(strMessage: String, button:String) {

    let alert = UIAlertController(title: Application.appName, message: strMessage, preferredStyle: UIAlertController.Style.alert)
    if #available(iOS 13.0, *) {
        alert.overrideUserInterfaceStyle = .dark
    } else {
        // Fallback on earlier versions
    }
    alert.addAction(UIAlertAction(title: button, style: UIAlertAction.Style.default, handler: nil))
    getTopViewController?.present(alert, animated: true, completion: nil)

    //    //POPUP
    //    let window = UIApplication.shared.keyWindow!
    //    window.endEditing(true)
    //    let aleartView = AlertMessage(frame: CGRect(x: 0, y: 0 ,width : window.frame.width, height: window.frame.height))
    //    aleartView.loadPopUpView(strMessage: strMessage)
    //    window.addSubview(aleartView)
        
}


func showAlertMessageWithTitle(strTitle : String, strMessage: String, button:String) {

    let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: UIAlertController.Style.alert)
    if #available(iOS 13.0, *) {
        alert.overrideUserInterfaceStyle = .dark
    } else {
        // Fallback on earlier versions
    }

    alert.addAction(UIAlertAction(title: button, style: UIAlertAction.Style.default, handler: nil))
    getTopViewController?.present(alert, animated: true, completion: nil)

    //    //POPUP
    //    let window = UIApplication.shared.keyWindow!
    //    window.endEditing(true)
    //    let aleartView = AlertMessage(frame: CGRect(x: 0, y: 0 ,width : window.frame.width, height: window.frame.height))
    //    aleartView.loadPopUpView(strMessage: strMessage)
    //    window.addSubview(aleartView)
        
}



//func showAlertSyncingData(strMessage: String) {
//    
//    let alert = UIAlertController(title: Application.appName, message: strMessage, preferredStyle: UIAlertController.Style.alert)
//    
//    alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
//        if let url = URL(string: UIApplication.openSettingsURLString){
//            if #available(iOS 10.0, *){
//                UIApplication.shared.open(url, completionHandler: nil)
//            } else{
//                UIApplication.shared.openURL(url)
//            }
//        }
//    }))
//    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
//    
//    GlobalConstants.appDelegate?.window?.rootViewController?.present(alert, animated: true, completion: nil)
//}
func convertSeccountToTime(remainingTime : Int) -> String{
    let hours = Int(remainingTime) / 3600
    let minutes = (Int(remainingTime) - hours * 3600) / 60
//    let seconds = Int(remainingTime) - hours * 3600 - minutes * 60
    
    var timing : String = ""
    if hours != 0{
        timing = "\(hours)h"
    }
    
    if minutes != 0{
        if timing != ""{
            timing = "\(timing) \(minutes)m"
        }
        else{
            timing = "\(minutes)m"
        }
    }
    
    
//    if seconds != 0{
//        if timing != ""{
//            timing = "\(timing) \(seconds)s"
//        }
//        else{
//            timing = "\(seconds)s"
//        }
//    }
    
    return timing
}


//MARK: - SET KEYBOARD
func setupKeyboard(_ enable: Bool) {
    IQKeyboardManager.shared.enable = enable
    IQKeyboardManager.shared.enableAutoToolbar = enable
    IQKeyboardManager.shared.shouldShowToolbarPlaceholder = !enable
    IQKeyboardManager.shared.previousNextDisplayMode = .alwaysShow
}

func removeNewLineToSpace(str_Value : String) -> String{
    let newString = str_Value.replacingOccurrences(of: "\n", with: " ")
    return newString
}


//MARK: -- Inicator AND LOADING --
func indicatorShow(){
    KRProgressHUD
        .set(style: .custom(background:  UIColor.secondary_dark ?? UIColor.blue, text: UIColor.white, icon: nil))
        .set(activityIndicatorViewColors: [UIColor.white])
        .set(font: SetTheFont(fontName: GlobalConstants.APP_FONT_Bold, size: 20.0))
        .show(withMessage: str.appLoading)
}

func indicatorShowEmpty(){
    KRProgressHUD
        .set(style: .custom(background:  UIColor.clear , text: UIColor.white, icon: nil))
        .set(activityIndicatorViewColors: [UIColor.clear])
        .set(font: SetTheFont(fontName: GlobalConstants.APP_FONT_Bold, size: 14.0))
        .show(withMessage: "")
}
func indicatorHide(){
    KRProgressHUD.dismiss()
}



func startLoading (){
    DispatchQueue.main.async {
        indicatorShowEmpty()
    }
}

func storeLoading(){
    indicatorHide()
}


//............................ NAVIGATION BAR ............................................//


fileprivate let whiteImage = UIImage(setColor: UIColor.secondary!)
func addNavBarImage(strLogo : String,controller: UINavigationController) -> UIImageView{

    let navController = controller
    
    let image = UIImage(named: strLogo) //Your logo url here
    let imageView = UIImageView(image: image)
    
    let bannerWidth = navController.navigationBar.frame.size.width
    let bannerHeight = navController.navigationBar.frame.size.height
    
    let bannerX = bannerWidth / 2 - (image?.size.width)! / 2
    let bannerY = bannerHeight / 2 - (image?.size.height)! / 2
    
    imageView.frame = CGRect(x: bannerX, y: bannerY, width: 100, height: 35)
    imageView.contentMode = .scaleAspectFit
    
    return imageView
}

let navigationNormalHeight: CGFloat = 44
let navigationExtendHeight: CGFloat = 84

extension UINavigationBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var barHeight: CGFloat = navigationNormalHeight
    
        if size.height == navigationExtendHeight {
            barHeight = size.height
        }
    
        let newSize: CGSize = CGSize(width: self.frame.size.width, height: barHeight)
        return newSize
    }
}

func setNavigationHeader(controller: UIViewController,isTransperent:Bool = false){
    guard let navigationController = controller.navigationController else{
        return
    }
    
    //SET PORTRAIT MODE
    AppUtility.PortraitMode()

    
    //SET NAVIGATION
    navigationController.view.semanticContentAttribute = UserDefaults.standard.language == "ar" ? .forceRightToLeft : .forceLeftToRight
    
    if checkDeviceiPad(){
        navigationController.additionalSafeAreaInsets.top = 30
    }
    
    if #available(iOS 15, *) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.clear
        appearance.shadowColor = .clear

        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    navigationController.navigationBar.barTintColor = UIColor.clear
    navigationController.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.secondary!,
         NSAttributedString.Key.font: SetTheFont(fontName: GlobalConstants.APP_FONT_Bold, size: 16.0)]
    navigationController.navigationBar.isTranslucent = isTransperent
    navigationController.navigationBar.shadowImage = UIImage() //(hideShadowImage) ? UIImage() : nil

    if isTransperent {
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    else{
        navigationController.navigationBar.setBackgroundImage(whiteImage, for: .default)
    }

}



func setNavigationBarForLogin(controller: UIViewController,
                              title:String = "",
                              isTransperent:Bool = false,
                              hideShadowImage: Bool = false,
                              leftIcon : String,
                              rightIcon : String,
                              leftActionHandler: ((_ SelectTag : Int) -> Void)? = nil,
                              rightActionHandler: ((_ SelectTag : Int) -> Void)? = nil) {

    guard let navigationController = controller.navigationController else{
        return
    }
    
    //SET PORTRAIT MODE
    AppUtility.PortraitMode()

    
    //SET NAVIGATION
    navigationController.view.semanticContentAttribute = UserDefaults.standard.language == "ar" ? .forceRightToLeft : .forceLeftToRight
    
    if checkDeviceiPad(){
        navigationController.additionalSafeAreaInsets.top = 30
    }
    
    if #available(iOS 15, *) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.clear
        appearance.shadowColor = .clear

        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    navigationController.navigationBar.barTintColor = UIColor.clear
    navigationController.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.secondary!,
         NSAttributedString.Key.font: SetTheFont(fontName: GlobalConstants.APP_FONT_Bold, size: 16.0)]
    navigationController.navigationBar.isTranslucent = isTransperent
    navigationController.navigationBar.shadowImage = UIImage() //(hideShadowImage) ? UIImage() : nil

    if isTransperent {
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    else{
        navigationController.navigationBar.setBackgroundImage(whiteImage, for: .default)
    }
    
    if let actionLeft = leftActionHandler {
        navigationController.navigationItem.setHidesBackButton(true, animated: false)
        
        //LOGO BUTTON
        var viewSubscription = UIView(frame: CGRect.init(x: 0, y: 0, width: manageWidth(size: 120) , height: manageWidth(size: 45)))
        if checkDeviceiPad(){
            viewSubscription = UIView(frame: CGRect.init(x: 0, y: 0, width: manageWidth(size: 107) , height: manageWidth(size: 40)))
        }
        viewSubscription.backgroundColor = .clear


        //SET IMAGE
        let image = UIImage(named: leftIcon) //Your logo url here
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: checkDeviceiPad() ?  -5 : 0, width: viewSubscription.frame.size.width, height: viewSubscription.frame.size.height)
        imageView.contentMode = .scaleAspectFit
        viewSubscription.addSubview(imageView)
       
        let btnLogoAction = UIBarButtonItemWithClouser(view: viewSubscription, actionHandler2: actionLeft)
        controller.navigationItem.leftBarButtonItems = [btnLogoAction]
    }
        
    if let actionRight = rightActionHandler {
        navigationController.navigationItem.setHidesBackButton(true, animated: false)
        
        
        //LIVE BUTTON
        let viewLive = UIView(frame: CGRect.init(x: 0, y: 0, width: manageWidth(size: 82) , height: manageWidth(size: 28)))
        viewLive.backgroundColor = .clear


        //SET IMAGE
        let image = UIImage(named: rightIcon) //Your logo url here
        let imageView = UIImageView(image: image)

        imageView.frame = CGRect(x: 0, y: 0, width: viewLive.frame.size.width, height: viewLive.frame.size.height)
        imageView.contentMode = .scaleAspectFill
        viewLive.addSubview(imageView)
       
        let btnLogoAction = UIBarButtonItemWithClouser(view: viewLive, actionHandler2: actionRight)
        controller.navigationItem.rightBarButtonItems = [btnLogoAction]
    }
}



func setButtonNavigationBarForDetails(controller: UIViewController,
                              title:String = "",
                              isTransperent:Bool = false,
                              hideShadowImage: Bool = false,
                              leftIcon : String,
                              rightIcon : String,
                              leftActionHandler: ((_ SelectTag : Int) -> Void)? = nil,
                              rightActionHandler: ((_ SelectTag : Int) -> Void)? = nil) {

    guard let navigationController = controller.navigationController else{
        return
    }
    
    //SET PORTRAIT MODE
    AppUtility.PortraitMode()

    
    //SET NAVIGATION
    navigationController.view.semanticContentAttribute = UserDefaults.standard.language == "ar" ? .forceRightToLeft : .forceLeftToRight
    
    if checkDeviceiPad(){
        navigationController.additionalSafeAreaInsets.top = 30
    }
    
    if #available(iOS 15, *) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.clear
        appearance.shadowColor = .clear

        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    navigationController.navigationBar.barTintColor = UIColor.clear
    navigationController.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.secondary!,
         NSAttributedString.Key.font: SetTheFont(fontName: GlobalConstants.APP_FONT_Bold, size: 16.0)]
    navigationController.navigationBar.isTranslucent = isTransperent
    navigationController.navigationBar.shadowImage = UIImage() //(hideShadowImage) ? UIImage() : nil

    if isTransperent {
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    else{
        navigationController.navigationBar.setBackgroundImage(whiteImage, for: .default)
    }
    
    if let actionLeft = leftActionHandler {
        navigationController.navigationItem.setHidesBackButton(true, animated: false)
        let button: UIButton = UIButton(type:.custom)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: leftIcon), for: .normal)
        if UserDefaults.standard.language == "ar" {
            button.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        let btnAction = UIBarButtonItemWithClouser(button: button, actionHandler2: actionLeft)
        controller.navigationItem.leftBarButtonItems = [btnAction]
    }
        
    if let actionRight = rightActionHandler {
        navigationController.navigationItem.setHidesBackButton(true, animated: false)
        
        
        //LIVE BUTTON
        let viewLive = UIView(frame: CGRect.init(x: 0, y: 0, width: manageWidth(size: 82) , height: manageWidth(size: 28)))
        viewLive.backgroundColor = .clear


        //SET IMAGE
        let image = UIImage(named: rightIcon) //Your logo url here
        let imageView = UIImageView(image: image)

        imageView.frame = CGRect(x: 0, y: 0, width: viewLive.frame.size.width, height: viewLive.frame.size.height)
        imageView.contentMode = .scaleAspectFill
        viewLive.addSubview(imageView)
       
        let btnLogoAction = UIBarButtonItemWithClouser(view: viewLive, actionHandler2: actionRight)
        controller.navigationItem.rightBarButtonItems = [btnLogoAction]
    }
}



func setButtonNavigationBarFor(controller: UIViewController,
                               title:String = "",
                               isTransperent:Bool = false,
                               hideShadowImage: Bool = false,
                               leftIcon : String,
                               rightIcon : String,
                               leftActionHandler: ((_ SelectTag : Int) -> Void)? = nil,
                               rightActionHandler: ((_ SelectTag : Int) -> Void)? = nil) {

    guard let navigationController = controller.navigationController else{
        return
    }
    
    //SET PORTRAIT MODE
    AppUtility.PortraitMode()

    
    //SET NAVIGATION
    navigationController.view.semanticContentAttribute = UserDefaults.standard.language == "ar" ? .forceRightToLeft : .forceLeftToRight
    
    if checkDeviceiPad(){
        navigationController.additionalSafeAreaInsets.top = 30
    }
    
    if #available(iOS 15, *) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.primary
        appearance.shadowColor = .clear

        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    }
    
    navigationController.navigationBar.barTintColor = UIColor.primary
    navigationController.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.secondary!,
         NSAttributedString.Key.font: SetTheFont(fontName: GlobalConstants.APP_FONT_Bold, size: 16.0)]
    navigationController.navigationBar.isTranslucent = isTransperent
    navigationController.navigationBar.shadowImage = UIImage() //(hideShadowImage) ? UIImage() : nil

    if isTransperent {
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
    }
    else{
        navigationController.navigationBar.setBackgroundImage(whiteImage, for: .default)
    }
    navigationController.navigationBar.setBackgroundImage(whiteImage, for: .default)

    
    
    if let actionLeft = leftActionHandler {
        navigationController.navigationItem.setHidesBackButton(true, animated: false)
        let button: UIButton = UIButton(type:.custom)
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: leftIcon), for: .normal)
        if UserDefaults.standard.language == "ar" {
            button.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        let btnAction = UIBarButtonItemWithClouser(button: button, actionHandler2: actionLeft)
        controller.navigationItem.leftBarButtonItems = [btnAction]
    }
    
    
    
    if let actionRight = rightActionHandler {
        navigationController.navigationItem.setHidesBackButton(true, animated: false)
        
        
        //LIVE BUTTON
        let viewLive = UIView(frame: CGRect.init(x: 0, y: 0, width: manageWidth(size: 82) , height: manageWidth(size: 28)))
        viewLive.backgroundColor = .clear


        //SET IMAGE
        let image = UIImage(named: rightIcon) //Your logo url here
        let imageView = UIImageView(image: image)

        imageView.frame = CGRect(x: 0, y: 0, width: viewLive.frame.size.width, height: viewLive.frame.size.height)
        imageView.contentMode = .scaleAspectFit
        viewLive.addSubview(imageView)
       
        let btnLogoAction = UIBarButtonItemWithClouser(view: viewLive, actionHandler2: actionRight)
        controller.navigationItem.rightBarButtonItems = [btnLogoAction]
    }
}



var safeAreaInset: UIEdgeInsets = {
    if #available(iOS 11.0, *) {
        if let window = UIApplication.shared.keyWindow{
            return window.safeAreaInsets
        }
        return UIEdgeInsets.zero
    }
    else{
        return UIEdgeInsets.zero
    }
}()



func GetBottomSafeAreaHeight() -> CGFloat  {
    //GET SAFE AREA HEIGHT
    var bottomSafeAreaHeight: CGFloat = 0
    if #available(iOS 11.0, *) {
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        bottomSafeAreaHeight = window.frame.maxY - safeFrame.maxY
    }
    return bottomSafeAreaHeight
}

func GetTopSafeAreaHeight() -> CGFloat  {
    //GET SAFE AREA HEIGHT
    var topSafeAreaHeight: CGFloat = 0
    if #available(iOS 11.0, *) {
        let window = UIApplication.shared.windows[0]
        let safeFrame = window.safeAreaLayoutGuide.layoutFrame
        topSafeAreaHeight = safeFrame.minY
    }
    return topSafeAreaHeight
}




func openURL(strURL : String){
    
    if let url = URL(string: "\(strURL)"), !url.absoluteString.isEmpty {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // or outside scope use this
    guard let url = URL(string: "\(strURL)"), !url.absoluteString.isEmpty else {
        return
    }
    UIApplication.shared.open(url, options: [:], completionHandler: nil)
}

//............................... VALIDATION ...............................................//

//MARK: -- Email Validation --
func validateEmail(enteredEmail:String) -> Bool {
    
    let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
    
    return emailPredicate.evaluate(with: enteredEmail)
}

func validatePhoneNumber(value: String) -> Bool {
    let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
    let inputString = value.components(separatedBy: charcterSet)
    let filtered = inputString.joined(separator: "")
    return  value == filtered
}

//......................... DEVICE INDENTIFIER .....................................//
//MARK: - DEVICE INDENTIFIER
func deviceIdentifier() -> String{
    switch UIScreen.main.nativeBounds.height {
    case 960:
        return GlobalConstants.iPhone4_4s
    case 1136:
        return GlobalConstants.iPhone5_5c_5s_SE
    case 1334:
        return GlobalConstants.iPhone6_6s_7_8
    case 1920, 2208:
        return GlobalConstants.iPhone6P_6s_6sP_7P_8P
    case 1792:
        return GlobalConstants.iPhoneXR
    case 2436:
        return GlobalConstants.iPhoneX_XS
    case 2688:
        return GlobalConstants.iPhoneXSMax
    default:
        return GlobalConstants.iPhoneUnknown
    }
}

//........................ SET VIEW CORNER RADIUS .....................................//

//SET VIEW CORNER RADIUS

//func roundCorners(on view: UIImageView?, onTopLeft tl: Bool, topRight tr: Bool, bottomLeft bl: Bool, bottomRight br: Bool, radius: Float) -> UIImageView? {
//    if tl || tr || bl || br {
//        var corner = UIRectCorner(rawValue: 0)
//        if tl {
//            corner = UIRectCorner(rawValue: corner.rawValue | UIRectCorner.topLeft.rawValue)
//        }
//        if tr {
//            corner = UIRectCorner(rawValue: corner.rawValue | UIRectCorner.topRight.rawValue)
//        }
//        if bl {
//            corner = UIRectCorner(rawValue: corner.rawValue | UIRectCorner.bottomLeft.rawValue)
//        }
//        if br {
//            corner = UIRectCorner(rawValue: corner.rawValue | UIRectCorner.bottomRight.rawValue)
//        }
//        
//        let roundedView: UIImageView? = view
//        var maskPath: UIBezierPath? = nil
//        maskPath = UIBezierPath(roundedRect: roundedView?.bounds ?? CGRect.zero, byRoundingCorners: corner, cornerRadii: CGSize(width: CGFloat(radius), height: CGFloat(radius)))
//        
//        let maskLayer = CAShapeLayer()
//        maskLayer.frame = roundedView?.bounds ?? CGRect.zero
//        maskLayer.path = maskPath?.cgPath
//        roundedView?.layer.mask = maskLayer
//        return roundedView
//    }
//    return view
//}

func roundCornersView(on view: UIView?, onTopLeft tl: Bool, topRight tr: Bool, bottomLeft bl: Bool, bottomRight br: Bool, radius: Float) -> UIView? {
    if tl || tr || bl || br {
        var corner = UIRectCorner(rawValue: 0)
        if tl {
            corner = UIRectCorner(rawValue: corner.rawValue | UIRectCorner.topLeft.rawValue)
        }
        if tr {
            corner = UIRectCorner(rawValue: corner.rawValue | UIRectCorner.topRight.rawValue)
        }
        if bl {
            corner = UIRectCorner(rawValue: corner.rawValue | UIRectCorner.bottomLeft.rawValue)
        }
        if br {
            corner = UIRectCorner(rawValue: corner.rawValue | UIRectCorner.bottomRight.rawValue)
        }
        
        let roundedView: UIView? = view
        var maskPath: UIBezierPath? = nil
        maskPath = UIBezierPath(roundedRect: roundedView?.bounds ?? CGRect.zero, byRoundingCorners: corner, cornerRadii: CGSize(width: CGFloat(radius), height: CGFloat(radius)))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = roundedView?.bounds ?? CGRect.zero
        maskLayer.path = maskPath?.cgPath
        roundedView?.layer.mask = maskLayer
        return roundedView
    }
    return view
}

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    return String((0...length-1).map{ _ in letters.randomElement()! })
}

func randomNumber(length: Int) -> String {
    let letters = "0123456789"
    return String((0...length-1).map{ _ in letters.randomElement()! })
}


//............................... SET VALUE  ............................................//
//MARK: --- DICTIONARY TO STRING

func DicToStr(arrayResponse : NSDictionary) -> String {
    //CONVERT DICTIONARY TO STRING VALUE
    var jsonData: Data? = nil
    do {
        jsonData = try JSONSerialization.data(withJSONObject: arrayResponse, options: [])
    } catch {
        print("Error")
    }
    var myString: String? = nil
    if let jsonData = jsonData {
        myString = String(data: jsonData, encoding: .utf8)
    }
    
    return myString ?? ""
}


//MARK: - Manage function for value save -
extension NSDictionary {
    func getStringForID(key: String) -> String! {
        
        var strKeyValue : String = ""
        if self[key] != nil {
            if (self[key] as? Int) != nil {
                strKeyValue = String(self[key] as? Int ?? 0)
            } else if (self[key] as? String) != nil {
                strKeyValue = self[key] as? String ?? ""
            }else if (self[key] as? Double) != nil {
                strKeyValue = String(self[key] as? Double ?? 0)
            }else if (self[key] as? Float) != nil {
                strKeyValue = String(self[key] as? Float ?? 0)
            }else if (self[key] as? Bool) != nil {
                let bool_Get = self[key] as? Bool ?? false
                if bool_Get == true{
                    strKeyValue = "1"
                }else{
                    strKeyValue = "0"
                }
            }
        }
        return strKeyValue
    }
    
    func getArrayVarification(key: String) -> NSArray {
        
        var strKeyValue : NSArray = []
        if self[key] != nil {
            if (self[key] as? NSArray) != nil {
                strKeyValue = self[key] as? NSArray ?? []
            }
        }
        return strKeyValue
    }
}


//............................... CONVERT HTML ............................................//
// MARK: - CONVERT HTML -

extension UIDevice {
    
    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                return "iPhone X"
            case "iPhone11,2":                              return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
            case "iPhone11,8":                              return "iPhone XR"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad6,11", "iPad6,12":                    return "iPad 5"
            case "iPad7,5", "iPad7,6":                      return "iPad 6"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4":                      return "iPad Pro (9.7-inch)"
            case "iPad6,7", "iPad6,8":                      return "iPad Pro (12.9-inch)"
            case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
            case "AppleTV5,3":                              return "Apple TV"
            case "AppleTV6,2":                              return "Apple TV 4K"
            case "AudioAccessory1,1":                       return "HomePod"
            case "i386", "x86_64":                          return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                        return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }
        
        return mapToDevice(identifier: identifier)
    }()
    
}


//URL
enum Url {

    //LOGINA AND REGISTRATION
    static let login = NSURL(string: "\(Application.BaseURL)MemberLogin\(Application.appAPIName)")!
    static let signup = NSURL(string: "\(Application.BaseURL)NewMember\(Application.appAPIName)")!

    static let forgetPassword = NSURL(string: "\(Application.BaseURL)MemberPassReset\(Application.appAPIName)")!

}


extension UIImage {
    
    public convenience init?(setColor: UIColor?, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        setColor?.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}


extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

func getVersionNumber(strVersionNumber : String) -> Int{
    let array = strVersionNumber.components(separatedBy: ".")
    print(array)
    var versionNumber : Int = 0
    for i in 0..<array.count{
        let number = array[i]
        //ADD SUM
        if i == 0{
            versionNumber  = (Int(number) ?? 0) * 1000
        }
        else{
            versionNumber = versionNumber + (Int(number) ?? 0)
        }
    }
    return versionNumber
}

func ImpactGenerator(){
    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
    impactFeedbackgenerator.prepare()
    impactFeedbackgenerator.impactOccurred()
}



//CHECK PRODUCT
func isDevelopmentProvisioningProfile() -> Bool {
    return true
    
}


func removeZero(strNumber : String) -> String{
    var arrString = Array(strNumber)
    if arrString.count != 0{
        if arrString[0] == "0"{
            arrString.remove(at: 0)
        }
        
        var Number : String = ""
        for str in arrString{
            Number = "\(Number)\(str)"
        }
        
        return Number
    }
    return ""
}


//MARK: -- Data Formate Convertion --
func convertStringToDate(dateString: String, withFormat format: String) -> Date? {
    if isValidDate(dateString: dateString, currentFormate: format) {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = format

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            return outputFormatter.date(from: outputFormatter.string(from: date))
        }
    }
   
    return Date()
}



func convertDateToString(date: Date, withFormat format: String, newFormate : String) -> String? {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = format
    let strDate = inputFormatter.string(from: date)

    if let date = inputFormatter.date(from: strDate) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = newFormate
        return outputFormatter.string(from: date)
    }
    return strDate
}


func CurrntDateToString( withFormat format: String, newFormate : String) -> String? {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = format
    let strDate = inputFormatter.string(from: Date())
    return strDate
}


func convertDateToNewFormateString(date: Date, withFormat format: String, newFormate : String) -> String? {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = format
    let strDate = inputFormatter.string(from: date)

    if let date = inputFormatter.date(from: strDate) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = newFormate
        return outputFormatter.string(from: date)
    }
    return strDate
}


func convertToGMT(dateToConvert:String) -> Date {
    let formatter = DateFormatter()
    formatter.dateFormat = Application.serverDateFormet
    let convertedDate = formatter.date(from: dateToConvert)
    formatter.timeZone = TimeZone(identifier: "GMT+6")
    return convertStringToDate2(dateString: formatter.string(from: convertedDate!)) ?? Date()
}

func convertStringToDate2(dateString: String) -> Date? {
    if isValidDate(dateString: dateString, currentFormate: Application.serverDateFormet) {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = Application.serverDateFormet

        if let date = inputFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = Application.serverDateFormet
            return outputFormatter.date(from: outputFormatter.string(from: date))
        }
    }
   
    return Date()
}

func convertDateFormater(_ OrderDate: String, CurrentDateFormate : String, ChangeDateFormate  :String) -> String{
    
    if isValidDate(dateString: OrderDate, currentFormate: CurrentDateFormate) {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = CurrentDateFormate
        let date = dateFormatter.date(from: OrderDate)
        dateFormatter.dateFormat = ChangeDateFormate
        return  dateFormatter.string(from: date!)
    }
    return ""
}




func isValidDate(dateString: String, currentFormate : String?) -> Bool {
    let dateFormatterGet = DateFormatter()
    dateFormatterGet.dateFormat = currentFormate
    if let _ = dateFormatterGet.date(from: dateString) {
        //date parsing succeeded, if you need to do additional logic, replace _ with some variable name i.e date
        return true
    } else {
        // Invalid date
        return false
    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}


extension String {
    func isValidPassword() -> Bool {
        //        let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}"
        let regularExpression = "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).{8,}$"
        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        
        return passwordValidation.evaluate(with: self)
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}









