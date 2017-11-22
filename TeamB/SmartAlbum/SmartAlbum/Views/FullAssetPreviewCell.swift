//
//  FullAssetPreviewCell.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 20..
//  Copyright © 2017년 team-b. All rights reserved.
//

import UIKit

class FullAssetPreviewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    // MARK:- Properties
    
    var scrollImg: UIScrollView!
    var fullAssetImg: UIImageView!

    // MARK:- Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setScrollView()
        setFullImgView()
        self.addSubview(self.scrollImg)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scrollImg.frame = self.bounds
        self.fullAssetImg.frame = self.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.scrollImg.setZoomScale(1, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK:- Set default view
    
    func setFullImgView() {
        self.fullAssetImg = UIImageView()
        self.fullAssetImg.image = nil
        self.fullAssetImg.contentMode = .scaleAspectFit
        self.scrollImg.addSubview(self.fullAssetImg)
    }

    func setScrollView() {
        // Set Scroll View
        self.scrollImg = UIScrollView()
        self.scrollImg.delegate = self
        self.scrollImg.alwaysBounceVertical = false
        self.scrollImg.alwaysBounceHorizontal = false
        self.scrollImg.showsVerticalScrollIndicator = true
        self.scrollImg.flashScrollIndicators()
        self.scrollImg.minimumZoomScale = 1.0
        self.scrollImg.maximumZoomScale = 4.0
        
        // Add double tap gesture
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        self.scrollImg.addGestureRecognizer(doubleTapGest)
    }
    
    // MARK:- Gesture Function
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollImg.zoomScale == 1 {
            scrollImg.zoom(to: zoomRectForScale(scale: scrollImg.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollImg.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = self.fullAssetImg.frame.size.height / scale
        zoomRect.size.width = self.fullAssetImg.frame.size.width / scale
        let newCenter = self.fullAssetImg.convert(center, from: scrollImg)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.fullAssetImg
    }
}
