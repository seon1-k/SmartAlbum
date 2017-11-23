//
//  AlbumListVC.swift
//  SmartAlbum
//
//  Created by 진호놀이터 on 2017. 11. 20..
//  Copyright © 2017년 진호놀이터. All rights reserved.
//

import UIKit
import Photos
class AlbumListVC: UIViewController {
     var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var albumsList : PHFetchResult<PHAssetCollection>?
    let PHImageManager = PHCachingImageManager()
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        getAlbums()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupBinding()
        //let realm
        
    }
    
    private func setupUI(){
        // UI - navigation
        navigationItem.title = "스마트앨범"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController? .navigationItem.largeTitleDisplayMode = .never
        
        // UI - collectionView
        
        collectionView.backgroundColor = UIColor.white
        collectionView.register(AlbumListCell.self, forCellWithReuseIdentifier:AlbumListCell.indentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top:20, left: 20, bottom: 20, right: 20)
        self.collectionView.collectionViewLayout = layout
        view.addSubview(collectionView)
        
    }
    
    private func setupConstraints(){
        
        //collectionView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        collectionView.bottomAnchor.constraint(equalTo:view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo:view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo:view.trailingAnchor).isActive = true
        
    }
    
    private func setupBinding(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapLeftTabBarButtonItem))
        let rightSearchButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapRightTabBarButtonItem))
        
        self.navigationItem.setRightBarButtonItems([rightSearchButtonItem], animated: true)
    }
    
    @objc private func didTapLeftTabBarButtonItem(){
        
        let alert = UIAlertController(title: "새로운 앨범", message: "이 앨범의 이름을 입력하십시오", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: nil)
        let saveAction = UIAlertAction(title: "저장", style: .default) { (alert) in
            
        }
        alert.addTextField { (textField) in
            textField.placeholder = "제목"
        }
        
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    @objc private func didTapRightTabBarButtonItem(){
        
        
        
        let search = UISearchController (searchResultsController : nil)
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = true
        self.navigationItem.searchController = search
        self.navigationItem.searchController?.isActive = true
        definesPresentationContext = true
        
        
        
    }
    
    func getAlbums() {
        let options:PHFetchOptions = PHFetchOptions()
        self.albumsList  = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: options)
        // 앨범 정보
        guard let albums = albumsList else{return}
        for i in 0 ..< albums.count{
            let collection = albums[i]
            // . localizedTitle = 앨범 타이틀
            let title : String = collection.localizedTitle!
            
            if(collection.estimatedAssetCount != nil){
                // . estimatedAssetCount = 앨범 내 사진 수
                let assetsFetchResult: PHFetchResult = PHAsset.fetchAssets(in: collection, options: nil)
                print("assetsFetchResult.count=\(assetsFetchResult.count)")
                
                let count : Int = collection.estimatedAssetCount
                //  print(count)
                print(title)
            }else{
            }
        }
    }
}

extension AlbumListVC:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumsList!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //메서드로뺴내기
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier:String(describing:AlbumListCell.self), for: indexPath) as! AlbumListCell
        cell.titleLbl.text = albumsList![indexPath.row].localizedTitle
        cell.tag = indexPath.row
        cell.albumImgView.image = nil
        let assetsFetchResult: PHFetchResult = PHAsset.fetchAssets(in: albumsList![indexPath.row], options: nil)
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let fetchResult  = PHAsset.fetchAssets(in:albumsList![indexPath.row], options: fetchOptions)
        let last = fetchResult.lastObject
        
        if let lastAsset = last {
            let options = PHImageRequestOptions()
            options.version = .current
            
            
            PHImageManager.requestImage(for: lastAsset, targetSize: CGSize(width:100, height: 100), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
                
                if cell.tag == indexPath.row
                {
                    DispatchQueue.main.async {
                        cell.albumImgView.image = image
                        cell.albumCountLbl.text = "\(assetsFetchResult.count)"
                        
                    }
                }
            })
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let fetchResult = PHAsset.fetchAssets(in:albumsList![indexPath.row], options: fetchOptions)
        let vc = AlbumVC(asset:fetchResult, title:albumsList![indexPath.row].localizedTitle!)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AlbumListVC: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:UIScreen.main.bounds.width/2 - 30, height:UIScreen.main.bounds.width/2 + 10)
        
    }
}

extension AlbumListVC: UISearchResultsUpdating,UISearchBarDelegate{
    
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
        //되는거빼고 다지우기
        self.navigationItem.searchController?.obscuresBackgroundDuringPresentation = true
        self.navigationItem.searchController?.dismiss(animated: true, completion: nil)
        self.navigationItem.searchController?.isActive = false
        self.navigationItem.searchController = nil
        self.navigationController?.popToRootViewController(animated: true)
        definesPresentationContext = false
        self.navigationItem.searchController?.obscuresBackgroundDuringPresentation = true
    }
}


