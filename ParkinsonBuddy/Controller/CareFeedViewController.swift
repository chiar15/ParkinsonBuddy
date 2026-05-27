//
//  HomeViewController.swift
//  App
//
//  Created by Chiara on 16/02/23.
//

import UIKit
import CareKit
import CareKitUI
import CareKitStore
import SwiftUI
import Foundation
import ResearchKit
import Combine


class CareFeedViewController: OCKDailyPageViewController, OCKSurveyTaskViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        if let statusBarFrame = UIApplication.shared.statusBarFrame as CGRect? {
                let statusBarView = UIView(frame: statusBarFrame)
                statusBarView.backgroundColor = UIColor.systemGroupedBackground // sostituisci con il colore desiderato
                view.addSubview(statusBarView)
            }
        }
    
    override func dailyPageViewController(_ dailyPageViewController: OCKDailyPageViewController, prepare listViewController: OCKListViewController, for date: Date) {
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.systemGroupedBackground
        
        checkIfOnboardingIsComplete { isOnboarded in
            
            
            let isFuture = Calendar.current.compare(
                date,
                to: Date(),
                toGranularity: .day) == .orderedDescending
            
            let isPast = Calendar.current.compare(date,
                to: Date(),
                toGranularity: .day) == .orderedAscending
            
            guard isOnboarded else {

                let onboardCard = CustomSurveyTaskViewController(
                    taskID: TaskIDs.onboarding,
                    eventQuery: OCKEventQuery(for: date),
                    storeManager: self.storeManager,
                    survey: Surveys.onboardingSurvey(),
                    extractOutcome: { _ in [OCKOutcomeValue(Date())] }
                )

                
                onboardCard.view.isUserInteractionEnabled = !isFuture
                onboardCard.view.alpha = isFuture ? 0.4 : 1.0
                onboardCard.view.isHidden = isPast
                
                onboardCard.surveyDelegate = self

                listViewController.appendViewController(
                    onboardCard,
                    animated: false
                )

                return
            }
            
            self.fetchTasks(on: date) { tasks in
                tasks.compactMap {
                    
                    let card = self.taskViewController(for: $0, on: date)
                    card?.view.isUserInteractionEnabled = !(isFuture || isPast)
                    card?.view.alpha = (isFuture || isPast) ? 0.4 : 1.0
                    if $0.id == TaskIDs.checkIn{
                        let compareDate = ($0.schedule.events(from: Date(), to: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date())).first?.start ?? Date()
                        
                        let future = Calendar.current.compare(
                            compareDate,
                            to: Date(),
                            toGranularity: .hour) == .orderedDescending
                        card?.view.isUserInteractionEnabled = !(isPast || future || isFuture)
                        card?.view.alpha = (isFuture || future || isPast) ? 0.4 : 1.0
                    }
                    return card
                    
                }.forEach {
                    listViewController.appendViewController($0, animated: false)
                    
                }
            }
            
            func surveyTask(
                viewController: OCKSurveyTaskViewController,
                for task: OCKAnyTask,
                didFinish result: Result<ORKTaskViewControllerFinishReason, Error>) {
                    
                    if case let .success(reason) = result, reason == .completed {
                        self.reload()
                    }
                    
                }
        
        func surveyTask(
            viewController: OCKSurveyTaskViewController,
            shouldAllowDeletingOutcomeForEvent event: OCKAnyEvent) -> Bool {

            event.scheduleEvent.start >= Calendar.current.startOfDay(for: Date())
        }
            
}
        
}
    
    private func checkIfOnboardingIsComplete(_ completion: @escaping(Bool) -> Void){
        var query = OCKOutcomeQuery()
        query.taskIDs = [TaskIDs.onboarding]

        storeManager.store.fetchAnyOutcomes(
            query: query,
            callbackQueue: .main) { result in

            switch result {

            case .failure:
                print("Failed to fetch onboarding outcomes!")
                completion(false)

            case let .success(outcomes):
                completion(!outcomes.isEmpty)
            }
        }
    }
    
    private func fetchTasks(
        on date: Date,
        completion: @escaping([OCKAnyTask]) -> Void) {
            
            var query = OCKTaskQuery(for: date)
            query.excludesTasksWithNoEvents = true
            
            storeManager.store.fetchAnyTasks(
                query: query,
                callbackQueue: .main){ result in
                    
                    switch result {

                                case .failure:
                                    print("Failed to fetch tasks for date \(date)")
                                    completion([])

                                case let .success(tasks):
                        
                                    completion(tasks)
                                }
                }
        }
    
    private func taskViewController(
            for task: OCKAnyTask,
            on date: Date) -> UIViewController? {

            switch task.id {

            case TaskIDs.tappingCheck:
                let survey = CustomSurveyTaskViewController(
                    task: task,
                    eventQuery: OCKEventQuery(for: date),
                    storeManager: storeManager,
                    survey: Surveys.tappingCheck(),
                    viewSynchronizer: SurveyViewSynchronizer(),
                    extractOutcome: Surveys.extractTappingOutcome
                    
                )
                
                survey.surveyDelegate = self
                
                return survey
            case TaskIDs.checkIn:
                let survey = CustomSurveyTaskViewController(
                    task: task,
                    eventQuery: OCKEventQuery(for: date),
                    storeManager: storeManager,
                    survey: Surveys.checkInSurvey(),
                    viewSynchronizer: CheckInViewSynchronizer(),
                    extractOutcome: Surveys.extractAnswersFromCheckInSurvey
                )
                
                survey.surveyDelegate = self
                
                return survey
                
            case TaskIDs.trailMakingTest:
                    let survey = CustomSurveyTaskViewController(
                        task: task,
                        eventQuery: OCKEventQuery(for: date),
                        storeManager: storeManager,
                        survey: Surveys.trailMakingTask(),
                        viewSynchronizer: SurveyViewSynchronizer(),
                        extractOutcome: Surveys.extractTrailMakingOutcome
                    )

                    survey.surveyDelegate = self
                
                    return survey
                
            case TaskIDs.memoryTest:
                    let survey = CustomSurveyTaskViewController(
                        task: task,
                        eventQuery: OCKEventQuery(for: date),
                        storeManager: storeManager,
                        survey: Surveys.memoryTask(),
                        viewSynchronizer: SurveyViewSynchronizer(),
                        extractOutcome: Surveys.extractMemoryOutcome
                    )

                    survey.surveyDelegate = self
                
                    return survey
                
            default:
                return nil
            }
        }
}

final class CheckInViewSynchronizer: OCKSurveyTaskViewSynchronizer {

//    override func makeView() -> OCKInstructionsTaskView{
//        let view = super.makeView()
//        view.headerView.detailLabel.text = "Anytime"
//        return view
//    }
    override func updateView(
        _ view: OCKInstructionsTaskView,
        context: OCKSynchronizationContext<OCKTaskEvents>) {

        super.updateView(view, context: context)

        if let event = context.viewModel.first?.first, event.outcome != nil{
            view.instructionsLabel.isHidden = false
            
            let pain = event.answer(kind: Surveys.checkInPainItemIdentifier)
            let sleep = event.answer(kind: Surveys.checkInSleepItemIdentifier)
        } else {
            view.instructionsLabel.isHidden = true
        }
            
            view.headerView.detailLabel.text = "You can do this task from 4 pm"
    }
}

final class SurveyViewSynchronizer: OCKSurveyTaskViewSynchronizer {

    override func updateView(
        _ view: OCKInstructionsTaskView,
        context: OCKSynchronizationContext<OCKTaskEvents>) {

        super.updateView(view, context: context)

            
        view.headerView.detailLabel.text = "You can do this task at any time"
    }
}
