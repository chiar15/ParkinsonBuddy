//
//  CustomSurveyTaskViewController.swift
//  App
//
//  Created by Chiara on 23/02/23.
//

import Foundation
import CareKitUI
import CareKit
import CareKitStore
import UIKit

class CustomSurveyTaskViewController: OCKSurveyTaskViewController {
    
    override func didSelectTaskView(_ taskView: UIView & OCKTaskDisplayable, eventIndexPath: IndexPath) {
        
        var detailImageFileName: String
        var summary: String
        
        
        
        switch self.survey.identifier{
        case TaskIDs.onboarding:
            detailImageFileName = "consent"
            summary = "This informed consent document outlines the expectations and requirements of participating in a study for individuals already diagnosed with Parkinson's disease."
        case TaskIDs.tappingCheck:
            detailImageFileName = "tap"
            summary = "The digital two finger tapping test is a cognitive assessment tool that involves tapping two buttons with the fingers of one hand and then repeating the same task with the other hand. The test measures the tapping speed of each hand"
        case TaskIDs.checkIn:
            detailImageFileName = "checkin"
            summary = "This is a survey designed to collect information about the daily non-motor symptoms of Parkinson's disease. The task involves asking the user questions to assess the presence and intensity of common non-motor Parkinson's symptoms such as pain, sleeping problems, fatigue and nausea. The goal of this survey is to gather useful information to evaluate the effectiveness of treatment and to assist the doctor in monitoring the progression of the disease over time."
        case TaskIDs.trailMakingTest:
            detailImageFileName = "connectDots"
            summary = "The Trail Making Test is a task designed to assess cognitive abilities in people with Parkinson's disease. Participants must join numbered sequences in order as quickly as possible, with errors deducted from their score. The test assesses attention, working memory, visual-spatial processing, and processing speed. Results can aid monitoring of Parkinson's, as well as identify cognitive deficits in other neurological disorders."
        case TaskIDs.memoryTest:
            detailImageFileName = "memory"
            summary = "The task involves memorizing the sequence in which flowers light up and then repeating it to assess cognitive abilities. The task is intended to measure cognitive abilities, such as memory and attention, and can be adapted to suit different skill levels. The task is beneficial for individuals with Parkinson's disease because it can help improve cognitive function and may be used as a tool to track disease progression over time."
        default:
            return
        }
        
        do {
                    let detailsViewController = try controller.initiateDetailsViewController(forIndexPath: eventIndexPath)
            detailsViewController.detailView.imageView.image = UIImage(named: detailImageFileName)
            detailsViewController.detailView.bodyLabel.text = summary
                    present(detailsViewController, animated: true)
                } catch {
                    if delegate == nil {
                        print("CareKit error: A task error occurred, but no delegate was set to forward it to! \(error)")
                    }
                    delegate?.taskViewController(self, didEncounterError: error)
                }
    }
    
    
}
