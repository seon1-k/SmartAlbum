//
//  AppDelegate.swift
//  SmartAlbum
//
//  Created by 진호놀이터 on 2017. 11. 19..
//  Copyright © 2017년 진호놀이터. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let main = AlbumListVC(nibName: nil, bundle: nil)
        let navigationController = UINavigationController(rootViewController: main)
        
        self.window?.rootViewController = navigationController
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        
        
        return true
    }

import Photos
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var rootVC: AlbumListVC!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        
       rootVC = AlbumListVC(nibName: nil, bundle: nil)
        let navigationController = UINavigationController(rootViewController: rootVC)
        self.window?.rootViewController = navigationController
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                
                
                
                PHPhotoLibrary.requestAuthorization { (status) in
                    switch status {
                    case .authorized:
                        
                        
                        if UserDefaults.standard.bool(forKey: "launchedBefore") {
                            //첫 실행 아님. 업데이트
                            print("not first launch")
                            DBManager.updateData() { _ in
                                DispatchQueue.main.async {
                                    //       self.rootVC?.indicator.stopAnimating()
                                    self.rootVC?.collectionView.reloadData()
                                }
                            }
                        }else {
                            //첫 실행
                            print("first launch")
                            DBManager.initData(isFirst: true){_ in
                                UserDefaults.standard.set(true, forKey: "launchedBefore")
                                
                                DispatchQueue.main.async {
                                    //       self.rootVC?.indicator.stopAnimating()
                                    self.rootVC?.collectionView.reloadData()
                                }
                            }
                        }
                        
                        DispatchQueue.main.async {
                            
                            self.rootVC.indicator.stopAnimating()
                            self.rootVC.collectionView.reloadData()
                        }
                    case .denied, .restricted:
                        print("Not allowed")
                        self.rootVC.indicator.stopAnimating()
                    case .notDetermined:
                        print("Not determined yet")
                        self.rootVC.indicator.stopAnimating()
                    }
                }
                
                
                

            case .denied, .restricted:
                print("Not allowed")
              // self.rootVC?.indicator.stopAnimating()
            case .notDetermined:
                print("Not determined yet")
            //self.rootVC?.indicator.stopAnimating()
            }
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
         */
        let container = NSPersistentContainer(name: "SmartAlbum")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
}

