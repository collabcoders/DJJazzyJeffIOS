//
//  FavoritesViewController.swift
//  DJJazzyJeff
//
//  Created by Jigar Khatri on 19/12/22.
//

import UIKit
import Nuke
import ObjectMapper

class FavoritesViewController: UIViewController {

    //DECLARE VARIABLE
    @IBOutlet weak var tblView: UITableView!

    @IBOutlet weak var viewSearch: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var con_Bottom : NSLayoutConstraint!



    //OTHER VARIABLE
    var arrFavoriteMusic : [FacoritesModel] = []
    var arrSearchMusic : [FacoritesModel] = []

    //LOADING
    var isLoading : Bool = true
    var objRefresh : UIRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshList), name: .removeFavorit, object: nil)

        
        //SET KEYBORD
        setupKeyboard(true)

//        self.txtSearch.becomeFirstResponder()

        NotificationCenter.default.addObserver(self, selector: #selector(self.setBottomView(_:)), name: .plsyMusic, object: nil)

        // Do any additional setup after loading the view.
        
        
        //SET REFRSH CONTROL
        self.objRefresh = UIRefreshControl()
        let refreshView = UIView(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.height, width: 0, height: 0))
        self.tblView.addSubview(refreshView)
        self.objRefresh?.tintColor = UIColor.primary
        self.objRefresh?.addTarget(self, action: #selector(self.refreshList), for: .valueChanged)
        refreshView.addSubview(self.objRefresh!)
        

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.PortraitMode()
        
        //SET VIEW
        setNeedsStatusBarAppearanceUpdate()
        
        //SET NAVIGAITON AND TABBAR
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.tabBar.isHidden = true
        
        //SET NAVIGATION BAR
        setNavigationBarFor(controller: self, title: str.strFavorites, isTransperent: true, hideShadowImage: true, leftIcon: "icon_back", rightIcon: "") {
            self.navigationController?.popViewController(animated: true)

        } rightActionHandler: {
        }
        
        
        //SET VIEW
        self.setTheView()
        
        //GET DATA
        self.refreshList()
    }

    @objc func setBottomView(_ notification: Notification){
        
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: [],
                       animations: { () -> Void in
            self.con_Bottom.constant = isMusicViewOpen ? manageWidth(size: 220) : 0

            self.view.layoutIfNeeded()
            self.view.layoutSubviews()
            self.view.superview?.layoutIfNeeded()
            
        }, completion: { (finished) -> Void in
            // ....
//            self.

        })
        
    }
    
    @objc func refreshList() {
        //GET BANNER DATA
        self.getFavoritesMusicAPI()
    }

    //SET THE VIEW
    func setTheView() {

        //SET TEXT
        self.txtSearch.configureText(bgColour: UIColor.clear, textColor: UIColor.primary, fontName: GlobalConstants.APP_FONT_Medium, fontSize: 20.0, text: "", placeholder: str.strSearch)
        self.txtSearch.clearButtonMode = .whileEditing
        self.txtSearch.text = ""
        if let clearButton = txtSearch.value(forKey: "_clearButton") as? UIButton{
            let templateImage =  clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
            // Set the template image copy as the button image
            clearButton.setImage(templateImage, for: .normal)
            // Finally, set the image color
            clearButton.tintColor = .gray
        }
        
        //SET SEARCH TEXT
        self.txtSearch.addTarget(self, action: #selector(textFieldDidChangeSearch), for: .editingChanged)

        
        
        //SET VIEW
        self.viewSearch.viewCorneRadius(radius: 10.0, isRound: false)
    }
    
    // MARK: - UITEXTFIELD
    @objc func textFieldDidChangeSearch() {
        let strSearch = txtSearch.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) ?? ""
        
        //GET STORE LIST
        self.arrSearchMusic = []
        if strSearch != ""{
            self.arrSearchMusic = self.arrFavoriteMusic.filter { Int((($0.title?.lowercased()) as NSString?)?.range(of: strSearch.lowercased()).location ?? 0) != NSNotFound}
        }
        
       
        //RELOAD TABLE
        self.tblView.reloadData()
        
    }
}


//MARK:: UITableViewDelegate, UITableViewDataSource
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
  
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.txtSearch.text != ""{
            if self.arrSearchMusic.count != 0{
                return self.arrSearchMusic.count
            }
            else{
                return 0
            }
        }
        else{
            return self.arrFavoriteMusic.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MusicListCell") as? MusicListCell{
            cell.backgroundColor = UIColor.clear
            if isLoading {
                return cell
            }
            
            //GET DETAILS
            var objData = self.arrFavoriteMusic[indexPath.row]
            if self.arrSearchMusic.count != 0{
                objData = self.arrSearchMusic[indexPath.row]
            }
            
            //SET DETAILS
            imgColor(imgColor: cell.imgNext, colorHex: .lightGray)
            cell.lblName.configureLable(textColor: .secondary, fontName: GlobalConstants.APP_FONT_Bold, fontSize: 18.0, text: objData.title ?? "")
            cell.lblTitle.configureLable(textColor: .secondary, fontName: GlobalConstants.APP_FONT_Medium, fontSize: 18.0, text: objData.artist ?? "" == "DJ Jazzy Jeff" ? "\(objData.artist ?? "")" : "DJ Jazzy Jeff + \(objData.artist ?? "")")
            cell.lblTitle.alpha = 0.8
                        
            cell.lblData.configureLable(textColor: .primary, fontName: GlobalConstants.APP_FONT_Medium, fontSize: 14.0, text: convertStringDateToString(dateString: objData.date ?? "", withFormat: Application.pickerDateFormet2, newFormate: Application.strDateFormet) ?? "")
            cell.lblTime.configureLable(textColor: .primary, fontName: GlobalConstants.APP_FONT_Medium, fontSize: 14.0, text: objData.duration ?? "")
            
            
            //SET TYPE
            if objData.type?.lowercased() == "music"{
                cell.imgType.image = UIImage(named: "icon_Musical2")
            }
            else{
                cell.imgType.image = UIImage(named: "icon_Videocam")
            }
            
            //SET IMAGE
            DispatchQueue.main.async {
                cell.imgMusic.image =  nil
                if let strImg = objData.image{
                    let imgURL =  ("\(strImg)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) ?? ""
                    if let url = URL(string: imgURL.replacingOccurrences(of: " ", with: "%20")){
                        Nuke.loadImage(with: url, options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)), into: cell.imgMusic)
                        cell.imgMusic.setGifFromURL(url, customLoader: nil)
                    }
                }
            }
            
                        
            cell.layoutIfNeeded()
            return cell
        }

        return UITableViewCell()
    }
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        //GET DATA
        let objData = self.arrFavoriteMusic[indexPath.row]
        if objData.type?.lowercased() == "music"{
            //REMOVE PLAYER
            playerVideo = nil
            playerVideo?.pause()
            playerTimer?.invalidate()
            
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            window?.endEditing(true)
            
            
            var objMusicData : AllMusicModel!
            let map = Map(mappingType: .fromJSON, JSON: [:])
            objMusicData = AllMusicModel(map: map)

            //SET DATA
            objMusicData.musicId = 0
            objMusicData.favId = objData.favId ?? 0
            objMusicData.duration = objData.duration
            objMusicData.title = objData.title
            objMusicData.file = objData.file
            objMusicData.image = objData.image
            
            musicView.commonInit(objData: objMusicData, isFavorite: true)
            if isMusicViewOpen == false {
                window?.addSubview(musicView)
            }
        }
    }
}
