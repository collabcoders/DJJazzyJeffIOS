//
//  VersaPlayer.swift
//  VersaPlayer Demo
//
//  Created by Jose Quintero on 10/11/18.
//  Copyright © 2018 Quasar. All rights reserved.
//

import AVFoundation

open class VersaPlayer: AVPlayer, AVAssetResourceLoaderDelegate {
    
    /// Dispatch queue for resource loader
    private let queue = DispatchQueue(label: "quasar.studio.versaplayer")
    
    /// Notification key to extract info
    public enum VPlayerNotificationInfoKey: String {
        case time = "VERSA_PLAYER_TIME"
    }
    
    /// Notification name to post
    public enum VPlayerNotificationName: String {
        case assetLoaded = "VERSA_ASSET_ADDED"
        case timeChanged = "VERSA_TIME_CHANGED"
        case willPlay = "VERSA_PLAYER_STATE_WILL_PLAY"
        case play = "VERSA_PLAYER_STATE_PLAY"
        case pause = "VERSA_PLAYER_STATE_PAUSE"
        case buffering = "VERSA_PLAYER_BUFFERING"
        case endBuffering = "VERSA_PLAYER_END_BUFFERING"
        case didEnd = "VERSA_PLAYER_END_PLAYING"
        
        /// Notification name representation
        public var notification: NSNotification.Name {
            return NSNotification.Name.init(self.rawValue)
        }
    }
    
    /// VersaPlayer instance
    public weak var handler: VersaPlayerView!
    
    public weak var videoPlayer: AVPlayerItem!

    public var viewQulity: Double = 0
    public var videoCurrentTime : Double = 0.0
    
    //DRM DATA
    public var URL_SCHEME_NAME = "skd"
    public var AX_DRM_MESSAGE = "X-AxDRM-Message"
    public var AX_DRM_LICENSE_URL = "drm_license_url"
    public var FPS_CER_URL = "fps_certificate_url"
    
    typealias AppCertificateRequestCompletion = (Data?) -> Void
    typealias ContentKeyAndLeaseExpiryRequestCompletion = (Data?, Error?) -> Void
    
    /// Caption text style rules
    lazy public var captionStyling: VersaPlayerCaptionStyling = {
        return VersaPlayerCaptionStyling(with: self)
    }()
    
    /// Whether player is buffering
    public var isBuffering: Bool = false
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: AVPlayerItem.timeJumpedNotification, object: self)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self)
        removeObserver(self, forKeyPath: "status")
    }
    
    /// Play content
    override open func play() {
        handler.playbackDelegate?.playbackWillBegin(player: self)
        NotificationCenter.default.post(name: VersaPlayer.VPlayerNotificationName.willPlay.notification, object: self, userInfo: nil)
        if !(handler.playbackDelegate?.playbackShouldBegin(player: self) ?? true) {
            return
        }
        NotificationCenter.default.post(name: VersaPlayer.VPlayerNotificationName.play.notification, object: self, userInfo: nil)
        super.play()
        handler.playbackDelegate?.playbackDidBegin(player: self)
    }
    
    /// Pause content
    override open func pause() {
        handler.playbackDelegate?.playbackWillPause(player: self)
        NotificationCenter.default.post(name: VersaPlayer.VPlayerNotificationName.pause.notification, object: self, userInfo: nil)
        super.pause()
        handler.playbackDelegate?.playbackDidPause(player: self)
    }
    
    /// Replace current item with a new one
    ///
    /// - Parameters:
    ///     - item: AVPlayer item instance to be added
    open override func replaceCurrentItem(with item: AVPlayerItem?) {
        item?.preferredPeakBitRate = viewQulity
        
        videoPlayer = item
        if let asset = videoPlayer?.asset as? AVURLAsset, let vitem = videoPlayer as? VersaPlayerItem, vitem.isEncrypted {
            asset.resourceLoader.setDelegate(self, queue: queue)
        }
        
        if currentItem != nil {
            currentItem!.removeObserver(self, forKeyPath: "playbackBufferEmpty")
            currentItem!.removeObserver(self, forKeyPath: "playbackLikelyToKeepUp")
            currentItem!.removeObserver(self, forKeyPath: "playbackBufferFull")
            currentItem!.removeObserver(self, forKeyPath: "status")
        }
        
        super.replaceCurrentItem(with: videoPlayer)
        NotificationCenter.default.post(name: VersaPlayer.VPlayerNotificationName.assetLoaded.notification, object: self, userInfo: nil)
        if let newItem = currentItem ?? videoPlayer {
            newItem.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
            newItem.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
            newItem.addObserver(self, forKeyPath: "playbackBufferFull", options: .new, context: nil)
            newItem.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        }
    }
    
}

extension VersaPlayer {
    
    /// Start time
    ///
    /// - Returns: Player's current item start time as CMTime
    public func startTime() -> CMTime {
        guard let item = currentItem else {
            return CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        }
        
        if item.reversePlaybackEndTime.isValid {
            return item.reversePlaybackEndTime
        }else {
            return CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        }
    }
    
    /// End time
    ///
    /// - Returns: Player's current item end time as CMTime
    public func endTime() -> CMTime {
        guard let item = currentItem else {
            return CMTime(seconds: 0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        }
        
        if item.forwardPlaybackEndTime.isValid {
            return item.forwardPlaybackEndTime
        }else {
            if item.duration.isValid && !item.duration.isIndefinite {
                return item.duration
            }else {
                return item.currentTime()
            }
        }
    }

    /// Prepare players playback delegate observers
    public func preparePlayerPlaybackDelegate() {
      NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
        guard let self = self else { return }
        NotificationCenter.default.post(name: VersaPlayer.VPlayerNotificationName.didEnd.notification, object: self, userInfo: nil)
        self.handler?.playbackDelegate?.playbackDidEnd(player: self)
      }
        NotificationCenter.default.addObserver(forName: AVPlayerItem.timeJumpedNotification, object: self, queue: OperationQueue.main) { [weak self] (notification) in
        guard let self = self else { return }
        self.handler?.playbackDelegate?.playbackDidJump(player: self)
      }
        
        
      addPeriodicTimeObserver(
        forInterval: CMTime(
          seconds: 1,
          preferredTimescale: CMTimeScale(NSEC_PER_SEC)
        ),
        queue: DispatchQueue.main) { [weak self] (time) in
          guard let self = self else { return }
        
        let currentTime : Double = time.seconds
//        if self.videoCurrentTime != 0.0{
//            currentTime = self.videoCurrentTime
//        }
        
        NotificationCenter.default.post(name: VersaPlayer.VPlayerNotificationName.timeChanged.notification, object: self, userInfo: [VPlayerNotificationInfoKey.time.rawValue: currentTime])
        self.handler?.playbackDelegate?.timeDidChange(player: self, to: currentTime)
      }

      addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    /// Value observer
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let obj = object as? VersaPlayer, obj == self {
            if keyPath == "status" && handler != nil {
                switch status {
                case AVPlayer.Status.readyToPlay:
                    handler.playbackDelegate?.playbackReady(player: self)
                case AVPlayer.Status.failed:
                    handler.playbackDelegate?.playbackDidFailed(with: VersaPlayerPlaybackError.unknown)
                default:
                    break;
                }
            }
        }else {
            switch keyPath ?? "" {
            case "status":
                if let value = change?[.newKey] as? Int, let status = AVPlayerItem.Status(rawValue: value), let item = object as? AVPlayerItem {
                    if status == .failed, let error = item.error as NSError?, let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? NSError {
                        let playbackError: VersaPlayerPlaybackError
                        switch underlyingError.code {
                        case -12937:
                            playbackError = .authenticationError
                        case -16840:
                            playbackError = .unauthorized
                        case -12660:
                            playbackError = .forbidden
                        case -12938:
                            playbackError = .notFound
                        case -12661:
                            playbackError = .unavailable
                        case -12645, -12889:
                            playbackError = .mediaFileError
                        case -12318:
                            playbackError = .bandwidthExceeded
                        case -12642:
                            playbackError = .playlistUnchanged
                        case -12911:
                            playbackError = .decoderMalfunction
                        case -12913:
                            playbackError = .decoderTemporarilyUnavailable
                        case -1004:
                            playbackError = .wrongHostIP
                        case -1003:
                            playbackError = .wrongHostDNS
                        case -1000:
                            playbackError = .badURL
                        case -1202:
                            playbackError = .invalidRequest
                        default:
                            playbackError = .unknown
                        }
                        
                        DispatchQueue.main.async {
                            if self.handler != nil{
                                self.handler.playbackDelegate?.playbackDidFailed(with: playbackError)
                            }
                        }
                    }

                    if status == .readyToPlay, let currentItem = self.currentItem as? VersaPlayerItem {
                        DispatchQueue.main.async {
                            if self.handler != nil{
                                self.handler.playbackDelegate?.playbackItemReady(player: self, item: currentItem)
                            }
                        }
                    }
                }
            case "playbackBufferEmpty":
                isBuffering = true
                NotificationCenter.default.post(name: VersaPlayer.VPlayerNotificationName.buffering.notification, object: self, userInfo: nil)
                DispatchQueue.main.async {
                    if self.handler != nil{
                        self.handler.playbackDelegate?.startBuffering(player: self)
                    }
                }
            case "playbackLikelyToKeepUp":
                isBuffering = false
                NotificationCenter.default.post(name: VersaPlayer.VPlayerNotificationName.endBuffering.notification, object: self, userInfo: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    if self.handler != nil{
                        self.handler.playbackDelegate?.endBuffering(player: self)
                    }
                })
                
            case "playbackBufferFull":
                isBuffering = false
                NotificationCenter.default.post(name: VersaPlayer.VPlayerNotificationName.endBuffering.notification, object: self, userInfo: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    if self.handler != nil{
                        self.handler.playbackDelegate?.endBuffering(player: self)
                    }
                })
                
            default:
                break;
            }
        }
    }
    
    public func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForRenewalOfRequestedResource renewalRequest: AVAssetResourceRenewalRequest) -> Bool {
        return self.resourceLoader(resourceLoader, shouldWaitForLoadingOfRequestedResource: renewalRequest)
    }
    
    
    func requestApplicationCertificate() -> Data {
//        let configuration = URLSessionConfiguration.default
//        let session = URLSession(configuration: configuration)
//        let urlString = UserDefaults.standard.object(forKey: FPS_CER_URL) as? String
//        let url = URL(string: urlString ?? "")!
//
//
//        let requestTask = session.dataTask(with: url) { data, response, error in
//            completionHandler(data)
//        }
//        requestTask.resume()
//
        
        var certificate: Data? = nil
        let cert = URL(string: FPS_CER_URL)

        do {
            certificate = try Data(contentsOf: cert! as URL)
        } catch {
            print("Unable to load data: \(error)")
        }

        
        if certificate == nil{
            return Data()
        }
        return certificate!

//        if let cert = cert {
//            certificate = try Data(contentsOf: cert)
//        }
//
//        if certificate == nil {
//            return nil
//        }
//
//        return certificate
    }
    
    
    func requestContentKeyAndLeaseExpiryfromKeyServerModule(withRequestBytes requestBytes: Data?, withCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) {
        if AX_DRM_LICENSE_URL == ""{
            return
        }
        
        // Implements communications with the Axinom DRM license server.
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
//        let urlString = UserDefaults.standard.object(forKey: AX_DRM_LICENSE_URL) as? String
        let url = URL(string: AX_DRM_LICENSE_URL)!
        let ksmRequest = NSMutableURLRequest(url: url)
        ksmRequest.httpMethod = "POST"
        ksmRequest.httpBody = requestBytes
        ksmRequest.setValue("application/octet-stream", forHTTPHeaderField: "Content-type")

        let requestTask = session.dataTask(with: ksmRequest as URLRequest) { data, response, error in
            completionHandler(data, error)
        }
        requestTask.resume()
        
    }
    

    
    public func resourceLoader(_ resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        if AX_DRM_LICENSE_URL == ""{
            return false
        }
        
        let url = loadingRequest.request.url
        if url?.scheme != URL_SCHEME_NAME {
            return false
        }
        
        let dataRequest = loadingRequest.dataRequest
        let certificate = requestApplicationCertificate()
        
        let assetStr : String = url?.absoluteString.replacingOccurrences(of: "skd://", with: "") ?? ""
        let cstr = assetStr.cString(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        let assetId = Data(bytes: cstr!, count: assetStr.lengthOfBytes(using: .utf8))
        
        print(assetId)
        
        var requestBytes: Data? = nil
        do {
            requestBytes = try loadingRequest.streamingContentKeyRequestData(
                forApp: certificate,
                contentIdentifier: assetId,
                options: nil)
            
            self.requestContentKeyAndLeaseExpiryfromKeyServerModule(withRequestBytes: requestBytes) { response, error in
                if (response != nil) {
                    dataRequest?.respond(with: response!)
                    
                    loadingRequest.contentInformationRequest?.contentType = AVStreamingKeyDeliveryContentKeyType
                    loadingRequest.finishLoading()
                }
                else{
                    loadingRequest.finishLoading(with: error)
                }
            }
        } catch {
        }
        
        
        
        return true
    }
    
}
