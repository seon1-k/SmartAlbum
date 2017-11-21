//
//  AssetPreviewViewController.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 20..
//  Copyright © 2017년 team-b. All rights reserved.
//

import UIKit

class AssetPreviewViewController: UIViewController {
    
    // MARK:- Properties
    
    @IBOutlet weak var assetsCollectionView: UICollectionView!
    
    var photoLibrary: PhotoLibrary!
    var passedIndexPath = IndexPath()
    var numberOfSections = 1
    
    // MARK:- Initialize
    
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
        
        coordinator.animate(alongsideTransition: { (context) in
            self.assetsCollectionView.reloadData()
            self.assetsCollectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
    }

    // MARK:- UI Function
    
    func setUI() {
        self.assetsCollectionView.backgroundColor = UIColor.black
    }
    
}

// MARK:- UICollectionViewDelegate, UICollectionViewDataSource {

extension AssetPreviewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func initCollectionView() {
        self.assetsCollectionView.delegate = self
        self.assetsCollectionView.dataSource = self
        self.assetsCollectionView.showsHorizontalScrollIndicator = false
        self.assetsCollectionView.isPagingEnabled = true
        self.assetsCollectionView.register(FullAssetPreviewCell.self, forCellWithReuseIdentifier: "FullAssetPreviewCell")
        self.assetsCollectionView.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleWidth.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoLibrary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullAssetPreviewCell", for: indexPath) as! FullAssetPreviewCell
        return cell
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
   
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let cell = cell as! FullAssetPreviewCell
        self.assetsCollectionView.scrollToItem(at: passedIndexPath, at: .left, animated: false)

        DispatchQueue.global(qos: .background).async {
            self.photoLibrary.setPhoto(at: indexPath.row) { image in
                if let image = image {
                    DispatchQueue.main.async {
                        cell.fullAssetImg.image = image
                    }
                }
            }
        }
    }
    
}
