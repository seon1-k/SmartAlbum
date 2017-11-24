//
//  AlbumListVC.swift
//  SmartAlbum
//
//  Created by 진호놀이터 on 2017. 11. 20..
//  Copyright © 2017년 진호놀이터. All rights reserved.
//

import UIKit
import Photos
import RealmSwift
enum SortType {
    case Date
    case Keyword
    case Location
    
}

private struct UI {
    static let baseMargin = CGFloat(8)
    static let imageSize = CGSize(width: 15, height: 15)
    static let countLabelSize = CGSize(width: 50, height: UI.imageSize.height)
}

class AlbumListVC: UIViewController {
    var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    var albumsList : PHFetchResult<PHAssetCollection>?
    let PHImageManager = PHCachingImageManager()
    var albumName:[String]!
    var sortedAsset:[PHFetchResult<PHAsset>] = []
    var sortType: SortType = .Keyword

    // init
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
          self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.albumName = DBManager.groupByKeyWord().groupKey
        self.sortedAsset = DBManager.groupByKeyWord().groupAssets
    
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
        albumsList = PHFetchResult()
        albumsList = DBManager.getAssets(nil) as? PHFetchResult<PHAssetCollection>
        
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
        
        let alert = UIAlertController(title: "분류기준", message:nil, preferredStyle: .actionSheet)
        let dateAction = UIAlertAction(title:"날짜", style: .default) { (action) in
            
            self.albumName = DBManager.groupByDate().groupKey
            self.sortedAsset = DBManager.groupByDate().groupAssets
            self.sortType = .Date
            self.collectionView.reloadData()
        }
        let locationAction = UIAlertAction(title:"위치", style: .default) { (action) in
            
            
//            self.albumName = DBManager.groupByCity().groupKey
//            self.sortedAsset = DBManager.groupByCity().groupAssets
//            let realm = try! Realm()
//            var citys:[String] = []
//
//            let locs = realm.objects(Location.self)
//            for loc in locs {
//                let location = CLLocation(latitude: loc.value(forKey: "latitude") as! Double, longitude: loc.value(forKey: "longtitude") as! Double)
//                LocationServices.getCity(location: location) { city, error in
//                    if error == nil {
//                        citys.append(city!)
//                    }
//                }
//            }
            
//            let realm = try! Realm()
//            let pictures = realm.objects(Picture.self).filter("location != nil").sorted(byKeyPath: "createDate", ascending: false)
//            let loc = pictures.value(forKey: "location") as! [Location]
////            let ids = pictures.value(forKey: "id") as! [String]
//            LocationServices.getCity(locations: loc) { citys in
////                if error == nil {
//                    self.albumName = citys
//                    self.sortType = .Location
//                    self.collectionView.reloadData()
////
////                    self.sortedAsset = []
////                    var imgArr:[PHAsset] = []
////                    for id in ids {
////                        let fds:PHFetchResult<PHAsset> = PHAsset.fetchAssets(withLocalIdentifiers: [id], options: nil)
////                        imgArr.append(fds.objects(at: I))
////                    }
////                }
//            }
            
            
//            for pic in pictures {
//
//            }
            
//            self.albumName = citys
//            print("citys\(citys)")
            
           
            self.albumName = DBManager.groupByCity().groupKey
            self.sortedAsset = DBManager.groupByCity().groupAssets
            self.sortType = .Keyword
            self.collectionView.reloadData()
        }
        let keywordAction = UIAlertAction(title:"키워드", style: .default) { (action) in
            self.albumName = DBManager.groupByKeyWord().groupKey
            self.sortedAsset = DBManager.groupByKeyWord().groupAssets
            self.sortType = .Keyword
            self.collectionView.reloadData()
        }
        alert.addAction(dateAction)
        alert.addAction(locationAction)
        alert.addAction(keywordAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    @objc private func didTapRightTabBarButtonItem(){
        
        let search = UISearchController (searchResultsController : nil)
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        search.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = search
        self.navigationItem.searchController?.isActive = true
        definesPresentationContext = true
    }
}

extension AlbumListVC:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier:String(describing:AlbumListCell.self), for: indexPath) as! AlbumListCell
        cell.titleLbl.text = albumName[indexPath.row]
        let assets = sortedAsset[indexPath.row]
        PHImageManager.requestImage(for: assets.firstObject!, targetSize: CGSize(width:100, height: 100), contentMode: .aspectFill, options: nil, resultHandler: { image, _ in

                    DispatchQueue.main.async {
                        cell.albumImgView.image = image
                        cell.albumCountLbl.text =  "\(assets.count)"
                }
            })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        //되는거빼고 다지우기
        self.navigationItem.searchController?.obscuresBackgroundDuringPresentation = true
        self.navigationItem.searchController?.isActive = false
        self.navigationItem.searchController = nil
        definesPresentationContext = false
        self.navigationItem.searchController?.obscuresBackgroundDuringPresentation = true
        let asset = sortedAsset[indexPath.row]
        
        let vc = AlbumVC(asset:asset, title:albumName[indexPath.row])
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
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        if(searchText == ""){
            self.albumName = DBManager.groupByKeyWord().groupKey
            self.sortedAsset = DBManager.groupByKeyWord().groupAssets
            
        }else{
            var tempAssets:[PHFetchResult<PHAsset>] = []
            var tempAlbumName:[String] = []
            let realm = try! Realm()
            var keyWord: [String] = []
            
            keyWord = Array(Set(realm.objects(Picture.self).filter("keyword contains %@",searchText).value(forKey: "keyword") as! [String]))
            
            for index in keyWord {
                let  keyWordId = Array(Set(realm.objects(Picture.self).filter("keyword == %@",index).value(forKey: "id") as! [String]))
                //let id = Array(realm.objects(Picture.self).filter("keyword",index).value(forKey: "id") as! [String])
                let fetchResult:PHFetchResult<PHAsset> = PHAsset.fetchAssets(withLocalIdentifiers:keyWordId, options:  PhotoLibrary().getFetchOptions())
                
                tempAssets.append(fetchResult)
                tempAlbumName.append(index)
            }
            sortedAsset = tempAssets
            albumName = tempAlbumName
        }
        collectionView.reloadData()
        
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
        //되는거빼고 다지우기
        self.navigationItem.searchController?.obscuresBackgroundDuringPresentation = true
    
        self.navigationItem.searchController?.isActive = false
        self.navigationItem.searchController = nil
        definesPresentationContext = false
        self.navigationItem.searchController?.obscuresBackgroundDuringPresentation = true
    }
}


