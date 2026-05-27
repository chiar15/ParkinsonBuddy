//
//  AppDelegate.swift
//  App
//
//  Created by Chiara on 16/02/23.
//

import UIKit
import CareKit
import CareKitStore
import Foundation
import ResearchKit
import FileProvider
import os.log

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
        
    lazy private(set) var coreDataStore = OCKStore(name: "MyStore", type: .onDisk())
    
    lazy private(set) var storeManager: OCKSynchronizedStoreManager = {
        let coordinator = OCKStoreCoordinator()
        coordinator.attach(store: coreDataStore)
        return OCKSynchronizedStoreManager(wrapping: coordinator)
    }()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        
        let clearCategory = UNNotificationCategory(identifier: "clear.category",
            actions: [], intentIdentifiers: [], options: .customDismissAction)
            
        UNUserNotificationCenter.current().setNotificationCategories([clearCategory])
        
        let content1 = UNMutableNotificationContent()
        content1.title = "Tapping Test, Trail Making Test and Memory Test Available"
        content1.body = "You can finally do the finger tapping test, trail making test and memory test. Open the app to continue."
        content1.sound = UNNotificationSound.default
        content1.categoryIdentifier = "clear.category"
        content1.badge = 1
        
    
        let content2 = UNMutableNotificationContent()
        content2.title = "Check In Task Available"
        content2.body = "You can finally do the check-in task. Open the app to continue."
        content2.sound = UNNotificationSound.default
        content2.categoryIdentifier = "clear.category"
        content2.badge = 1
        
        // Crea il trigger per la notifica 1
        var dateComponents1 = DateComponents()
        dateComponents1.hour = 0
        dateComponents1.minute = 0
        let trigger1 = UNCalendarNotificationTrigger(dateMatching: dateComponents1, repeats: false)
        
        // Crea il trigger per la notifica 2
        var dateComponents2 = DateComponents()
        dateComponents2.hour = 16
        dateComponents2.minute = 00
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComponents2, repeats: false)
        
        // Crea la richiesta per la notifica 1
        let request1 = UNNotificationRequest(identifier: "notifica1", content: content1, trigger: trigger1)
                
        // Crea la richiesta per la notifica 2
        let request2 = UNNotificationRequest(identifier: "notifica2", content: content2, trigger: trigger2)
                
        // Aggiungi le richieste alla coda delle notifiche del centro notifiche
        UNUserNotificationCenter.current().add(request1) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Notifica 1 programmata!")
            }
        }
                
        UNUserNotificationCenter.current().add(request2) { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("Notifica 2 programmata!")
            }
        }
        
        
        coreDataStore.populateSampleData()
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let application = UIApplication.shared
        let badgeCount = application.applicationIconBadgeNumber

        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            if badgeCount > 0 {
                application.applicationIconBadgeNumber = badgeCount - 1
                UserDefaults.standard.set(badgeCount - 1, forKey: "badgeCount")
            }
        default:
            print("Default Identifier")
        }
                completionHandler()
            }
    
    func setApplicationIconBadgeNumber() {
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            let myAppNotifications = notifications.filter { $0.request.identifier == "notifica1" || $0.request.identifier == "notifica2" }
            let badgeCount = myAppNotifications.count
            DispatchQueue.main.async {
                UIApplication.shared.applicationIconBadgeNumber = badgeCount
                UserDefaults.standard.set(badgeCount, forKey: "badgeCount")
            }
        }
    }

}
    private extension OCKStore{
        func populateSampleData()  {
            
        
//            do{
//                try self.reset()
//            }catch{
//                print("Failed to reset the store")
//            }
           
            var tappingTask = OCKTask(
                id: TaskIDs.tappingCheck,
                title: "Digital Two Fingers Tapping Test",
                carePlanUUID: nil,
                schedule: .dailyAtTime(hour: 0, minutes: 0, start: Calendar.current.startOfDay(for: Date()), end: nil, text: "Anytime", duration: .allDay)
            )
            
            tappingTask.instructions = "Tap the button as fast as you can!"
            tappingTask.impactsAdherence = true
            
            var onboardTask = OCKTask(
                id: TaskIDs.onboarding,
                title: "Informed Consent",
                carePlanUUID: nil,
                schedule: .dailyAtTime(hour: 0, minutes: 0, start: Date(), end: nil, text: "Task Due!")
            )

            onboardTask.instructions = "You'll need to agree to some terms and conditions before we get started!"
            onboardTask.impactsAdherence = false
            
            
            var checkInTask = OCKTask(
                id: TaskIDs.checkIn,
                title: "Check In",
                carePlanUUID: nil,
                schedule: .dailyAtTime(hour: 16, minutes: 0, start: Date(), end: nil, text: nil, duration: .seconds(28799))
            )
            
            checkInTask.impactsAdherence = true
            
            var trailMakingTask = OCKTask(
                id: TaskIDs.trailMakingTest,
                title: "Trail Making Test",
                carePlanUUID: nil,
                schedule: .dailyAtTime(hour: 0, minutes: 0, start: Date(), end: nil, text: "Anytime", duration: .allDay)
            )
            
            trailMakingTask.instructions = "Connect the dots in the right order!"
            trailMakingTask.impactsAdherence = true
            
            var memoryTask = OCKTask(
                id: TaskIDs.memoryTest,
                title: "Memory Test",
                carePlanUUID: nil,
                schedule: .dailyAtTime(hour: 0, minutes: 0, start: Date(), end: nil, text: "Anytime", duration: .allDay)
            )
            
            memoryTask.instructions = "Repeat a sequence of lit-up flowers by tapping them in the correct order"
            memoryTask.impactsAdherence = true
            
            addAnyTasks([onboardTask, memoryTask, trailMakingTask, tappingTask, checkInTask], callbackQueue: .main) { result in
                switch result {
                case let .success(tasks):
                    print("Seeded \(tasks.count) tasks")
                case let .failure(error):
                    print("Failed to seed tasks: \(error as NSError)")
                }
            }
        }
    }


