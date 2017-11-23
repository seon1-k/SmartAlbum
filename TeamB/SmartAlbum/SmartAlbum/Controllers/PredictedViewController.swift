//
//  PredictedViewController.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 22..
//  Copyright © 2017년 team-b. All rights reserved.
//

import UIKit
import Photos
import Realm

class PredictedViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var predictedCollectionView: UICollectionView!
    
    // MARK: - Property

    fileprivate var analysisAssets: [AnalysisAsset] = [AnalysisAsset]()
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.5, left: 0.5, bottom: 0.5, right: 0.5)
    fileprivate let itemsPerRow: CGFloat = 2
    
    let realm = RealmManager()

    // MARK: - Initialze
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCollectionView()
        
        self.getAnalysisAssets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.predictedCollectionView.reloadData()
    }
    
    // MARK: - Help function
    
    func getAnalysisAssets() {
        if let objects = realm.getObjects(type: AnalysisAsset.self) {
            self.analysisAssets = objects.toArray(ofType: AnalysisAsset.self) as [AnalysisAsset]
        }
    }
    
    func getImage(assetUrl: String) -> UIImage? {
        let asset = PHAsset.fetchAssets(withLocalIdentifiers: [assetUrl], options: nil)
        guard let result = asset.firstObject else { return nil }
        
        var assetImage: UIImage?
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        PHImageManager.default().requestImage(for: result, targetSize: UIScreen.main.bounds.size, contentMode: PHImageContentMode.aspectFill, options: options) { image, info in
            assetImage = image
        }
        
        return assetImage
    }
    
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PredictedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func initCollectionView() {
        self.predictedCollectionView.delegate = self
        self.predictedCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.analysisAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PredictedAssetCell", for: indexPath) as! PredictedAssetCell
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Prediceted: get selected collectionview itemindex \(indexPath.row)")
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PredictedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let cell = cell as! PredictedAssetCell
        cell.firstLabel.text = "asdasdsd"
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow+1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}
