//
//  HomeViewController.swift
//  DJJazzyJeff
//
//  Created by Jigar Khatri on 23/11/22.
//

import UIKit
import SlideMenuControllerSwift
import Nuke
import AVFoundation

class HomeViewController: UIViewController {

    //DECLARE VARIABLE
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var viewLoader: UIView!
    @IBOutlet weak var objIndicator : UIActivityIndicatorView!
    @IBOutlet weak var con_Bottom : NSLayoutConstraint!

    //COLLECTIN VIEW
    @IBOutlet weak var objBannerCollection: UICollectionView!
    @IBOutlet weak var con_BannerHeight: NSLayoutConstraint!

    //ALL VIDEO
    @IBOutlet weak var objVideoCollection: UICollectionView!
    @IBOutlet weak var con_VideoHeight: NSLayoutConstraint!
    @IBOutlet weak var con_TitleVideoHeight: NSLayoutConstraint!
    @IBOutlet weak var lblAllVideo: UILabel!
    @IBOutlet weak var viewAllVideo: UIView!

    //ALL MUSIC
    @IBOutlet weak var objMusicCollection: UICollectionView!
    @IBOutlet weak var con_MusicHeight: NSLayoutConstraint!
    @IBOutlet weak var con_TitleMusicHeight: NSLayoutConstraint!
    @IBOutlet weak var lblAllMusic: UILabel!
    @IBOutlet weak var viewAllMusic: UIView!


    //OTHER VARIABLE
    var arrHomeBanner : [HomeBannerModel] = []
    var arrAllVideo : [AllVideoModel] = []
    var arrAllMusic : [AllMusicModel] = []

    //LOADING
    var isLoading : Bool = false
    var objRefresh : UIRefreshControl?

    //TIMER
    var timerBanner : Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.tabBarController?.tabBar.isHidden = true

        //SET NAVIGATION BAR
        setButtonNavigationBarFor(controller: self, title: "sdf", isTransperent: false, hideShadowImage: true, leftIcon: "icon_menu", rightIcon: "") {SelectTag in
            
            self.slideMenuController()?.toggleLeft()

            
        } rightActionHandler: {SelectTag in
            
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
        self.getBannerAPI()
    }

    @objc func scrollBanner(){
        self.scrollAutomatically(objCollectionView: self.objBannerCollection)
    }
    
    
    
    //SET THE VIEW
    func setTheView() {

        //SET FONT
        self.lblAllVideo.configureLable(textColor: .primary, fontName: GlobalConstants.APP_FONT_Bold, fontSize: 16.0, text: str.strAllVideo)
        self.lblAllMusic.configureLable(textColor: .primary, fontName: GlobalConstants.APP_FONT_Bold, fontSize: 16.0, text: str.strAllMusic)

        //SET COLLECTION HEIGHT
        self.con_BannerHeight.constant = self.arrHomeBanner.count == 0 ? 0 : manageWidth(size: 221)
        self.con_VideoHeight.constant = self.arrAllVideo.count == 0 ? 0 : manageWidth(size: 221)
        self.con_MusicHeight.constant = self.arrAllMusic.count == 0 ? 0 : manageWidth(size: 221)

        //SET VIEW
        self.con_TitleVideoHeight.constant = self.arrAllVideo.count == 0 ? 0 : manageWidth(size: 50)
        self.con_TitleMusicHeight.constant = self.arrAllMusic.count == 0 ? 0 : manageWidth(size: 50)
 
        self.viewAllVideo.isHidden = self.arrAllVideo.count == 0 ? true : false
        self.viewAllMusic.isHidden = self.arrAllMusic.count == 0 ? true : false
        
        //SET HEADER
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            //SET TABLE HEADER
            let vw_Table = self.tblView.tableHeaderView
            vw_Table?.frame = CGRect(x: 0, y: 0, width: self.tblView.frame.size.width, height: self.objMusicCollection.frame.origin.y + self.objMusicCollection.frame.size.height + 20)
            self.tblView.tableHeaderView = vw_Table
        }
        

        
    }
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




 
//MARK: -- COLLECTION CELL --

class BannerCell: UICollectionViewCell {
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var con_ImgHeight: NSLayoutConstraint!

    @IBOutlet weak var viewTitle: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnClicked: UIButton!
}

class MusicCell: UICollectionViewCell {
    @IBOutlet weak var imgTop: UIImageView!
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var con_ImgHeight: NSLayoutConstraint!
    @IBOutlet weak var con_TopImgHeight: NSLayoutConstraint!

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
}

//MARK: - Collection View -
extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    //    func scrollViewDidScroll(_ scroll: UIScrollView) {
    //        if scroll == self.objBannerCollection{
    //            for cell in self.objBannerCollection.visibleCells {
    //                let indexPath: IndexPath = self.objBannerCollection.indexPath(for: cell)!
    //
    //                var objData = self.arrHomeBanner[indexPath.row ]
    //
    //                //CHECK CELL TYPE
    //                if objData.image?.isImageType() == true{
    //
    //                    //PLAY VIDEO
    //                    if objData.image != ""{
    //                        if objData.isVideoLoad == false{
    //
    //
    //                            //UPDATE DATA
    //                            objData.isVideoLoad = true
    //                            self.arrHomeBanner.remove(at: indexPath.row )
    //                            self.arrHomeBanner.insert(objData, at: indexPath.row )
    //
    //                            //PLAY VIEW
    //                            DispatchQueue.main.async {
    //                                let cellVideo  = self.objBannerCollection.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
    //
    //                                cellVideo.playVideo()
    //                            }
    //                        }
    //
    //                    }
    //                }
    //
    //            }
    //        }
    //    }
    
    func scrollAutomatically(objCollectionView : UICollectionView) {
        
        //        for cell in objCollectionView.visibleCells {
        //            let indexPath: IndexPath? = objCollectionView.indexPath(for: cell)
        //            if ((indexPath?.row)! < self.arrHomeBanner.count){
        //                let indexPath1: IndexPath?
        //                indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
        //
        //                objCollectionView.scrollToItem(at: indexPath1!, at: .right, animated: true)
        //
        //            }
        //            else{
        //                let indexPath1: IndexPath?
        //                indexPath1 = IndexPath.init(row: 0, section: (indexPath?.section)!)
        //                objCollectionView.scrollToItem(at: indexPath1!, at: .left, animated: true)
        //            }
        //        }
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.objBannerCollection{
            return self.arrHomeBanner.count
        }
        else if collectionView == self.objVideoCollection{
            if self.arrAllVideo.count != 0{
                if self.arrAllVideo.count <= 5{
                    return self.arrAllVideo.count
                }
                else{
                    return 5
                }
            }
            else{
                return 0
            }
        }
        else if collectionView == self.objMusicCollection{
            if self.arrAllMusic.count != 0{
                if self.arrAllMusic.count <= 5{
                    return self.arrAllMusic.count
                }
                else{
                    return 5
                }
            }
            else{
                return 0
            }
        }
        else{
            return 0
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width , height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.objBannerCollection{
            let objData = self.arrHomeBanner[indexPath.row]
            
            //CHECK CELL TYPE
            if objData.image?.isImageType() == true{
                //BANNER
                let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
                cell.backgroundColor = UIColor.clear
                DispatchQueue.main.async {
                    cell.con_ImgHeight.constant = collectionView.frame.size.width
                }
                
                //SET DATA
                if self.arrHomeBanner.count == 0{
                    return cell
                }
                
                //SET DETAILS
                let obj = self.arrHomeBanner[indexPath.row]
                cell.imgBanner.backgroundColor = UIColor.clear
                
                //SET IMAGE
                DispatchQueue.main.async {
                    if let strImg = obj.image{
                        let imgURL =  ("\(strImg)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) ?? ""
                        if let url = URL(string: imgURL.replacingOccurrences(of: " ", with: "%20")){
                            Nuke.loadImage(with: url, options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)), into: cell.imgBanner)
                        }
                    }
                }
                
                //SET BUTTON VIEW
                cell.viewTitle.isHidden = true
                if let strTitle = obj.button{
                    cell.viewTitle.isHidden = false
                    cell.viewTitle.viewCorneRadius(radius: 0, isRound: true)
                    cell.viewTitle.backgroundColor = .red_main
                    
                    //SET TITLE
                    cell.lblTitle.configureLable(textColor: .primary, fontName: GlobalConstants.APP_FONT_Bold, fontSize: 16.0, text: strTitle)
                    
                    //BUTTON CLICKED
                    cell.btnClicked.tag = indexPath.row
                    cell.btnClicked.addTarget(self, action: #selector(self.btnBannerClicked(_:)), for: .touchUpInside)

                    
                }
                
                return cell
            }
            else{
                //BANNER
                let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCell", for: indexPath) as! VideoCell
                cell.backgroundColor = UIColor.clear
                DispatchQueue.main.async {
                    cell.con_ImgHeight.constant = collectionView.frame.size.width
                }
                
                //SET DATA
                if self.arrHomeBanner.count == 0{
                    return cell
                }
                
                //SET DETAILS
                var obj = self.arrHomeBanner[indexPath.row]
                
                
                //SET VIDEO
                if obj.image != ""{
                    if obj.isVideoLoad == false{
                        
                        //SET IMAGE
                        DispatchQueue.main.async {
                            if obj.thumbnailImage != nil{
                                //                            cell.imgBanner.image = obj.thumbnailImage
                                
                            }
                            //                        if let thumbnailImage = getThumbnailImage(forUrl: URL(string: obj.image ?? "")!) {
                            //                            cell.imgBanner.image = thumbnailImage
                            //                        }
                        }
                        
                        //UPDATE DATA
                        obj.isVideoLoad = true
                        self.arrHomeBanner.remove(at: indexPath.row)
                        self.arrHomeBanner.insert(obj, at: indexPath.row)
                        
                        //PLAY VIEW
                        DispatchQueue.main.async {
                            cell.playVideo(strUrl: obj.image ?? "")
                        }
                    }
                    
                }
                
                return cell
            }
        }
        else if collectionView == self.objVideoCollection{

            
            //BANNER
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
            cell.backgroundColor = UIColor.clear
            DispatchQueue.main.async {
                cell.con_ImgHeight.constant = collectionView.frame.size.width
            }
            
            //SET DATA
            if self.arrAllVideo.count == 0{
                return cell
            }
            
            //SET DETAILS
            let obj = self.arrAllVideo[indexPath.row]
            cell.imgBanner.backgroundColor = UIColor.clear
            cell.lblTitle.configureLable(textColor: .secondary, fontName: GlobalConstants.APP_FONT_Medium, fontSize: 16.0, text: obj.title ?? "")
            cell.lblTitle.textAlignment = .center

            //SET IMAGE
            DispatchQueue.main.async {
                if let strImg = obj.screenshot{
                    let imgURL =  ("\(strImg)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) ?? ""
                    if let url = URL(string: imgURL.replacingOccurrences(of: " ", with: "%20")){
                        Nuke.loadImage(with: url, options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)), into: cell.imgBanner)
                    }
                }
                
                
                //SET GIF
                if let url = URL.init(string: obj.image ?? "") {
                    cell.imgBanner.setGifFromURL(url, customLoader: nil)
                }
            }
            
            return cell
        }
        else if collectionView == self.objMusicCollection{

            
            //BANNER
            let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "MusicCell", for: indexPath) as! MusicCell
            cell.backgroundColor = UIColor.clear
            DispatchQueue.main.async {
                cell.con_ImgHeight.constant = collectionView.frame.size.width
                cell.con_TopImgHeight.constant = collectionView.frame.size.height
            }
            
            //SET DATA
            if self.arrAllMusic.count == 0{
                return cell
            }
            
            //SET DETAILS
            let obj = self.arrAllMusic[indexPath.row]
            cell.imgBanner.backgroundColor = UIColor.clear
            cell.lblTitle.configureLable(textColor: .primary, fontName: GlobalConstants.APP_FONT_Medium, fontSize: 18.0, text: obj.title ?? "")
            cell.lblTitle.textAlignment = .left
            cell.lblDuration.configureLable(textColor: .primary, fontName: GlobalConstants.APP_FONT_Medium, fontSize: 16.0, text: obj.duration ?? "")
            cell.lblDuration.textAlignment = .left

            
            //SET IMAGE
            DispatchQueue.main.async {
                if let strImg = obj.image{
                    let imgURL =  ("\(Application.imgURL)\(strImg)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) ?? ""
                    if let url = URL(string: imgURL.replacingOccurrences(of: " ", with: "%20")){
                        Nuke.loadImage(with: url, options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)), into: cell.imgBanner)
                        Nuke.loadImage(with: url, options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)), into: cell.imgTop)
                    }
                }
                
                
                //SET GIF
                if let url = URL.init(string: obj.image ?? "") {
                    cell.imgBanner.setGifFromURL(url, customLoader: nil)
                }
            }
            
            return cell
        }

        return UICollectionViewCell()
    }

    
    //BUTTON CLICKED EVENT
    @objc func btnBannerClicked(_ sender: UIButton) {
        let obj = self.arrHomeBanner[sender.tag]
        if let strUrl = obj.url{
            openURL(strURL: strUrl)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         if collectionView == self.objMusicCollection{
             //REMOVE PLAYER
             playerVideo = nil
             playerVideo?.pause()
             playerTimer?.invalidate()
             
             let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
             window?.endEditing(true)
             musicView.commonInit(objData: self.arrAllMusic[indexPath.row])
             if isMusicViewOpen == false {
                 window?.addSubview(musicView)
             }
        }
    }
}



extension String {
    public func isImageType() -> Bool {
        // image formats which you want to check
        let imageFormats = ["jpg", "png", "gif"]

        if URL(string: self) != nil  {

            let extensi = (self as NSString).pathExtension

            return imageFormats.contains(extensi)
        }
        return false
    }
}

func getThumbnailImage(forUrl url: URL) -> UIImage? {
    let asset: AVAsset = AVAsset(url: url)
    let imageGenerator = AVAssetImageGenerator(asset: asset)

    do {
        let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 1, timescale: 60), actualTime: nil)
        return UIImage(cgImage: thumbnailImage)
    } catch let error {
        print(error)
    }

    return nil
}
