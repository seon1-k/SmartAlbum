//
//  AllAlbumsViewController.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 20..
//  Copyright © 2017년 team-b. All rights reserved.
//

import UIKit
import Photos

protocol SegueProtocol {
    func deleteAllPickedAssets()
}

class AllAlbumsViewController: UIViewController {
    
    // MARK:- Properties
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    
    @IBOutlet weak var pickImagebtn: UIBarButtonItem!
    @IBOutlet weak var doneBtn: UIBarButtonItem!
    
    fileprivate var checkPickImage: Bool = false
    fileprivate var photoLibrary: PhotoLibrary!
    fileprivate var numberOfSections = 0
    fileprivate var pickedAssets: [PHAsset] = [PHAsset]()
    
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.5, left: 0.5, bottom: 0.5, right: 0.5)
    fileprivate let itemsPerRow: CGFloat = 4
    
    // MARK:- Initialize
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initCollectionView()
        initPhotoLib()
        setBarBtnText(show: self.checkPickImage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.albumsCollectionView.reloadData()
    }

    // MARK:- Navigation control
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AssetPreviewVC" {
            guard let assetPreviewVC = segue.destination as? AssetPreviewViewController else { return }
            guard let selectedIndexPath = sender as? IndexPath else { return }
            
            assetPreviewVC.photoLibrary = self.photoLibrary
            assetPreviewVC.numberOfSections = self.numberOfSections
            assetPreviewVC.passedIndexPath = selectedIndexPath
        } else if segue.identifier == "AnalysisVC" {
            guard let analysisVC = segue.destination as? AnalysisViewController else { return }
            
            analysisVC.delegate = self
            analysisVC.pickedImages = self.photoLibrary.convertPHAssetsToUIImages(assetArray: self.pickedAssets)
        }
    }
    
    // MARK:- Help functions
    
    func initPhotoLib() {
        // start spinner
        self.spinner.hidesWhenStopped = true
        self.spinner.startAnimating()
        
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                self.photoLibrary = PhotoLibrary()
                self.numberOfSections = 1
                
                DispatchQueue.main.async {
                    self.albumsCollectionView.reloadData()
                    self.spinner.stopAnimating()
                }
            case .denied, .restricted:
                // TODO: Add alertview
                print("Not allowed")
                self.spinner.stopAnimating()
            case .notDetermined:
                // TODO: Add alertview
                print("Not determined yet")
                self.spinner.stopAnimating()
            }
        }   
    }
    
    func setBarBtnText(show: Bool) {
        if show {
            self.pickImagebtn.title = "취소"
            self.doneBtn.isEnabled = true
            self.doneBtn.title = "완료"
        } else {
            self.pickImagebtn.title = "선택"
            self.doneBtn.isEnabled = false
            self.doneBtn.title = ""
        }
    }
    
    func togglePickBtn() {
        self.checkPickImage = !self.checkPickImage
        
        // change UI
        setBarBtnText(show: self.checkPickImage)
        self.albumsCollectionView.allowsMultipleSelection = self.checkPickImage ? true : false
    }
    
    func customReloadData() {
        // to reload collectionview without animation
        UIView.performWithoutAnimation({
            self.albumsCollectionView.reloadSections(IndexSet(integersIn: 0..<numberOfSections))
        })
    }
    
    // MARK:- Outlet Actions
    
    @IBAction func pressSelectDone(_ sender: UIBarButtonItem) {
        togglePickBtn()
        guard self.pickedAssets.count > 0 else {
            self.customReloadData()
            return
        }
        self.customReloadData()
        self.performSegue(withIdentifier: "AnalysisVC", sender: nil)
    }
    
    @IBAction func pressPickImage(_ sender: UIBarButtonItem) {
        togglePickBtn()

        if !self.checkPickImage {
            self.deleteAllPickedAssets()
            self.customReloadData()
        }
    }
    
}

// MARK:- UICollectionViewDelegate, UICollectionViewDataSource {

extension AllAlbumsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func initCollectionView() {
        self.albumsCollectionView.delegate = self
        self.albumsCollectionView.dataSource = self
        self.albumsCollectionView.allowsMultipleSelection = false
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoLibrary.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AssetCell", for: indexPath) as! AssetCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("get selected collectionview itemindex \(indexPath.row)")
        
        if self.checkPickImage {
            guard let cell = collectionView.cellForItem(at: indexPath) as? AssetCell else { return }
            guard let selectedAsset = self.photoLibrary.getAsset(at: indexPath.row) else { return }
            
            // add asset to array for CoreML
            self.pickedAssets.append(selectedAsset)
            // change Cell's UI
            cell.isHighlighted = true
        } else {
            // show full image
            self.performSegue(withIdentifier: "AssetPreviewVC", sender: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if self.checkPickImage {
            guard let cell = collectionView.cellForItem(at: indexPath) as? AssetCell else { return }
            guard let deSelectedAsset = self.photoLibrary.getAsset(at: indexPath.row) else { return }
            
            // change Cell's UI
            cell.isHighlighted = false
            // delete selected items
            if let index = self.pickedAssets.index(of: deSelectedAsset) {
                self.pickedAssets.remove(at: index)
            }
        }
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AllAlbumsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let cell = cell as! AssetCell
        cell.thumbnail.image = nil
        cell.thumbnail.contentMode = .scaleAspectFill
        cell.thumbnail.clipsToBounds = true
        cell.playIcon.isHidden = true
        
        DispatchQueue(label: "setThumbnail").async {
            self.photoLibrary.setLibrary(mode: .thumbnail, at: indexPath.row) { image, isVideo in
                if let image = image {
                    DispatchQueue.main.async {
                        if isVideo { cell.playIcon.isHidden = false }
                        cell.thumbnail.image = image
                    }
                }
            }
        }
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

// MARK:- SegueProtocol 

extension AllAlbumsViewController: SegueProtocol {
    func deleteAllPickedAssets() {
        self.pickedAssets.removeAll()
    }
}
