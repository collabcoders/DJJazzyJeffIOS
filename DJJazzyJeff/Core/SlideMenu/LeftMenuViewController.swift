//
//  LeftMenuViewController.swift
//  KICC
//
//  Created by Jigar Khatri on 19/11/21.
//

import UIKit


struct MenuModel {
    var name: String
    let imgMenu: String
}

class LeftMenuViewController: UIViewController {
    //DECLARE VARIABLE
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var imgTop: UIImageView!

    //MENU LIST
    var arrMenuList = [MenuModel(name: str.strLiveStream, imgMenu: "icon_videocam"),
                   MenuModel(name: str.strVideos, imgMenu: "icon_film"),
                   MenuModel(name: str.strMusic, imgMenu: "icon_musical"),
                   MenuModel(name: str.strStore, imgMenu: "icon_storefront"),
                   MenuModel(name: str.strUpgrade, imgMenu: "icon_person"),
                   MenuModel(name: str.strFavorites, imgMenu: "icon_heart"),
                   MenuModel(name: str.strSignOut, imgMenu: "icon_logout")]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        showToast(sender: self.view, message: "sfs")
        
        //SET VIEW
//        self.view.backgroundColor = UIColor.background
        setNeedsStatusBarAppearanceUpdate()
      
        //SET NAVIGAITON AND TABBAR
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    
        
        //SET HEADER
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            //SET TABLE HEADER
            let vw_Table = self.tblView.tableHeaderView
            vw_Table?.frame = CGRect(x: 0, y: 0, width: self.tblView.frame.size.width, height: self.imgTop.frame.origin.y + self.imgTop.frame.size.height + 20)
            self.tblView.tableHeaderView = vw_Table
        }
     }
}



//.......................... UITABLE VIEW ..........................//

//MARK: -- UITABEL CELL --
class LeftMenuCell : UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgMenu: UIImageView!
}


//MARK: -- UITABEL DELEGATE --

extension LeftMenuViewController:UITableViewDelegate, UITableViewDataSource{
    
    //HEADER SECTION
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrMenuList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftMenuCell") as! LeftMenuCell
        cell.backgroundColor = UIColor.clear
        
        //SET FONT
        cell.lblName.configureLable(textColor: .primary, fontName: GlobalConstants.APP_FONT_Medium, fontSize: 16.0, text: self.arrMenuList[indexPath.row].name )
        cell.imgMenu.image = UIImage(named: self.arrMenuList[indexPath.row].imgMenu )
        imgColor(imgColor: cell.imgMenu, colorHex: .secondary)
        
        cell.layoutIfNeeded()
        return cell
    }
 }
