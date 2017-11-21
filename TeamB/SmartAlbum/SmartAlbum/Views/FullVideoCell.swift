//
//  FullVideoCell.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 21..
//  Copyright © 2017년 team-b. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

// Refer below site:
// http://fusionsoftwareconsulting.co.uk/2017/05/03/swift-3-embed-a-video-in-uitableviewcell/

class FullVideoCell: UICollectionViewCell {
    
    // MARK:- Properties
    
    var avPlayer: AVPlayer?
    var videoAsset: AVAsset?
    var avPlayerViewConroller: AVPlayerViewController?
    var avPlayerLayer: AVPlayerLayer?
    var videoItemUrl: URL? {
        didSet {
            initNewPlayerItem()
        }
    }
    
    // MARK:- Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMoviePlayer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK:- Setup Player Function
    
    private func setupMoviePlayer() {
        // Create a new AVPlayer and AVPlayerLayer
        self.avPlayer = AVPlayer()
        self.avPlayerLayer = AVPlayerLayer(player: avPlayer)
        self.avPlayerLayer?.videoGravity = AVLayerVideoGravityResizeAspect
        
        // We want video controls so we need an AVPlayerViewController
        self.avPlayerViewConroller = AVPlayerViewController()
        self.avPlayerViewConroller?.player = avPlayer
        
        // Insert the player into the cell view hierarchy and setup autolayout
        self.avPlayerViewConroller!.view.translatesAutoresizingMaskIntoConstraints = false
       
        // Tak: below code isn't working properly. e.g. press play button.
        // insertSubview(avPlayerViewConroller!.view, at: 0)
        self.addSubview(self.avPlayerViewConroller!.view)
        
        self.avPlayerViewConroller!.view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.avPlayerViewConroller!.view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.avPlayerViewConroller!.view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.avPlayerViewConroller!.view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    private func initNewPlayerItem() {
        self.videoAsset?.cancelLoading()
        // Pause the existing video (if there is one)
        self.avPlayer?.pause()
        
        // First we need to make sure we have a valid URL
        guard let videoPlayerItemUrl = self.videoItemUrl else {
            return
        }
        
        // Create a new AVAsset from the URL
        self.videoAsset = AVAsset(url: videoPlayerItemUrl)
        self.videoAsset?.loadValuesAsynchronously(forKeys: ["duration"]) {
            guard self.videoAsset?.statusOfValue(forKey: "duration", error: nil) == .loaded else {
                return
            }
            // Now we need an AVPlayerItem to pass to the AVPlayer
            let videoPlayerItem = AVPlayerItem(asset: self.videoAsset!)
            DispatchQueue.main.async {
                // Finally, we set this as the current AVPlayer item
                self.avPlayer?.replaceCurrentItem(with: videoPlayerItem)
            }
        }
    }
}
