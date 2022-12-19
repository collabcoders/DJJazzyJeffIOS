//
//  MusicTabView.swift
//  DJJazzyJeff
//
//  Created by Jigar Khatri on 29/11/22.
//

import UIKit
import Nuke
import AVFAudio
import AVKit
import MediaPlayer

class MusicTabView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var con_ViewHeight: NSLayoutConstraint!

    //DETAILS
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!

    @IBOutlet weak var imgMusic: UIImageView!
    @IBOutlet weak var objSlider: UISlider!
    @IBOutlet weak var objLoading: UIActivityIndicatorView!

    @IBOutlet weak var btnPlayPush: UIButton!

    @IBOutlet weak var imgLike: UIImageView!

    //PLAYER
    var isSlideMusic : Bool = false
    var strPlayMusicID : Int = 0
    var strFavID : Int = 0
    var isisFavorite : Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    public func commonInit(objData : AllMusicModel, isFavorite : Bool) {
        
        backgroundColor = .clear
        clipsToBounds = true
        
        Bundle.main.loadNibNamed("MusicTabView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        contentView.backgroundColor = .black
        
        //SET THE VIEW
        self.isisFavorite = isFavorite
        self.imgLike.image = UIImage(named: isFavorite ? "icon_Like" : "icon_UnLike")
        self.strPlayMusicID = objData.musicId ?? 0
        self.strFavID = objData.favId
        self.setTheView()
        self.setTheViewFrame(objData: objData, isFavorite: isFavorite)
    }
 
    
    func setTheView(){
        self.con_ViewHeight.constant = manageWidth(size:  220)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(removeMusicView))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.viewMain.addGestureRecognizer(swipeDown)
    }
 

    func setTheViewFrame(objData : AllMusicModel, isFavorite : Bool){
        //SET VIEW
        self.setTheMusicTab(objData: objData, isFavorite: isFavorite)
        
        //SET ANIMATION
        if isMusicViewOpen == false {
 
            main_thread {
                var frameTemp = self.frame
                frameTemp.origin.y = GlobalConstants.windowHeight
                self.frame = frameTemp
                
                self.layoutIfNeeded()
                self.layoutSubviews()
                self.superview?.layoutIfNeeded()
                
                main_thread {
                    self.setViewAnimation()
                }
            }
        }
    }


    func setViewAnimation(){
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: [],
                       animations: { () -> Void in
            var frameTemp = self.frame
            frameTemp.origin.y = frameTemp.origin.y - self.viewMain.frame.size.height
            self.frame = frameTemp
            
            self.layoutIfNeeded()
            self.layoutSubviews()
            self.superview?.layoutIfNeeded()

            
        }, completion: { (finished) -> Void in
            // ....
            isMusicViewOpen = true
            NotificationCenter.default.post(name: .plsyMusic, object: nil, userInfo: nil)

        })
    }
    
    
    @objc func  removeMusicView(){
//        if isMusicPlay == false{
//            return
//        }
        
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [],
                       animations: { () -> Void in
            var frameTemp = self.frame
            frameTemp.origin.y = GlobalConstants.windowHeight
            self.frame = frameTemp

            print(frameTemp)
            self.layoutIfNeeded()
            self.layoutSubviews()
            self.superview?.layoutIfNeeded()
            
        }, completion: { (finished) -> Void in
            // ....
            playerVideo?.pause()
            playerVideo = nil
            self.removeFromSuperview()
            isMusicViewOpen = false
            NotificationCenter.default.post(name: .plsyMusic, object: nil, userInfo: nil)

        })
    }
    
    func setTheMusicTab(objData : AllMusicModel, isFavorite : Bool){

        //SET FONT
        self.lblTime.configureLable(textColor: .primary, fontName: GlobalConstants.APP_FONT_Bold, fontSize: 12.0, text: "-\(objData.duration ?? "")")
        self.lblTitle.configureLable(textColor: .primary, fontName: GlobalConstants.APP_FONT_Bold, fontSize: 14.0, text: "DJ Jazzy Jeff")
        self.lblTitle.textAlignment = .center
        self.lblName.configureLable(textColor: .primary, fontName: GlobalConstants.APP_FONT_Medium, fontSize: 14.0, text: objData.title ?? "")
        self.lblName.textAlignment = .center
        
        //SET SLIDER
        self.objSlider.setValue(0, animated: true)
        self.objSlider.minimumTrackTintColor = UIColor.primary
        self.setLoader(isLoading: true)
        self.btnPlayPush.setBackgroundImage(UIImage(named: "icon_play"), for: .normal)

        //SET BUTTON CLICKED
        self.objSlider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)


        //SET MUSIC
        delay(1.0) {
            if isFavorite{
                if let strMusic = objData.file{
                    let strUrl =  ("\(strMusic)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) ?? ""
                    if let url = URL(string: strUrl.replacingOccurrences(of: " ", with: "%20")){
                        self.playVideo(url: url, strTitle: objData.title ?? "")
                    }
                }
            }
            else{
                if let strMusic = objData.file{
                    let strUrl =  ("\(Application.imgURL)\(strMusic)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) ?? ""
                    if let url = URL(string: strUrl.replacingOccurrences(of: " ", with: "%20")){
                        self.playVideo(url: url, strTitle: objData.title ?? "")
                    }
                }
            }
           
        }
        
        
        
        //SET IMAGE
        DispatchQueue.main.async {
            if let strImg = objData.image{
                let imgURL =  ("\(Application.imgURL)\(strImg)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) ?? ""
                if let url = URL(string: imgURL.replacingOccurrences(of: " ", with: "%20")){
                    Nuke.loadImage(with: url, options: ImageLoadingOptions(transition: .fadeIn(duration: 0.33)), into: self.imgMusic)
                }
            }
        }
    }
    
    @IBAction func btnRemovePopupClicked(sender : UIButton) {
        self.removeMusicView()
    }
    
    @IBAction func btnPlayPushClicked(sender : UIButton) {
        if isMusicPlay == false{
            playerVideo?.pause()
            isMusicPlay = true
            self.btnPlayPush.setBackgroundImage(UIImage(named: "icon_play"), for: .normal)
        }
        else{
            playerVideo?.play()
            isMusicPlay = false
            self.btnPlayPush.setBackgroundImage( UIImage(named: "icon_push"), for: .normal)
        }
    }
    
    @IBAction func btnNextClciked(sender: UIButton){
        //SET SEEKP TIME
        let maxDuration = CMTimeGetSeconds((playerVideo?.currentItem?.asset.duration)!)
        let currentTime:Double = playerVideo?.currentItem?.currentTime().seconds ?? 0

        if maxDuration - 30 > currentTime + 30{
            seekToSec(Float64(currentTime + 30))
        }
    }
    
    @IBAction func btnPreviousClicked(sender: UIButton){
        //SET SEEKP TIME
        let currentTime:Double = playerVideo?.currentItem?.currentTime().seconds ?? 0

        if 30 < currentTime - 30{
            seekToSec(Float64(currentTime - 30))
        }
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .began:
                // handle drag began
                if objLoading.isHidden == true{
                    self.isSlideMusic = true
                }
                
            case .moved:
                // handle drag moved
                if objLoading.isHidden == true{
                    self.isSlideMusic = true
                }
            case .ended:
                
                // handle drag ended
                if objLoading.isHidden == true{
                    self.isSlideMusic = false
                    setLoader(isLoading: true)
                    playerVideo?.pause()
                    
                    //GET SEEKP TIME
                    let maxDuration = CMTimeGetSeconds((playerVideo?.currentItem?.asset.duration)!)
                    let seekpValue = Float(maxDuration) * slider.value
                    seekToSec(Float64(seekpValue))

                }
                
            default:
                break
            }
        }
    }
    
    @IBAction func btnFavoriteClicked(sender : UIButton) {
        if let objUser = UserDefaults.standard.user{
            if objUser.plan?.lowercased() == "free"{
                showAlertMessage(strMessage: str.strFavoriteAlert)
            }
            else{
                //CALL API
                self.updateFavoriteMusic(FavoritesParameater: FavoritesParameater(favId: self.strFavID, itemId: self.strPlayMusicID, section: "music"))
            }
        }
    }
    
    func setLoader(isLoading : Bool){
        //SET LOADER
        self.btnPlayPush.isHidden = isLoading
        self.objLoading.isHidden = !isLoading
        if isLoading{
            objLoading.startAnimating()
        }
        else{
            objLoading.stopAnimating()
        }
        
    }
    
    func playVideo(url: URL, strTitle : String) {
        self.setLoader(isLoading: true)
        self.btnPlayPush.setBackgroundImage(UIImage(named: "icon_play"), for: .normal)

        playerItem = nil
        playerItem = AVPlayerItem(url: url)
        playerVideo = nil
        playerVideo = AVPlayer(playerItem: playerItem)
        playerVideo?.play()
        
        //SET NOTIFICAITON
        playerVideo?.addObserver(self, forKeyPath: "status", options: [.old, .new], context: nil)
        if #available(iOS 10.0, *) {
            playerVideo?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        } else {
            playerVideo?.addObserver(self, forKeyPath: "rate", options: [.old, .new], context: nil)
        }
    }

  
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if object as AnyObject? === playerVideo {
            if keyPath == "status" {
                if playerVideo?.status == .readyToPlay {
                    self.btnPlayPush.setBackgroundImage( UIImage(named: "icon_push"), for: .normal)

                    playerTimer?.invalidate()
                    playerTimer = nil
                    //GET CURRENT TIME
                    playerTimer = Timer.scheduledTimer(timeInterval: 0.1, target:self , selector: #selector(currntPlayTiming), userInfo: nil, repeats: true)
                    setupNowPlaying(strTitle: "asd")
                    setupRemoteCommandCenter()
                }
            }
        }
    }
    

    
    @objc func currntPlayTiming() {
        // Start PLAYING
        guard let playerVideo = playerVideo else {
            return
        }
        
      
        //SET LOADING
        self.setLoader(isLoading: false)

        //SET TIME
        
        let currentTime = CMTimeGetSeconds((playerVideo.currentTime()))
        let maxDuration = CMTimeGetSeconds((playerVideo.currentItem?.asset.duration)!)
        
        if isSlideMusic == false{
            objSlider.setValue(Float(currentTime/maxDuration), animated: true)
        }
        
        if maxDuration > currentTime {
            self.lblTime.text = "-\(secondsToHoursMinutesSeconds(seconds: Int(maxDuration - currentTime)))"
        } else {
            //STOP PLAYER
            playerVideo.pause()
            removeMusicView()
        }
    }
    
    func seekToSec(_ seconds: Float64) {
        let timeScale = playerVideo?.currentItem?.asset.duration.timescale
        let time = CMTimeMakeWithSeconds(seconds, preferredTimescale: timeScale!)
        playerVideo?.seek(to: time, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        
        playerVideo?.play()
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> String {
        if seconds / 3600 == 0 {
            return String(format: "%02d:%02d", (seconds % 3600) / 60, (seconds % 3600) % 60)
        }
        return String(format: "%02d:%02d:%02d", seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    //SET MUSIC IN LOCAK SCREEN
    func setupNowPlaying(strTitle : String) {
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = strTitle

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playerItem.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = playerItem.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = playerVideo?.rate

        // Set the metadata
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        if #available(iOS 13.0, *) {
            MPNowPlayingInfoCenter.default().playbackState = .playing
        } else {
            // Fallback on earlier versions
        }
    }
    
    func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared();
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget {event in
            playerVideo?.play()
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget {event in
            playerVideo?.pause()
            return .success
        }
        
    }
}
