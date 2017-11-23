//
//  AnalyzedViewController.swift
//  SmartAlbum
//
//  Created by 진형탁 on 2017. 11. 24..
//  Copyright © 2017년 team-b. All rights reserved.
//

import UIKit
import RealmSwift

class AnalyzedViewController: UIViewController {
    
    var selectedObjs: Results<AnalysisAsset>?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(selectedObjs?.count)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
