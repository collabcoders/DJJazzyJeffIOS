//
//  RightMenuViewController.swift
//  KICC
//
//  Created by Jigar Khatri on 19/11/21.
//

import UIKit

class RightMenuViewController: UIViewController {
    //DECLARE VARIABLE
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var imgBG: UIImageView!
    @IBOutlet weak var con_ButtonHieght : NSLayoutConstraint!
    
    
    var menuNavigationController = UINavigationController()
    
    //LIST
    //    var arrList = [str.radio, str.sundayLive, str.prayer, str.shows, str.schedule, str.donate, str.about, str.privacyPolicy, str.termsConditions]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        imgBG.transform = imgBG.transform.rotated(by: .pi)
        
        // Do any additional setup after loading the view.
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
}
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        AppUtility.PortraitMode()
//
//        con_ButtonHieght.constant = manageWidth(size: 35.0)
//
//        //SET VIEW
//       setNeedsStatusBarAppearanceUpdate()
//
//        //SET NAVIGAITON AND TABBAR
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//
//        if UserDefaults.standard.user != nil{
//            arrList = [str.radio, str.sundayLive, str.prayer, str.shows, str.schedule, str.donate, str.accountSetting, str.about, str.privacyPolicy, str.termsConditions, str.logOut, str.VERSION]
//        }
//        else{
//            arrList = [str.radio, str.sundayLive, str.prayer, str.shows, str.schedule, str.donate, str.about, str.privacyPolicy, str.termsConditions, str.logIn, str.VERSION]
//        }
//
//        //RELOAD
//        self.tblView.reloadData()
//
//
//     }
//}
//
//
//
////MARK: - BUTTON ACTION
//extension RightMenuViewController{
//    @IBAction func btnCloseClicked(_ sender: UIButton) {
//        slideMenuController()?.closeRight(strName: "")
//    }
//
//
//    @IBAction func btnInstaGramClicked(_ sender: UIButton) {
//        self.view.endEditing(true)
//        opneExternalURL(strURL: Application.instagram)
//    }
//
//
//    @IBAction func btnTwitterClicked(_ sender: UIButton) {
//        self.view.endEditing(true)
//        opneExternalURL(strURL: Application.twitter)
//    }
//
//    @IBAction func btnYoutubeClicked(_ sender: UIButton) {
//        self.view.endEditing(true)
//        opneExternalURL(strURL: Application.youtube)
//    }
//
//    @IBAction func btnFacebookClicked(_ sender: UIButton) {
//        self.view.endEditing(true)
//        opneExternalURL(strURL: Application.facebook)
//    }
//
//
//}
//
//
////.......................... UITABLE VIEW ..........................//
//
////MARK: -- UITABEL CELL --
//class RightMenuCell : UITableViewCell{
//    @IBOutlet weak var lblName: UILabel!
//    @IBOutlet weak var viewLine: UIView!
//    @IBOutlet weak var viewBG: UIView!
//    @IBOutlet weak var con_lableTop : NSLayoutConstraint!
//    @IBOutlet weak var con_ViewLineTop : NSLayoutConstraint!
//    @IBOutlet weak var con_ViewBGTop : NSLayoutConstraint!
//    @IBOutlet weak var con_ViewBGButtom : NSLayoutConstraint!
//}
//class VersionCell : UITableViewCell{
//    @IBOutlet weak var lblName: UILabel!
//}
//class LogOutCell : UITableViewCell{
//    @IBOutlet weak var btnLogOut: UIButton!
//}
//
//
////MARK: -- UITABEL DELEGATE --
//
//extension RightMenuViewController:UITableViewDelegate, UITableViewDataSource{
//
//    //HEADER SECTION
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return arrList.count
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        return UITableView.automaticDimension
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if arrList[indexPath.row] == str.logOut || arrList[indexPath.row] == str.login{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "LogOutCell") as! LogOutCell
//            cell.backgroundColor = UIColor.clear
//
//            //SET FONT
//            cell.btnLogOut.configureLable(bgColour: UIColor.background, textColor: UIColor.standard, fontName: GlobalConstants.APP_FONT_Regular, fontSize: 12.0, text: arrList[indexPath.row])
//            DispatchQueue.main.async {
//                cell.btnLogOut.btnCorneRadius(radius: 0, isRound: true)
//            }
//            cell.btnLogOut.btnnBorder(bgColour: UIColor.standard)
//
//            cell.btnLogOut.addTarget(self, action: #selector(btnLogOutClicked(_:)), for: .touchUpInside)
//
//
//            cell.layoutIfNeeded()
//            return cell
//        }
//        else if arrList[indexPath.row] == str.VERSION{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "VersionCell") as! VersionCell
//            cell.backgroundColor = UIColor.clear
//
//            //SET FONT
//            cell.lblName.configureLable(textColor: UIColor.gray_light, fontName: GlobalConstants.APP_FONT_Regular, fontSize: 12.0, text: Application.VERSION)
//
//
//            return cell
//        }
//        else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "RightMenuCell") as! RightMenuCell
//            cell.backgroundColor = UIColor.clear
//
//            //SET FONT
//            cell.lblName.configureLable(textColor: UIColor.gray_light, fontName: GlobalConstants.APP_FONT_Regular, fontSize: 16.0, text: self.arrList[indexPath.row])
//
//            //SET VIEW LINE
//            cell.viewLine.backgroundColor = UIColor.primary
//            cell.viewLine.isHidden = true
//            cell.con_lableTop.constant = 12
//            cell.con_ViewLineTop.constant = 12
//            cell.con_ViewBGTop.constant = 0
//            cell.con_ViewBGButtom.constant = 0
//            if self.arrList[indexPath.row] == str.donate{
//                cell.con_ViewLineTop.constant = 30
//                cell.con_ViewBGButtom.constant = 18
//                cell.viewLine.isHidden = false
//            }
//            else if self.arrList[indexPath.row] == str.accountSetting{
//                cell.con_lableTop.constant = 30
//                cell.con_ViewBGTop.constant = 18
//            }
//
//            //SET BG VIEW
//
//            cell.viewBG.bgColour(bgColour: UIColor.primary, alpha: 0.5)
//            cell.viewBG.isHidden = true
//            if indexRightMenu == indexPath.row{
//                cell.viewBG.isHidden = false
//            }
//
//            cell.layoutIfNeeded()
//            return cell
//        }
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        //STOP PLAYER
//        if globleTimerOnline != nil{
//            globleTimerOnline.invalidate()
//        }
//        NotificationCenter.default.post(name: .stopPlaying, object: nil, userInfo: nil)
//
//        //CEHCK INDEX
//        if indexRightMenu == indexPath.row{
//            slideMenuController()?.closeRight(strName: "")
//            return
//        }
//
//
//        //SELECT INDEX
//        indexRightMenu = indexPath.row
//        self.tblView.reloadData()
//
//        //CLOSER VIEW
//        slideMenuController()?.closeRight(strName: arrList[indexPath.row])
//
////        if arrList[indexPath.row] == str.sundayLive{
////            slideMenuController()?.closeRight(strName: str.sundayLive)
////
////
////
//////            let storyBoard: UIStoryboard = UIStoryboard(name: GlobalConstants.HOME_MODEL, bundle: nil)
//////            if let newViewController = storyBoard.instantiateViewController(withIdentifier: "SundayLiveViewController") as? SundayLiveViewController{
//////                menuNavigationController.view.removeFromSuperview()
//////                menuNavigationController = UINavigationController(rootViewController: newViewController)
//////                newViewController.newNavigationController = menuNavigationController
//////                slideMenuController()?.changeMainViewController(menuNavigationController, close: true)
//////            }
////
////
////
////        }
////
////        else if arrList[indexPath.row] == str.prayer{
////            slideMenuController()?.closeRight(strName: str.sundayLive)
////
//////
//////            let storyBoard: UIStoryboard = UIStoryboard(name: GlobalConstants.HOME_MODEL, bundle: nil)
//////            if let newViewController = storyBoard.instantiateViewController(withIdentifier: "PrayerViewController") as? PrayerViewController{
//////                menuNavigationController.view.removeFromSuperview()
//////                menuNavigationController = UINavigationController(rootViewController: newViewController)
//////                newViewController.newNavigationController = menuNavigationController
//////                slideMenuController()?.changeMainViewController(menuNavigationController, close: true)
//////            }
////        }
////
////
////
////        else if arrList[indexPath.row] == str.shows{
////            slideMenuController()?.closeRight(strName: str.shows)
////
//////            let storyBoard: UIStoryboard = UIStoryboard(name: GlobalConstants.HOME_MODEL, bundle: nil)
//////            if let newViewController = storyBoard.instantiateViewController(withIdentifier: "ShowsViewController") as? ShowsViewController{
//////                menuNavigationController.view.removeFromSuperview()
//////                menuNavigationController = UINavigationController(rootViewController: newViewController)
//////                newViewController.newNavigationController = menuNavigationController
//////                slideMenuController()?.changeMainViewController(menuNavigationController, close: true)
//////            }
////        }
//
////        else if arrList[indexPath.row] == str.schedule{
////            let storyBoard: UIStoryboard = UIStoryboard(name: GlobalConstants.HOME_MODEL, bundle: nil)
////            if let newViewController = storyBoard.instantiateViewController(withIdentifier: "ScheduleViewController") as? ScheduleViewController{
////                menuNavigationController.view.removeFromSuperview()
////                menuNavigationController = UINavigationController(rootViewController: newViewController)
////                newViewController.newNavigationController = menuNavigationController
////                slideMenuController()?.changeMainViewController(menuNavigationController, close: true)
////            }
////        }
////
////        else if arrList[indexPath.row] == str.donate{
////            opneExternalURL(strURL: Application.DonateURL)
////        }
////
////        else if arrList[indexPath.row] == str.accountSetting{
////            let storyBoard: UIStoryboard = UIStoryboard(name: GlobalConstants.LOGIN_MODEL, bundle: nil)
////            if let newViewController = storyBoard.instantiateViewController(withIdentifier: "AccountSettingViewController") as? AccountSettingViewController{
////                menuNavigationController.view.removeFromSuperview()
////                menuNavigationController = UINavigationController(rootViewController: newViewController)
////                newViewController.newNavigationController = menuNavigationController
////                slideMenuController()?.changeMainViewController(menuNavigationController, close: true)
////            }
////        }
////
////        else if arrList[indexPath.row] == str.about{
////            let storyBoard: UIStoryboard = UIStoryboard(name: GlobalConstants.HOME_MODEL, bundle: nil)
////            if let newViewController = storyBoard.instantiateViewController(withIdentifier: "AboutUsViewController") as? AboutUsViewController{
////                menuNavigationController.view.removeFromSuperview()
////                menuNavigationController = UINavigationController(rootViewController: newViewController)
////                newViewController.newNavigationController = menuNavigationController
////                slideMenuController()?.changeMainViewController(menuNavigationController, close: true)
////            }
////        }
////        else if arrList[indexPath.row] == str.privacyPolicy{
////            opneExternalURL(strURL: Application.privacyPolicy)
////        }
////        else if arrList[indexPath.row] == str.termsConditions{
////            opneExternalURL(strURL: Application.termsCondition)
////
////        }
//
//    }
//
//
//
//    @objc func btnLogInClicked(_ sender: UIButton){
//
//
//    }
//
//
//    @objc func btnLogOutClicked(_ sender: UIButton){
//
//        if UserDefaults.standard.user == nil{
//            self.slideMenuController()?.closeRight(strName: "")
//
//            //LOGINN SCREEN
//            let storyBoard: UIStoryboard = UIStoryboard(name: GlobalConstants.LOGIN_MODEL, bundle: nil)
//            if let navView = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
//                navView.isLoginScreenPresent = true
//                let vieweNavigationController = UINavigationController(rootViewController: navView)
//                vieweNavigationController.modalPresentationStyle = .fullScreen
//                self.present(vieweNavigationController, animated: true, completion: nil)
//            }
//        }
//        else{
//
//            let alert = UIAlertController(title: Application.appName, message: str.areYouSureYouWantToLogout, preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: str.yes, style: .default,handler: { (Action) in
//                //REMOVE ALL DATA
//                arrShowsList = []
//                arrVideoList = []
//                arrReminderList = []
//                UserDefaults.standard.user = nil
//                NotificationCenter.default.post(name: .languageUpdate, object: nil, userInfo: nil)
//                self.slideMenuController()?.closeRight(strName: "")
//
//            }))
//            alert.addAction(UIAlertAction(title: str.no, style: .cancel, handler: nil))
//            self.present(alert, animated: true)
//        }
//    }
//
//}
