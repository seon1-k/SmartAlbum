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
import RealmSwift

class PredictedViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var predictedCollectionView: UICollectionView!
    @IBOutlet weak var sortSegmented: UISegmentedControl!
    
    // MARK: - Property
    
    fileprivate var photoLibrary: PhotoLibrary!
    fileprivate var analysisAssets: [AnalysisAsset] = [AnalysisAsset]()
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.5, left: 0.5, bottom: 0.5, right: 0.5)
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let unAnalyzedCollection = 1
    
    let realm = RealmManager()
    // Default value is keyword
    var realmObjects = try! Realm().objects(AnalysisAsset.self).sorted(byKeyPath: "keyword", ascending: false)
    var sortBy: String = "keyword" {
        didSet {
            self.realmObjects = try! Realm().objects(AnalysisAsset.self).sorted(byKeyPath: sortBy, ascending: false)
            self.predictedCollectionView.reloadData()
        }
    }
    var collectionNames: [String] {
        return Set(realmObjects.value(forKeyPath: sortBy) as! [String]).sorted { $0 > $1 }
    }
    
    // MARK: - Initialze
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.photoLibrary = PhotoLibrary()
        self.sortSegmented.selectedSegmentIndex = 2
        
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
        let size = CGSize(width: 200, height: 200)
        PHImageManager.default().requestImage(for: result, targetSize: size, contentMode: PHImageContentMode.aspectFill, options: options) { (image, _) in
            assetImage = image
        }
        
        return assetImage
    }
    
    // MARK: - Outlet Function
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        switch self.sortSegmented.selectedSegmentIndex {
        case 0:
            self.sortBy = "creationDate"
        case 1:
            self.sortBy = "location"
        case 2:
            self.sortBy = "keyword"
        default:
            print("default")
        }
    }
    
    // MARK: - Navigation control
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AnalyzedVC" {
            guard let analyzedVC = segue.destination as? AnalyzedViewController else { return }
            guard let selectedIndexPath = sender as? IndexPath else { return }
            print(self.realmObjects.filter("\(self.sortBy) == %@", self.collectionNames[selectedIndexPath.row]))
            
            analyzedVC.selectedObjs = self.realmObjects.filter("\(self.sortBy) == %@", self.collectionNames[selectedIndexPath.row])
        }
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension PredictedViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func initCollectionView() {
        self.predictedCollectionView.delegate = self
        self.predictedCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionNames.count + self.unAnalyzedCollection
    }
    
    func setupCell(cell: UICollectionViewCell, indexPath: IndexPath, type: String) {
        switch(type) {
        case "PredictedAssetCell":
            if let cell = cell as? PredictedAssetCell {
                setupPredictedCell(cell: cell, indexPath: indexPath)
            }
        case "LastSpecialCell":
            if let cell = cell as? LastSpecialCell {
                setupLastSpecialCell(cell: cell, indexPath: indexPath)
            }
        default:
            break
        }
    }
    
    // LastSpecialCell
    func setupLastSpecialCell(cell: LastSpecialCell, indexPath: IndexPath) {
        // compare with DB
        var count = self.photoLibrary.count - self.analysisAssets.count
        count = count < 0 ? 0 : count
        cell.firstLabel.text = "분류되지 않은 사진들"
        cell.countLabel.text = String(count)
    }
    
    // PredictedCell
    func setupPredictedCell(cell: PredictedAssetCell, indexPath: IndexPath) {
        let data = self.realmObjects.filter("\(self.sortBy) == %@", self.collectionNames[indexPath.row])
        DispatchQueue.main.async {
            cell.firstLabel.text = self.collectionNames[indexPath.row]
            cell.thirdLabel.text = String(data.count)
            if let url = data.first?.url {
                cell.thumbnailImgView.imageFromAssetURL(assetURL: url)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // not analysis
        let cellID = indexPath.row < self.collectionNames.count ? "PredictedAssetCell" : "LastSpecialCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        setupCell(cell: cell, indexPath: indexPath, type: cellID)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Prediceted: get selected collectionview itemindex \(indexPath.row)")
        self.performSegue(withIdentifier: "AnalyzedVC", sender: indexPath)
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PredictedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        
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
