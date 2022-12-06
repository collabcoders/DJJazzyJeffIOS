//
//  VideoCell.swift
//  DJJazzyJeff
//
//  Created by Jigar Khatri on 26/11/22.
//

import UIKit
import AVFoundation

class VideoCell: UICollectionViewCell {
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var con_ImgHeight: NSLayoutConstraint!

    var playerView: PlayerView = {
        var player = PlayerView()
        player.backgroundColor = .clear
        return player
    }()
    
    var videoPlayer: AVPlayer? = nil
    
    override func awakeFromNib() {
       super.awakeFromNib()
       //custom logic goes here
        
        addSubview(playerView)
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        playerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        playerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

    }
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(playerView)
//        playerView.translatesAutoresizingMaskIntoConstraints = false
//        playerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        playerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        playerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        playerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//    }
    
  
    func playVideo(strUrl : String) {

        videoPlayer = AVPlayer(url: URL(string: strUrl)!)
        playerView.player = videoPlayer
        playerView.player?.volume = 0
        playerView.playerLayer.videoGravity = .resizeAspectFill
        playerView.player?.play()
    }
    
    func playVideo() {
        playerView.player?.play()
    }
    
    func stopVideo() {
        playerView.player?.pause()
    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
}


class PlayerView: UIView {

    override static var layerClass: AnyClass {
        return AVPlayerLayer.self
    }

    var playerLayer: AVPlayerLayer {
    
        return layer as! AVPlayerLayer
    }

    var player: AVPlayer? {
        get {
            return playerLayer.player
        }
    
        set {
            playerLayer.player = newValue
        }
    }
}
