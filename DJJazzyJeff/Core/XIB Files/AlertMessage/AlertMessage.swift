//
//  AlertMessage.swift
//  BAYNOUNAH
//
//  Created by Jigar Khatri on 22/06/22.
//

import UIKit

class AlertMessage: UIView {

    //VIEW
    @IBOutlet weak var subView: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var lblTitle: UILabel!
    
        // method to load reasons xib.
    func loadPopUpView(strMessage : String) {
        // ContactUS name of the XIB.
        Bundle.main.loadNibNamed("AlertMessage", owner:self, options:nil)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.subView.layer.cornerRadius = 10.0
        self.mainView.frame = self.bounds
        self.addSubview(self.mainView)
        self.mainView.layoutIfNeeded()
        
        
        //SET ANIMATION
        self.subView.transform = CGAffineTransform(scaleX: 0.2, y:0.2)
        UIView.animate(withDuration:1.0, delay: 0.0, usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.5, options: [], animations:
            {
                self.subView.transform = CGAffineTransform(scaleX: 1.0, y:1.0)
        }, completion:nil)
        

        //SET FONT
        self.setTheView(strMessage: strMessage)
    }
    
    func removeViewWithAnimation(isClose : Bool) {
        self.subView.transform = CGAffineTransform.identity
        UIView.animate(withDuration: 0.1, animations: {
            self.subView.transform = CGAffineTransform(scaleX: 1.01, y:1.01)
        } ,completion:{ (finished) in
            if(finished) {
                self.alpha = 1.0
                UIView.animate(withDuration:0.5, animations: {
                    self.alpha = 0
                    self.subView.transform = CGAffineTransform(scaleX: 0.2, y:0.2)
                }, completion: { (finished) in
                    if(finished) {
                        self.removeFromSuperview()
                    }
                })
            }
        })
    }
    
    //SET THE VIEW
    func setTheView(strMessage : String) {
        //SET FONT
        lblTitle.configureLable(textColor: UIColor.secondary, fontName: GlobalConstants.APP_FONT_Bold, fontSize: 20.0, text:  strMessage)

        //SET VIEW
        self.subView.backgroundColor = UIColor.primary
        self.subView.viewCorneRadius(radius: 10.0, isRound: false)
    }
    
    //......................... OTHER FUNCION .........................//
    @IBAction func btnCloseClicked(_ sender: Any) {
        removeViewWithAnimation(isClose: false)
    }

    
}



