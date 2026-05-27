//
//  SceneDelegate.swift
//  App
//
//  Created by Chiara on 16/02/23.
//

import UIKit
import CareKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UITabBarControllerDelegate {
    var hasVisitedOverview = false

    var storeManager: OCKSynchronizedStoreManager {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        return delegate.storeManager
    }
    
    var window: UIWindow?
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        
        let feed = CareFeedViewController(storeManager: appDelegate.storeManager)
        feed.title = "Care Feed"
        feed.tabBarItem = UITabBarItem(
            title: "Care Feed",
            image: UIImage(systemName: "heart.text.square"),
            tag: 0
        )

        let insights = InsightsViewController(storeManager: appDelegate.storeManager)
        insights.title = "Insights"
        insights.tabBarItem = UITabBarItem(
            title: "Insights",
            image: UIImage(systemName: "waveform.path.ecg"),
            tag: 1
        )
        
        let overview = OverviewViewController(storeManager: appDelegate.storeManager)
        overview.title = "Overview"
        overview.tabBarItem = UITabBarItem(
            title: "Overview",
            image: UIImage(systemName: "list.clipboard"),
            tag: 2
        )
        
        
        UITabBar.appearance().tintColor = #colorLiteral(red: 0.008545586839, green: 0.3427913189, blue: 0.7722392678, alpha: 1)

        UITabBar.appearance().unselectedItemTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        UITabBar.appearance().backgroundColor = UIColor.systemGroupedBackground


        
        let root = UITabBarController()
        root.delegate = self
        let feedTab = UINavigationController(rootViewController: feed)
        let insightsTab = UINavigationController(rootViewController: insights)
        let overviewTab = UINavigationController(rootViewController: overview)
        root.setViewControllers([feedTab, insightsTab, overviewTab], animated: false)

        
        
//        root.tabBar.barTintColor = UIColor.systemBackground
        
        
        window = UIWindow(windowScene: scene as! UIWindowScene)
        window?.rootViewController = root
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        if let navController = viewController as? UINavigationController,
           let _ = navController.viewControllers.first as? OverviewViewController,
            navController.tabBarItem.tag == 2 {
            let newExportVC = OverviewViewController(storeManager: storeManager)
            newExportVC.title = "Overview"
            newExportVC.tabBarItem = UITabBarItem(
                title: "Overview",
                image: UIImage(systemName: "list.clipboard"),
                tag: 2
            )
            if (hasVisitedOverview == true){
                navController.setViewControllers([newExportVC], animated: true)
            }else{
                navController.setViewControllers([newExportVC], animated: false)
                hasVisitedOverview = true
            }
        }
    }



}

