//
//  TabbarViewController.swift
//  Belboy
//
//  Created by Jigar Khatri on 30/04/21.
//

import UIKit

class TabbarViewController: UITabBarController, UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        NotificationCenter.default.addObserver(self, selector: #selector(self.addItemInCart(notificatio:)), name: .cartUpdated, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.languageUpdated(notificatio:)), name: .languageUpdate, object: nil)
        
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: SetTheFont(fontName: GlobalConstants.APP_FONT_Regular, size: 10.0)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: SetTheFont(fontName: GlobalConstants.APP_FONT_Regular, size: 10.0)], for: .selected)
        
        
        self.delegate = self
        configureTabBar()
    }
    
    
    
    func resize(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: image.size.height))
        image.draw(in: CGRect(x: 00, y: -30, width: newWidth, height: image.size.height + 10)) // image.drawInRect( CGRect(x: 0, y: 0, width: newWidth, height: image.size.height))  in swift 2
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    
    fileprivate func configureTabBar() {
        
        tabBar.sizeToFit()

                
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = UIColor.clear
            tabBar.standardAppearance = appearance
            
        }
        
        
        if #available(iOS 15.0, *) {
           let appearance = UITabBarAppearance()
           appearance.configureWithOpaqueBackground()
           appearance.backgroundColor = UIColor.clear
           
           tabBar.standardAppearance = appearance
           tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
       
        
        self.delegate = self
        
        var controller:[UINavigationController] = []
        
        //HOME TABBAR
        let storyBoardHome: UIStoryboard = UIStoryboard(name: GlobalConstants.HOME_MODEL, bundle: nil)
        if let tabOne = storyBoardHome.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            
            let item = UITabBarItem()
            item.title = ""
            tabOne.tabBarItem = item
            
            let navigationController = UINavigationController(rootViewController: tabOne)
            navigationController.view.backgroundColor = UIColor.clear
            navigationController.interactivePopGestureRecognizer?.isEnabled = true
            navigationController.interactivePopGestureRecognizer?.delegate = self
            controller.append(navigationController)
        }
        
    
        viewControllers = controller
    }
    
    
 
  
}




extension TabbarViewController{
    
    @objc private func languageUpdated(notificatio: NSNotification?){
        configureTabBar()
    }
    
}

extension TabbarViewController: UIGestureRecognizerDelegate{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}



