//
//  AssetPreviewViewController.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 20..
//  Copyright © 2017년 team-b. All rights reserved.
//

import UIKit
import AVKit
import Photos

class AssetPreviewViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet weak var assetsCollectionView: UICollectionView!
    
    var photoLibrary: PhotoLibrary!
    var passedIndexPath = IndexPath()
    var numberOfSections = 1
    var onceOnly = false
    var selectedObjs: [AnalysisAsset] = [AnalysisAsset]()
    
    // MARK: - Initialize
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // init
        setUI()
        initCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        let offset = self.assetsCollectionView.contentOffset
        let width  = self.assetsCollectionView.bounds.size.width
        
        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        
        self.assetsCollectionView.setContentOffset(newOffset, animated: false)
        
        coordinator.animate(alongsideTransition: { (_) in
            self.assetsCollectionView.reloadData()
            self.assetsCollectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
    }
    
    // MARK: - UI Function
    
    func setUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.assetsCollectionView.backgroundColor = UIColor.black
    }
    
    // MARK: - Helper
    
    func getImage(assetUrl: String) -> UIImage? {
        let asset = PHAsset.fetchAssets(withLocalIdentifiers: [assetUrl], options: nil)
        guard let result = asset.firstObject else { return nil }
        
        var assetImage: UIImage?
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        let size: CGSize = UIScreen.main.bounds.size
        PHImageManager.default().requestImage(for: result, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: options) { (image, _) in
            assetImage = image
        }
        
        return assetImage
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource {

extension AssetPreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func initCollectionView() {
        self.assetsCollectionView.delegate = self
        self.assetsCollectionView.dataSource = self
        self.assetsCollectionView.showsHorizontalScrollIndicator = false
        self.assetsCollectionView.isPagingEnabled = true
        self.assetsCollectionView.register(FullAssetPreviewCell.self, forCellWithReuseIdentifier: "FullAssetPreviewCell")
        self.assetsCollectionView.register(FullVideoCell.self, forCellWithReuseIdentifier: "FullVideoCell")
        self.assetsCollectionView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.selectedObjs.count > 0 {
            return self.selectedObjs.count
        }
        return self.photoLibrary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.selectedObjs.count > 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullAssetPreviewCell", for: indexPath) as! FullAssetPreviewCell
            return cell
        } else {
            let asset = self.photoLibrary.getAsset(at: indexPath.row)
            if asset?.mediaType == .video {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullVideoCell", for: indexPath) as! FullVideoCell
                asset?.getURL() { url in
                    cell.videoItemUrl = url
                }
                return cell
            } else { // .image
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullAssetPreviewCell", for: indexPath) as! FullAssetPreviewCell
                return cell
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        // scroll to selected cell
        if !onceOnly {
            self.assetsCollectionView.scrollToItem(at: passedIndexPath, at: .left, animated: false)
            onceOnly = true
        }
        
        // Show analyzed data
        if self.selectedObjs.count > 0 {
            let image = getImage(assetUrl: self.selectedObjs[indexPath.row].url)
            DispatchQueue.main.async {
                let cell = cell as! FullAssetPreviewCell
                cell.fullAssetImg.image = image
            }
        } else {
            // Show media data
            if let asset = self.photoLibrary.getAsset(at: indexPath.row) {
                DispatchQueue.main.async {
                    if asset.mediaType == .video {
                        let cell = cell as! FullVideoCell
                        cell.avPlayer?.play()
                    } else { // .image
                        let cell = cell as! FullAssetPreviewCell
                        cell.fullAssetImg.image = self.photoLibrary.getPhoto(at: indexPath.row)
                    }
                }
            }
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AssetPreviewViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewHeight = self.assetsCollectionView.bounds.height
        let collectionViewWidth = self.assetsCollectionView.bounds.width
        return CGSize(width: collectionViewWidth, height: collectionViewHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0.0, 0.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
}

extension AssetPreviewViewController {
    // to pause video when dragging
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let indexPath = self.assetsCollectionView.indexPathsForVisibleItems.first
        
        if self.selectedObjs.count > 0 {
            if self.selectedObjs[(indexPath?.row)!].isVideo {
                let cell = self.assetsCollectionView.cellForItem(at: indexPath!) as! FullVideoCell
                cell.avPlayer?.pause()
            }
        } else {
            if let asset = self.photoLibrary.getAsset(at: (indexPath?.row)!),
                asset.mediaType == .video {
                let cell = self.assetsCollectionView.cellForItem(at: indexPath!) as! FullVideoCell
                cell.avPlayer?.pause()
            }
        }
    }
}
