//
//  AllAlbumsViewController.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 20..
//  Copyright © 2017년 team-b. All rights reserved.
//

import UIKit
import Photos

class AllAlbumsViewController: UIViewController {
    
    // MARK:- Properties

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    
    fileprivate var photoLibrary: PhotoLibrary!
    fileprivate var numberOfSections = 0
    fileprivate let sectionInsets = UIEdgeInsets(top: 0.5, left: 0.5, bottom: 0.5, right: 0.5)
    fileprivate let itemsPerRow: CGFloat = 4
    
    // MARK:- Initialize

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Photos"
        
        initCollectionView()
        initPhotoLib()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK:- Navigation control
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AssetPreviewVC" {
            guard let assetPreviewVC = segue.destination as? AssetPreviewViewController else { return }
            guard let selectedIndexPath = sender as? IndexPath else { return }
            
            assetPreviewVC.photoLibrary = self.photoLibrary
            assetPreviewVC.numberOfSections = self.numberOfSections
            assetPreviewVC.passedIndexPath = selectedIndexPath
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
   
}

// MARK:- UICollectionViewDelegate, UICollectionViewDataSource {

extension AllAlbumsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func initCollectionView() {
        self.albumsCollectionView.delegate = self
        self.albumsCollectionView.dataSource = self
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
        self.performSegue(withIdentifier: "AssetPreviewVC", sender: indexPath)
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
