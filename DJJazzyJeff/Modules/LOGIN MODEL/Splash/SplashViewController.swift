//
//  SplashViewController.swift
//  DJ Jazzy Jaff
//
//  Created by Jigar Khatri on 18/11/22.
//

import UIKit

class SplashViewController: UIViewController {
    var window: UIWindow?

    //DECLARE VARIABLE
    @IBOutlet weak var objIndicator : UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewWillAppear(_ animated: Bool) {

        self.objIndicator.isHidden = false
        self.objIndicator.startAnimating()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
            self.checkUserLogin()
        }
        
        //SET PORTRAIT MODE
        AppUtility.PortraitMode()
    
        
        //SET NAVIGAITON AND TABBAR
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true
        
      
    }

    func checkUserLogin(){
        self.objIndicator.stopAnimating()

        if UserDefaults.standard.user != nil{
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
        else{
            //MOVE TO LOGIN SCREEN
            let storyBoard: UIStoryboard = UIStoryboard(name: GlobalConstants.LOGIN_MODEL, bundle: nil)
            if let newViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController{
                /* Initiating instance of ui-navigation-controller with view-controller */
                let navigationController = UINavigationController()
                navigationController.viewControllers = [newViewController]
                GlobalConstants.appDelegate?.window?.rootViewController = navigationController
                GlobalConstants.appDelegate?.window?.makeKeyAndVisible()
            }
        }
    }
}



