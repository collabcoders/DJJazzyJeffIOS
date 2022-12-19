//
//  LiveStreamingViewController.swift
//  DJJazzyJeff
//
//  Created by Jigar Khatri on 09/12/22.
//

import UIKit
import WebKit

class LiveStreamingViewController: UIViewController, WKNavigationDelegate {

    //DECLARE VARIABLE
    @IBOutlet weak var objVideoWebView: WKWebView!
    @IBOutlet weak var con_VideoHeight : NSLayoutConstraint!

    @IBOutlet weak var objChatWebView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //SET VIDEO
        self.objVideoWebView.backgroundColor = .clear
        self.objVideoWebView.navigationDelegate = self
        self.objVideoWebView!.scrollView.backgroundColor = UIColor.clear
        self.objVideoWebView.scrollView.isScrollEnabled = false

        //SET CHAT
        self.objChatWebView.backgroundColor = .clear
        self.objChatWebView.navigationDelegate = self
        self.objChatWebView!.scrollView.backgroundColor = UIColor.clear
        self.objChatWebView.scrollView.isScrollEnabled = false

        indicatorShow()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.PortraitMode()
        self.view.backgroundColor = .red
        
        //SET VIEW
        setNeedsStatusBarAppearanceUpdate()
        
        //SET NAVIGAITON AND TABBAR
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.tabBar.isHidden = true
        
        //SET NAVIGATION BAR
        setNavigationBarFor(controller: self, title: str.strLiveStream, isTransperent: true, hideShadowImage: true, leftIcon: "icon_back", rightIcon: "") {
            self.navigationController?.popViewController(animated: true)

        } rightActionHandler: { 
        }
        
        //GET DATA
        self.getLiveStreemingData()
        
        //SET HEIGHT
        self.con_VideoHeight.constant = 0
                
        //STOP PLAYER
        main_thread {
            if isMusicViewOpen{
                isMusicPlay = true
            }
            musicView.removeMusicView()
        }
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.navigationController?.popViewController(animated: true)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicatorHide()
    }
}
