//
//  NoInternetViewController.swift
//  Belboy
//
//  Created by Jigar Khatri on 30/04/21.
//

import UIKit
import Alamofire
import AVFoundation

protocol InternetAccessDelegate {
    func ReceiveInternetNotify(strMethodName: String)
}

class NoInternetViewController: UIViewController{

    @IBOutlet weak var con_button: NSLayoutConstraint!

    @IBOutlet weak var lblConnectionTitle : UILabel!
    @IBOutlet weak var lblConnectionSubTitle : UILabel!
    @IBOutlet weak var imgLogo : UIImageView!

    @IBOutlet weak var viewRetry: UIView!
    @IBOutlet weak var btnRetry : UIButton!

    
    var strCallingMethodName : String = ""
    var delegate: InternetAccessDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.PortraitMode()
        
        //SET VIEW
        setNeedsStatusBarAppearanceUpdate()
        
        //SET NAVIGAITON AND TABBAR
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        
        //SET FONT
        self.SetFontAndColors()
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var shouldAutorotate: Bool {
        return true
    }
    
    //MARK:- SET FONT AND COLORS
    func SetFontAndColors(){
        
        //SET BUTTON
        con_button.constant = manageWidth(size: 175)

        
        //SET FONT
        lblConnectionTitle.configureLable(textColor: .primary, fontName: GlobalConstants.APP_FONT_Bold, fontSize: 30.0, text: str.noNetTitle)
        lblConnectionTitle.textAlignment = .center
        lblConnectionSubTitle.configureLable(textColor: UIColor.primary, fontName: GlobalConstants.APP_FONT_Medium, fontSize: 24.0, text: str.noNetTitle2)
        lblConnectionSubTitle.textAlignment = .center
        
        btnRetry.configureLable(bgColour: .clear, textColor: .primary, fontName: GlobalConstants.APP_FONT_Medium, fontSize: 24.0, text: str.strRetry)
        
                
        //SET VIEW
        self.viewRetry.setTheTextView()
      
        
    }
    
    @IBAction func btnRetryClick(_ sender : UIButton){
        if NetworkReachabilityManager()!.isReachable {
            self.delegate?.ReceiveInternetNotify(strMethodName: strCallingMethodName)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
}
