//
//  PredictedViewController.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 22..
//  Copyright © 2017년 team-b. All rights reserved.
//

import UIKit

var tmpPredictedAssetArray = [PredictedAsset]()

class PredictedViewController: UIViewController {
    
    @IBOutlet weak var predictedTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.predictedTableView.reloadData()
    }
    
}

extension PredictedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func initTableView() {
        self.predictedTableView.delegate = self
        self.predictedTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.predictedTableView.dequeueReusableCell(withIdentifier: "PredictedInfoCell", for: indexPath) as! PredictedInfoCell
        cell.predictedImgView.image = tmpPredictedAssetArray[indexPath.row].image
        cell.predictedKeywordLabel.text = tmpPredictedAssetArray[indexPath.row].keyword
        cell.predictedPrbLabel.text = String(tmpPredictedAssetArray[indexPath.row].probability!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tmpPredictedAssetArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
}
