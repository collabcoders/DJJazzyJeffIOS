//
//  HomeViewController.swift
//  DJJazzyJeff
//
//  Created by Jigar Khatri on 23/11/22.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var btnLogout: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}




//MARK: - BUTTON ACTION
extension HomeViewController{
    
    @IBAction func btnLogOutClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: str.areYouSureYouWantToLogout, preferredStyle: .alert)
        alert.view.tintColor = UIColor.secondary
        alert.addAction(UIAlertAction(title: str.yes, style: .default,handler: { (Action) in
            
          
            LogOutUser()
            
        }))
        alert.addAction(UIAlertAction(title: str.no, style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
}
