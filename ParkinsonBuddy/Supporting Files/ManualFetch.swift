//
//  ManualFetch.swift
//  ParkinsonBuddy
//
//  Created by Chiara on 29/03/23.
//

import Foundation
import CareKit
import CareKitStore

class ManualFetch{
    
    private var storeManager: OCKSynchronizedStoreManager
    private var events : [OCKAnyEvent]
    private var month : Int
    private var notFull : Bool
    
    init(storeManager: OCKSynchronizedStoreManager){
        self.storeManager = storeManager
        self.events = [OCKAnyEvent]()
        self.month = 0
        self.notFull = false
    }
    
    func fetch(interval: DateInterval, daysInMonth: Int, completion: @escaping (Bool) -> Void){
        let taskQuery = OCKTaskQuery(dateInterval: interval)
        let eventQuery = OCKEventQuery(dateInterval: interval)
        let callbackQueue : DispatchQueue = .main
        
        storeManager.store.fetchAnyTasks(query: taskQuery, callbackQueue: callbackQueue) { result in
            switch result {
            case .failure(let error): completion(true)
            case .success(let tasks):
                guard !tasks.isEmpty else {
                    completion(true)
                    return
                }
                let group = DispatchGroup()
                var error: Error?
                //                var events: [OCKAnyEvent] = []
                for id in tasks.map({ $0.id }) {
                    if id != TaskIDs.onboarding{
                        group.enter()
                        self.storeManager.store.fetchAnyEvents(taskID: id, query: eventQuery, callbackQueue: callbackQueue, completion: { result in
                            switch result {
                            case .failure(let fetchError):
                                error = fetchError
                            case .success(let fetchedEvents):
                                self.events.append(contentsOf: fetchedEvents)
                                self.month = daysInMonth - (self.events.count/(tasks.count - 1))
                            }
                            group.leave()
                        })
                    }
                }
                group.notify(queue: .global(qos: .userInitiated), execute: {
                    if let error = error {
                        callbackQueue.async {
                            completion(true)
                        }
                        return
                    }
                    callbackQueue.async { completion(false) }
                })
            }
        }
    }

            

    func retrieveOutcome(taskID: String, kind: String) -> [TappingDate]{
        
        var outcomes = [TappingDate]()
        var i = 1
        
        while i <= self.month{
            outcomes.append(TappingDate(type: kind, day: "\(i)", count: 0))
            i += 1
        }
        
        events.forEach{ event in
            if event.task.id == taskID{
                outcomes.append(TappingDate(type: kind, day: "\(i)", count: event.answer(kind: kind)))
                i += 1
            }
        }
        return outcomes
    }
    
    
}
